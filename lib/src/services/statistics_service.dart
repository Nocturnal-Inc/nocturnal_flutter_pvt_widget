import 'dart:math';

import 'package:psychomotor_vigilance_test/src/models/trial_data.dart';
import 'package:psychomotor_vigilance_test/src/models/pvt_result.dart';

/// Service for calculating PVT statistics from trial data.
class StatisticsService {
  /// Calculates comprehensive statistics from a list of trials.
  static PvtResult calculateResults({
    required List<TrialData> trials,
    required DateTime testStartTime,
    required DateTime testEndTime,
  }) {
    if (trials.isEmpty) {
      return PvtResult(
        trials: trials,
        testStartTime: testStartTime,
        testEndTime: testEndTime,
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

    // Count different trial types
    final falseStarts = trials.where((t) => t.isFalseStart).length;
    final lapses = trials.where((t) => t.isLapse).length;
    final misses = trials.where((t) => t.isMiss).length;

    // Get valid reaction times (not false starts, not misses)
    final validTrials = trials.where((t) => t.isValid).toList();
    final validRTs = validTrials
        .map((t) => t.reactionTimeMs!)
        .toList();

    // Calculate statistics from valid trials
    double meanRT = 0;
    double medianRT = 0;
    double stdDev = 0;
    int? fastestRT;
    int? slowestRT;
    double reciprocalMean = 0;

    if (validRTs.isNotEmpty) {
      meanRT = _calculateMean(validRTs);
      medianRT = _calculateMedian(validRTs);
      stdDev = _calculateStandardDeviation(validRTs, meanRT);
      fastestRT = validRTs.reduce(min);
      slowestRT = validRTs.reduce(max);
      reciprocalMean = _calculateReciprocalMean(validRTs);
    }

    final lapsePercentage = trials.isNotEmpty
        ? (lapses / trials.length) * 100
        : 0.0;

    // Build trialsJson map
    final trialsJson = <String, Map<String, List<int>>>{};
    for (final trial in trials) {
      final onsetMs = trial.stimulusOnsetTime
          .difference(testStartTime)
          .inMilliseconds;
      final key = onsetMs.toString();

      if (trial.reactionTimeMs != null) {
        // If key already exists, add to the array (multiple responses)
        if (trialsJson.containsKey(key)) {
          trialsJson[key]!['clickedAfter']!.add(trial.reactionTimeMs!);
        } else {
          trialsJson[key] = {
            'clickedAfter': [trial.reactionTimeMs!]
          };
        }
      } else {
        // Miss - empty clickedAfter array
        trialsJson[key] = {'clickedAfter': <int>[]};
      }
    }

    return PvtResult(
      trials: trials,
      testStartTime: testStartTime,
      testEndTime: testEndTime,
      totalTrials: trials.length,
      validTrials: validTrials.length,
      falseStarts: falseStarts,
      lapses: lapses,
      misses: misses,
      meanReactionTime: meanRT,
      medianReactionTime: medianRT,
      standardDeviation: stdDev,
      fastestReactionTime: fastestRT,
      slowestReactionTime: slowestRT,
      lapsePercentage: lapsePercentage,
      reciprocalMeanRT: reciprocalMean,
      trialsJson: trialsJson,
    );
  }

  /// Calculates the arithmetic mean of a list of values.
  static double _calculateMean(List<int> values) {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  /// Calculates the median of a list of values.
  static double _calculateMedian(List<int> values) {
    if (values.isEmpty) return 0;

    final sorted = List<int>.from(values)..sort();
    final middle = sorted.length ~/ 2;

    if (sorted.length.isOdd) {
      return sorted[middle].toDouble();
    } else {
      return (sorted[middle - 1] + sorted[middle]) / 2;
    }
  }

  /// Calculates the standard deviation of a list of values.
  static double _calculateStandardDeviation(List<int> values, double mean) {
    if (values.length < 2) return 0;

    final squaredDiffs = values.map((v) => pow(v - mean, 2));
    final variance = squaredDiffs.reduce((a, b) => a + b) / (values.length - 1);
    return sqrt(variance);
  }

  /// Calculates the reciprocal mean (1000/RT for each trial, then averaged).
  ///
  /// This metric is commonly used in PVT research because it:
  /// 1. Reduces the influence of extreme values (long lapses)
  /// 2. Has a more normal distribution than raw RTs
  /// 3. Can be interpreted as "response speed" rather than "response time"
  static double _calculateReciprocalMean(List<int> values) {
    if (values.isEmpty) return 0;

    final reciprocals = values.map((rt) => 1000 / rt);
    return reciprocals.reduce((a, b) => a + b) / values.length;
  }
}
