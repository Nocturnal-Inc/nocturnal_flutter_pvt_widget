import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:psychomotor_vigilance_test/src/models/pvt_config.dart';
import 'package:psychomotor_vigilance_test/src/models/pvt_result.dart';
import 'package:psychomotor_vigilance_test/src/models/trial_data.dart';
import 'package:psychomotor_vigilance_test/src/services/feedback_service.dart';
import 'package:psychomotor_vigilance_test/src/services/statistics_service.dart';
import 'package:psychomotor_vigilance_test/src/utils/random_interval.dart';

/// The current state of the PVT test.
enum PvtState {
  /// Test has not started yet.
  idle,

  /// Showing instructions before test begins.
  instructions,

  /// Countdown before test begins.
  countdown,

  /// Waiting for the next stimulus to appear.
  waitingForStimulus,

  /// Stimulus is currently shown, waiting for response.
  stimulusShown,

  /// Showing reaction time feedback after response.
  showingFeedback,

  /// Practice test is complete, showing transition screen.
  practiceComplete,

  /// Test is complete.
  complete,
}

/// Controller for managing the PVT test state and logic.
///
/// This controller handles:
/// - Test state transitions
/// - High-precision reaction time measurement
/// - Random inter-stimulus interval generation
/// - Trial data recording
/// - False start and lapse detection
class PvtController extends ChangeNotifier {
  /// Creates a new PVT controller.
  PvtController({
    required PvtConfig config,
    VoidCallback? onComplete,
  })  : _config = config,
        _onComplete = onComplete,
        _intervalGenerator = RandomIntervalGenerator(
          minInterval: config.minInterStimulusInterval,
          maxInterval: config.maxInterStimulusInterval,
        );

  final PvtConfig _config;
  final VoidCallback? _onComplete;
  final RandomIntervalGenerator _intervalGenerator;
  final FeedbackService _feedbackService = FeedbackService.instance;

  // State
  PvtState _state = PvtState.idle;
  int _countdownValue = 0;
  int _currentTrialNumber = 0;
  final List<TrialData> _trials = [];

  // Practice mode state
  bool _isPracticeMode = false;
  final List<TrialData> _practiceTrials = [];
  bool _practiceSkipped = false;

  // Timing
  final Stopwatch _testStopwatch = Stopwatch();
  final Stopwatch _trialStopwatch = Stopwatch();
  DateTime? _testStartTime;
  DateTime? _testEndTime;
  DateTime? _stimulusOnsetTime;

  // Timers
  Timer? _countdownTimer;
  Timer? _stimulusTimer;
  Timer? _testDurationTimer;
  Timer? _timerUpdateTimer;
  Timer? _feedbackTimer;

  // Feedback
  int? _lastReactionTimeMs;
  Duration? _feedbackDuration;

  // Instructions
  bool _showInstructions = false;

  // Getters
  /// The current state of the test.
  PvtState get state => _state;

  /// The current countdown value (seconds remaining).
  int get countdownValue => _countdownValue;

  /// The current trial number.
  int get currentTrialNumber => _currentTrialNumber;

  /// The test configuration.
  PvtConfig get config => _config;

  /// Whether the stimulus is currently visible.
  bool get isStimulusVisible => _state == PvtState.stimulusShown;

  /// Whether the controller is currently in practice mode.
  bool get isPracticeMode => _isPracticeMode;

  /// The elapsed time in the current trial (for display purposes).
  int get currentTrialElapsedMs {
    if (_state != PvtState.stimulusShown) return 0;
    return _trialStopwatch.elapsedMilliseconds;
  }

  /// The elapsed test time.
  Duration get elapsedTestTime {
    if (!_testStopwatch.isRunning && _testStartTime == null) {
      return Duration.zero;
    }
    return _testStopwatch.elapsed;
  }

  /// The remaining test time.
  Duration get remainingTestTime {
    final elapsed = elapsedTestTime;
    final testDuration = _isPracticeMode
        ? PvtConfig.practiceTestDuration
        : _config.duration;
    if (elapsed >= testDuration) return Duration.zero;
    return testDuration - elapsed;
  }

  /// The last recorded reaction time in milliseconds.
  ///
  /// Used for displaying feedback after a response.
  int? get lastReactionTimeMs => _lastReactionTimeMs;

  /// Sets the duration for showing reaction time feedback.
  ///
  /// If null, no feedback is shown and the test immediately
  /// proceeds to the next trial.
  set feedbackDuration(Duration? duration) {
    _feedbackDuration = duration;
  }

