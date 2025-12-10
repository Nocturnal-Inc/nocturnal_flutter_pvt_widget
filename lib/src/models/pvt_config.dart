import 'package:psychomotor_vigilance_test/src/models/stimulus_type.dart';

/// Configuration options for the PVT test.
class PvtConfig {
  /// Creates a new PVT configuration.
  ///
  /// Throws [AssertionError] if:
  /// - [minInterStimulusInterval] > [maxInterStimulusInterval]
  /// - [duration] <= [Duration.zero]
  const PvtConfig({
    this.duration = const Duration(minutes: 5),
    this.minInterStimulusInterval = const Duration(seconds: 2),
    this.maxInterStimulusInterval = const Duration(seconds: 10),
    this.stimulusType = StimulusType.circle,
    this.responseMode = ResponseMode.tapAnywhere,
    this.enableSound = true,
    this.enableHaptic = true,
    this.countdownDuration = const Duration(seconds: 3),
    this.enablePracticeTest = false,
  });

  /// The total duration of the test.
  ///
  /// Defaults to 5 minutes.
  final Duration duration;

  /// The minimum inter-stimulus interval (ISI).
  ///
  /// This is the minimum time between the user's response and the next
  /// stimulus appearing. Defaults to 2 seconds.
  final Duration minInterStimulusInterval;

  /// The maximum inter-stimulus interval (ISI).
  ///
  /// This is the maximum time between the user's response and the next
  /// stimulus appearing. Defaults to 10 seconds.
  final Duration maxInterStimulusInterval;

  /// The type of visual stimulus to display.
  ///
  /// Defaults to [StimulusType.circle].
  final StimulusType stimulusType;

  /// How the user should respond to the stimulus.
  ///
  /// Defaults to [ResponseMode.tapAnywhere].
  final ResponseMode responseMode;

  /// Whether to play a sound when the user responds.
  ///
  /// Defaults to true.
  final bool enableSound;

  /// Whether to provide haptic feedback when the user responds.
  ///
  /// Defaults to true.
  final bool enableHaptic;

  /// The duration of the countdown before the test starts.
  ///
  /// Set to [Duration.zero] to disable the countdown.
  /// Defaults to 3 seconds.
  final Duration countdownDuration;

  /// Whether to enable a 30-second practice test before the real test.
  ///
  /// When enabled, users will complete a short practice test to familiarize
  /// themselves with the task before the actual test begins. Practice test
  /// results are not included in the final results.
  ///
  /// Defaults to false.
  final bool enablePracticeTest;

  /// The fixed duration for the practice test.
  ///
  /// This is always 30 seconds and is not configurable.
  static const Duration practiceTestDuration = Duration(seconds: 30);

  /// The threshold below which a response is considered a false start.
  ///
  /// Responses faster than 100ms are physiologically impossible and
  /// indicate the user responded before actually seeing the stimulus.
  static const Duration falseStartThreshold = Duration(milliseconds: 100);

  /// The threshold above which a response is considered a lapse.
  ///
  /// Responses slower than 500ms indicate a lapse in attention.
  static const Duration lapseThreshold = Duration(milliseconds: 500);

  /// Creates a copy of this configuration with the given fields replaced.
  PvtConfig copyWith({
    Duration? duration,
    Duration? minInterStimulusInterval,
    Duration? maxInterStimulusInterval,
    StimulusType? stimulusType,
    ResponseMode? responseMode,
    bool? enableSound,
    bool? enableHaptic,
    Duration? countdownDuration,
    bool? enablePracticeTest,
  }) {
    return PvtConfig(
      duration: duration ?? this.duration,
      minInterStimulusInterval:
          minInterStimulusInterval ?? this.minInterStimulusInterval,
      maxInterStimulusInterval:
          maxInterStimulusInterval ?? this.maxInterStimulusInterval,
      stimulusType: stimulusType ?? this.stimulusType,
      responseMode: responseMode ?? this.responseMode,
      enableSound: enableSound ?? this.enableSound,
      enableHaptic: enableHaptic ?? this.enableHaptic,
      countdownDuration: countdownDuration ?? this.countdownDuration,
      enablePracticeTest: enablePracticeTest ?? this.enablePracticeTest,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PvtConfig &&
        other.duration == duration &&
        other.minInterStimulusInterval == minInterStimulusInterval &&
        other.maxInterStimulusInterval == maxInterStimulusInterval &&
        other.stimulusType == stimulusType &&
        other.responseMode == responseMode &&
        other.enableSound == enableSound &&
        other.enableHaptic == enableHaptic &&
        other.countdownDuration == countdownDuration &&
        other.enablePracticeTest == enablePracticeTest;
  }

  @override
  int get hashCode {
    return Object.hash(
      duration,
      minInterStimulusInterval,
      maxInterStimulusInterval,
      stimulusType,
      responseMode,
      enableSound,
      enableHaptic,
      countdownDuration,
      enablePracticeTest,
    );
  }

  @override
  String toString() {
    return 'PvtConfig('
        'duration: $duration, '
        'minISI: $minInterStimulusInterval, '
        'maxISI: $maxInterStimulusInterval, '
        'stimulusType: $stimulusType, '
        'responseMode: $responseMode, '
        'enableSound: $enableSound, '
        'enableHaptic: $enableHaptic, '
        'countdownDuration: $countdownDuration, '
        'enablePracticeTest: $enablePracticeTest)';
  }
}
