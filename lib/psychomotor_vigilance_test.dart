/// A Flutter plugin for conducting Psychomotor Vigilance Tests (PVT).
///
/// The PVT is a sustained-attention, reaction-time task that measures
/// behavioral alertness by presenting visual stimuli at random intervals
/// and measuring the user's reaction time.
///
/// ## Getting Started
///
/// Add this package to your pubspec.yaml:
///
/// ```yaml
/// dependencies:
///   psychomotor_vigilance_test: ^0.0.1
/// ```
///
/// ## Basic Usage
///
/// ```dart
/// import 'package:psychomotor_vigilance_test/psychomotor_vigilance_test.dart';
///
/// PvtWidget(
///   config: PvtConfig(
///     duration: Duration(minutes: 5),
///     stimulusType: StimulusType.circle,
///     responseMode: ResponseMode.tapAnywhere,
///   ),
///   onComplete: (PvtResult result) {
///     print('Mean RT: ${result.meanReactionTime}ms');
///     print('Median RT: ${result.medianReactionTime}ms');
///     print('Lapses: ${result.lapses}');
///     print('False Starts: ${result.falseStarts}');
///   },
/// )
/// ```
///
/// ## Configuration
///
/// Use [PvtConfig] to customize the test:
/// - [PvtConfig.duration] - Total test duration (default: 5 minutes)
/// - [PvtConfig.stimulusType] - Visual stimulus shape (circle, square, cross, star)
/// - [PvtConfig.responseMode] - Tap anywhere or tap button
/// - [PvtConfig.enableHaptic] - Enable haptic feedback on response
/// - [PvtConfig.countdownDuration] - Pre-test countdown duration
///
/// ## Styling
///
/// Use [PvtStyle] to customize the appearance:
/// - [PvtStyle.backgroundColor] - Background color of the test screen
/// - [PvtStyle.stimulusColor] - Color of the stimulus
/// - [PvtStyle.stimulusSize] - Size of the stimulus
/// - [PvtStyle.showTimer] - Whether to show remaining time
///
/// ## Results
///
/// [PvtResult] provides comprehensive test metrics:
/// - Mean, median, and standard deviation of reaction times
/// - Number of lapses (RT >= 500ms)
/// - Number of false starts (RT < 100ms)
/// - Number of misses (no response)
/// - Individual trial data with timestamps
library;

// Models
export 'package:psychomotor_vigilance_test/src/models/performance_level.dart';
export 'package:psychomotor_vigilance_test/src/models/pvt_config.dart';
export 'package:psychomotor_vigilance_test/src/models/pvt_result.dart';
export 'package:psychomotor_vigilance_test/src/models/stimulus_type.dart';
export 'package:psychomotor_vigilance_test/src/models/trial_data.dart';

// Widgets
export 'package:psychomotor_vigilance_test/src/pvt_widget.dart';
export 'package:psychomotor_vigilance_test/src/pvt_style.dart';
export 'package:psychomotor_vigilance_test/src/widgets/pvt_results_widget.dart';
export 'package:psychomotor_vigilance_test/src/widgets/pvt_results_style.dart';

// Controller (for advanced use cases)
export 'package:psychomotor_vigilance_test/src/pvt_controller.dart'
    show PvtController, PvtState;

// Services (for advanced use cases)
export 'package:psychomotor_vigilance_test/src/services/feedback_service.dart'
    show FeedbackService, SoundFeedbackCallback;
export 'package:psychomotor_vigilance_test/src/services/statistics_service.dart'
    show StatisticsService;