  /// Sets whether to show instructions before the test starts.
  set showInstructions(bool value) {
    _showInstructions = value;
  }

  /// Starts the PVT test.
  ///
  /// If instructions are enabled, shows instructions first.
  /// If practice test is enabled (and no instructions), starts practice.
  /// If countdown is configured, starts with countdown.
  /// Otherwise, starts directly with the test.
  Future<void> start() async {
    if (_state != PvtState.idle) return;

    // Initialize feedback service
    await _feedbackService.initialize();

    if (_showInstructions) {
      _state = PvtState.instructions;
      notifyListeners();
    } else if (_config.enablePracticeTest && !_practiceSkipped) {
      _startPracticeTest();
    } else if (_config.countdownDuration > Duration.zero) {
      _startCountdown();
    } else {
      _startTest();
    }
  }

  /// Proceeds from the instructions screen to the test.
  ///
  /// Call this when the user taps the start button on the instructions page.
  /// If practice test is enabled, starts the practice test first.
  void proceedFromInstructions() {
    if (_state != PvtState.instructions) return;

    if (_config.enablePracticeTest && !_practiceSkipped) {
      _startPracticeTest();
    } else if (_config.countdownDuration > Duration.zero) {
      _startCountdown();
    } else {
      _startTest();
    }
  }

  /// Skips the practice test and proceeds directly to the real test.
  ///
  /// Call this when the user taps the "Skip Practice" button on the instructions page.
  void skipPractice() {
    if (_state != PvtState.instructions) return;

    _practiceSkipped = true;

    if (_config.countdownDuration > Duration.zero) {
      _startCountdown();
    } else {
      _startTest();
    }
  }

  /// Proceeds from the practice complete screen to the real test.
  ///
  /// Call this when the user taps the "Start Real Test" button.
  void proceedFromPracticeComplete() {
    if (_state != PvtState.practiceComplete) return;

    // Reset for real test
    _isPracticeMode = false;
    _currentTrialNumber = 0;
    _testStopwatch.reset();
    _trialStopwatch.reset();
    _testStartTime = null;
    _testEndTime = null;
    _stimulusOnsetTime = null;
    _lastReactionTimeMs = null;

    // Start countdown for real test
    if (_config.countdownDuration > Duration.zero) {
      _startCountdown();
    } else {
      _startTest();
    }
  }

  void _startPracticeTest() {
    _isPracticeMode = true;
    _practiceTrials.clear();

    if (_config.countdownDuration > Duration.zero) {
      _startCountdown();
    } else {
      _startTest();
    }
  }

