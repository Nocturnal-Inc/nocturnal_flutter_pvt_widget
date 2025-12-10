import 'package:psychomotor_vigilance_test/src/models/trial_data.dart';

/// Complete results from a PVT test session.
class PvtResult {
  /// Creates a new PVT result.
  const PvtResult({
    required this.trials,
    required this.testStartTime,
    required this.testEndTime,
    required this.totalTrials,
    required this.validTrials,
    required this.falseStarts,
    required this.lapses,
    required this.misses,
    required this.meanReactionTime,
    required this.medianReactionTime,
    required this.standardDeviation,
    required this.fastestReactionTime,
    required this.slowestReactionTime,
    required this.lapsePercentage,
    required this.reciprocalMeanRT,
    required this.trialsJson,
  });

  /// All trial data from the test.
  final List<TrialData> trials;

  /// When the test started.
  final DateTime testStartTime;

  /// When the test ended.
  final DateTime testEndTime;

  /// Total number of trials in the test.
  final int totalTrials;

  /// Number of valid responses (not false starts or misses).
  final int validTrials;

  /// Number of false starts (responses < 100ms).
  final int falseStarts;

  /// Number of lapses (responses >= 500ms).
  final int lapses;

  /// Number of missed stimuli (no response).
  final int misses;

  /// Mean reaction time in milliseconds (valid trials only).
  final double meanReactionTime;

  /// Median reaction time in milliseconds (valid trials only).
  final double medianReactionTime;

  /// Standard deviation of reaction times (valid trials only).
  final double standardDeviation;

  /// Fastest reaction time in milliseconds.
  final int? fastestReactionTime;

  /// Slowest reaction time in milliseconds (excluding lapses).
  final int? slowestReactionTime;

  /// Percentage of trials that were lapses.
  final double lapsePercentage;

  /// Reciprocal of the mean reaction time (1000/RT).
  ///
  /// This is a commonly used metric in PVT research that is less
  /// affected by extreme values.
  final double reciprocalMeanRT;

  /// Trial data as a JSON-compatible map.
  ///
  /// Format: `{"stimulusOnsetMs": {"clickedAfter": [reactionTimeMs, ...]}}`
  /// - Key: Stimulus onset time in milliseconds from test start
  /// - clickedAfter: Array of reaction times (empty array for misses)
  ///
  /// Example:
  /// ```json
  /// {
  ///   "42293": {"clickedAfter": [336]},
  ///   "50295": {"clickedAfter": [312]},
  ///   "65294": {"clickedAfter": []}  // Miss
  /// }
  /// ```
  final Map<String, Map<String, List<int>>> trialsJson;

  /// The duration of the test.
  Duration get testDuration => testEndTime.difference(testStartTime);

  /// Creates an empty result (no trials).
  factory PvtResult.empty() {
    final now = DateTime.now();
    return PvtResult(
      trials: const [],
      testStartTime: now,
      testEndTime: now,
      totalTrials: 0,
      validTrials: 0,
      falseStarts: 0,
      lapses: 0,
      misses: 0,
      meanReactionTime: 0,
      medianReactionTime: 0,
      standardDeviation: 0,
      fastestReactionTime: null,
      slowestReactionTime: null,
      lapsePercentage: 0,
      reciprocalMeanRT: 0,
      trialsJson: const {},
    );
  }

  @override
  String toString() {
    return 'PvtResult('
        'trials: $totalTrials, '
        'valid: $validTrials, '
        'meanRT: ${meanReactionTime.toStringAsFixed(1)}ms, '
        'medianRT: ${medianReactionTime.toStringAsFixed(1)}ms, '
        'lapses: $lapses (${lapsePercentage.toStringAsFixed(1)}%), '
        'falseStarts: $falseStarts)';
  }

  /// Converts this result to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'trials': trials.map((t) => t.toJson()).toList(),
      'testStartTime': testStartTime.toIso8601String(),
      'testEndTime': testEndTime.toIso8601String(),
      'testDurationMs': testDuration.inMilliseconds,
      'totalTrials': totalTrials,
      'validTrials': validTrials,
      'falseStarts': falseStarts,
      'lapses': lapses,
      'misses': misses,
      'meanReactionTime': meanReactionTime,
      'medianReactionTime': medianReactionTime,
      'standardDeviation': standardDeviation,
      'fastestReactionTime': fastestReactionTime,
      'slowestReactionTime': slowestReactionTime,
      'lapsePercentage': lapsePercentage,
      'reciprocalMeanRT': reciprocalMeanRT,
      'trialsJson': trialsJson,
    };
  }

  /// Creates a result from a JSON map.
  factory PvtResult.fromJson(Map<String, dynamic> json) {
    // Parse trialsJson with proper type casting
    final trialsJsonRaw = json['trialsJson'] as Map<String, dynamic>?;
    final trialsJson = <String, Map<String, List<int>>>{};
    if (trialsJsonRaw != null) {
      for (final entry in trialsJsonRaw.entries) {
        final innerMap = entry.value as Map<String, dynamic>;
        final clickedAfter = (innerMap['clickedAfter'] as List)
            .map((e) => e as int)
            .toList();
        trialsJson[entry.key] = {'clickedAfter': clickedAfter};
      }
    }

    return PvtResult(
      trials: (json['trials'] as List)
          .map((t) => TrialData.fromJson(t as Map<String, dynamic>))
          .toList(),
      testStartTime: DateTime.parse(json['testStartTime'] as String),
      testEndTime: DateTime.parse(json['testEndTime'] as String),
      totalTrials: json['totalTrials'] as int,
      validTrials: json['validTrials'] as int,
      falseStarts: json['falseStarts'] as int,
      lapses: json['lapses'] as int,
      misses: json['misses'] as int,
      meanReactionTime: (json['meanReactionTime'] as num).toDouble(),
      medianReactionTime: (json['medianReactionTime'] as num).toDouble(),
      standardDeviation: (json['standardDeviation'] as num).toDouble(),
      fastestReactionTime: json['fastestReactionTime'] as int?,
      slowestReactionTime: json['slowestReactionTime'] as int?,
      lapsePercentage: (json['lapsePercentage'] as num).toDouble(),
      reciprocalMeanRT: (json['reciprocalMeanRT'] as num).toDouble(),
      trialsJson: trialsJson,
    );
  }
}