  void _startCountdown() {
    _state = PvtState.countdown;
    _countdownValue = _config.countdownDuration.inSeconds;
    notifyListeners();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _countdownValue--;
      notifyListeners();

      if (_countdownValue <= 0) {
        timer.cancel();
        _startTest();
      }
    });
  }

  void _startTest() {
    _testStartTime = DateTime.now();
    _testStopwatch.start();
    _state = PvtState.waitingForStimulus;
    notifyListeners();

    // Use practice duration if in practice mode, otherwise use config duration
    final testDuration = _isPracticeMode
        ? PvtConfig.practiceTestDuration
        : _config.duration;

    // Start the test duration timer
    _testDurationTimer = Timer(testDuration, _endTest);

    // Start periodic timer to update the remaining time display
    _timerUpdateTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      notifyListeners();
    });

    // Schedule first stimulus
    _scheduleNextStimulus();
  }

  void _scheduleNextStimulus() {
    if (_state == PvtState.complete || _state == PvtState.practiceComplete) {
      return;
    }

    final interval = _intervalGenerator.next();
    _stimulusTimer = Timer(interval, _showStimulus);
  }

  void _showStimulus() {
    if (_state == PvtState.complete || _state == PvtState.practiceComplete) {
      return;
    }

    _currentTrialNumber++;
    _stimulusOnsetTime = DateTime.now();
    _trialStopwatch.reset();
    _trialStopwatch.start();

    _state = PvtState.stimulusShown;
    notifyListeners();
  }

  /// Records a response from the user.
  ///
  /// Returns the reaction time in milliseconds, or null if the response
  /// was invalid (e.g., no stimulus was shown).
  Future<int?> recordResponse() async {
    if (_state == PvtState.complete) return null;

    // Handle response during waiting period (false start before stimulus)
    if (_state == PvtState.waitingForStimulus) {
      // Early tap - ignore or record as premature
      return null;
    }

    if (_state != PvtState.stimulusShown) return null;

    final reactionTimeMs = _trialStopwatch.elapsedMilliseconds;
    _trialStopwatch.stop();
    _lastReactionTimeMs = reactionTimeMs;

    final responseTime = DateTime.now();

    // Record trial data
    final trial = TrialData(
      trialNumber: _currentTrialNumber,
      stimulusOnsetTime: _stimulusOnsetTime!,
      responseTime: responseTime,
      reactionTimeMs: reactionTimeMs,
    );

    // Store in practice trials or real trials based on mode
    if (_isPracticeMode) {
      _practiceTrials.add(trial);
    } else {
      _trials.add(trial);
    }

    // Provide feedback
    await _feedbackService.playFeedback(
      enableSound: _config.enableSound,
      enableHaptic: _config.enableHaptic,
    );

    // Check if test should end
    final testDuration = _isPracticeMode
        ? PvtConfig.practiceTestDuration
        : _config.duration;
    if (_testStopwatch.elapsed >= testDuration) {
      _endTest();
      return reactionTimeMs;
    }

    // Show feedback or move directly to waiting state
    if (_feedbackDuration != null) {
      _state = PvtState.showingFeedback;
      notifyListeners();
      _feedbackTimer = Timer(_feedbackDuration!, _endFeedback);
    } else {
      _state = PvtState.waitingForStimulus;
      notifyListeners();
      _scheduleNextStimulus();
    }

    return reactionTimeMs;
  }

  void _endFeedback() {
    if (_state != PvtState.showingFeedback) return;

    // Check if test should end
    final testDuration = _isPracticeMode
        ? PvtConfig.practiceTestDuration
        : _config.duration;
    if (_testStopwatch.elapsed >= testDuration) {
      _endTest();
      return;
    }

    _state = PvtState.waitingForStimulus;
    notifyListeners();
    _scheduleNextStimulus();
  }

  void _endTest() {
    _testStopwatch.stop();
    _trialStopwatch.stop();
    _testEndTime = DateTime.now();

    // Cancel any pending timers
    _countdownTimer?.cancel();
    _stimulusTimer?.cancel();
    _testDurationTimer?.cancel();
    _timerUpdateTimer?.cancel();
    _feedbackTimer?.cancel();

    // If stimulus was shown but no response, record as miss
    if (_state == PvtState.stimulusShown && _stimulusOnsetTime != null) {
      final trial = TrialData(
        trialNumber: _currentTrialNumber,
        stimulusOnsetTime: _stimulusOnsetTime!,
        responseTime: null,
        reactionTimeMs: null,
      );

      if (_isPracticeMode) {
        _practiceTrials.add(trial);
      } else {
        _trials.add(trial);
      }
    }

    // If practice mode, go to practice complete screen
    if (_isPracticeMode) {
      _state = PvtState.practiceComplete;
      notifyListeners();
      // Don't call onComplete callback for practice
    } else {
      _state = PvtState.complete;
      notifyListeners();
      _onComplete?.call();
    }
  }

  /// Gets the final results of the test.
  ///
  /// Returns null if the test is not complete.
  PvtResult? getResults() {
    if (_state != PvtState.complete) return null;
    if (_testStartTime == null || _testEndTime == null) return null;

    return StatisticsService.calculateResults(
      trials: List.unmodifiable(_trials),
      testStartTime: _testStartTime!,
      testEndTime: _testEndTime!,
    );
  }

  /// Stops the test early.
  void stop() {
    if (_state == PvtState.idle || _state == PvtState.complete) return;
    _endTest();
  }

  /// Resets the controller for a new test.
  void reset() {
    _countdownTimer?.cancel();
    _stimulusTimer?.cancel();
    _testDurationTimer?.cancel();
    _timerUpdateTimer?.cancel();
    _feedbackTimer?.cancel();

    _state = PvtState.idle;
    _countdownValue = 0;
    _currentTrialNumber = 0;
    _trials.clear();
    _practiceTrials.clear();
    _lastReactionTimeMs = null;
    _isPracticeMode = false;
    _practiceSkipped = false;

    _testStopwatch.stop();
    _testStopwatch.reset();
    _trialStopwatch.stop();
    _trialStopwatch.reset();

    _testStartTime = null;
    _testEndTime = null;
    _stimulusOnsetTime = null;

    notifyListeners();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _stimulusTimer?.cancel();
    _testDurationTimer?.cancel();
    _timerUpdateTimer?.cancel();
    _feedbackTimer?.cancel();
    super.dispose();
  }
}
