import 'package:flutter/material.dart';

/// Performance level classification for PVT metrics.
enum PerformanceLevel {
  /// Good performance - within optimal range.
  good,

  /// Fair performance - slightly below optimal.
  fair,

  /// Poor performance - needs attention.
  poor,
}

/// Extension to get display properties for performance levels.
extension PerformanceLevelExtension on PerformanceLevel {
  /// Returns the default color for this performance level.
  Color get defaultColor {
    switch (this) {
      case PerformanceLevel.good:
        return Colors.green;
      case PerformanceLevel.fair:
        return Colors.orange;
      case PerformanceLevel.poor:
        return Colors.red;
    }
  }

  /// Returns the display name for this performance level.
  String get displayName {
    switch (this) {
      case PerformanceLevel.good:
        return 'Good';
      case PerformanceLevel.fair:
        return 'Fair';
      case PerformanceLevel.poor:
        return 'Needs Attention';
    }
  }
}

/// Utility class for evaluating PVT metrics against performance thresholds.
///
/// Thresholds are based on PVT research literature for healthy adults.
class PerformanceThresholds {
  PerformanceThresholds._();

  // Mean/Median RT thresholds (milliseconds)
  static const double _rtGoodThreshold = 300;
  static const double _rtFairThreshold = 400;

  // Standard deviation thresholds (milliseconds)
  static const double _stdDevGoodThreshold = 60;
  static const double _stdDevFairThreshold = 100;

  // Lapse count thresholds
  static const int _lapsesGoodThreshold = 1;
  static const int _lapsesFairThreshold = 5;

  // Lapse percentage thresholds
  static const double _lapsePercentGoodThreshold = 5;
  static const double _lapsePercentFairThreshold = 15;

  // False start thresholds
  static const int _falseStartsGoodThreshold = 0;
  static const int _falseStartsFairThreshold = 2;

  // Miss thresholds
  static const int _missesGoodThreshold = 0;
  static const int _missesFairThreshold = 1;

  // Reciprocal mean thresholds (higher is better)
  static const double _reciprocalGoodThreshold = 3.5;
  static const double _reciprocalFairThreshold = 2.5;

  /// Evaluates mean reaction time performance.
  ///
  /// - Good: < 300ms
  /// - Fair: 300-400ms
  /// - Poor: > 400ms
  static PerformanceLevel evaluateMeanRT(double meanRT) {
    if (meanRT < _rtGoodThreshold) return PerformanceLevel.good;
    if (meanRT <= _rtFairThreshold) return PerformanceLevel.fair;
    return PerformanceLevel.poor;
  }

  /// Evaluates median reaction time performance.
  ///
  /// - Good: < 300ms
  /// - Fair: 300-400ms
  /// - Poor: > 400ms
  static PerformanceLevel evaluateMedianRT(double medianRT) {
    if (medianRT < _rtGoodThreshold) return PerformanceLevel.good;
    if (medianRT <= _rtFairThreshold) return PerformanceLevel.fair;
    return PerformanceLevel.poor;
  }

  /// Evaluates standard deviation performance.
  ///
  /// - Good: < 60ms (consistent)
  /// - Fair: 60-100ms
  /// - Poor: > 100ms (inconsistent)
  static PerformanceLevel evaluateStdDeviation(double stdDev) {
    if (stdDev < _stdDevGoodThreshold) return PerformanceLevel.good;
    if (stdDev <= _stdDevFairThreshold) return PerformanceLevel.fair;
    return PerformanceLevel.poor;
  }

  /// Evaluates lapse count performance.
  ///
  /// - Good: 0-1 lapses
  /// - Fair: 2-5 lapses
  /// - Poor: > 5 lapses
  static PerformanceLevel evaluateLapses(int lapses) {
    if (lapses <= _lapsesGoodThreshold) return PerformanceLevel.good;
    if (lapses <= _lapsesFairThreshold) return PerformanceLevel.fair;
    return PerformanceLevel.poor;
  }

  /// Evaluates lapse percentage performance.
  ///
  /// - Good: < 5%
  /// - Fair: 5-15%
  /// - Poor: > 15%
  static PerformanceLevel evaluateLapsePercentage(double lapsePercent) {
    if (lapsePercent < _lapsePercentGoodThreshold) return PerformanceLevel.good;
    if (lapsePercent <= _lapsePercentFairThreshold) return PerformanceLevel.fair;
    return PerformanceLevel.poor;
  }

  /// Evaluates false start count performance.
  ///
  /// - Good: 0
  /// - Fair: 1-2
  /// - Poor: > 2
  static PerformanceLevel evaluateFalseStarts(int falseStarts) {
    if (falseStarts <= _falseStartsGoodThreshold) return PerformanceLevel.good;
    if (falseStarts <= _falseStartsFairThreshold) return PerformanceLevel.fair;
    return PerformanceLevel.poor;
  }

  /// Evaluates miss count performance.
  ///
  /// - Good: 0
  /// - Fair: 1
  /// - Poor: > 1
  static PerformanceLevel evaluateMisses(int misses) {
    if (misses <= _missesGoodThreshold) return PerformanceLevel.good;
    if (misses <= _missesFairThreshold) return PerformanceLevel.fair;
    return PerformanceLevel.poor;
  }

  /// Evaluates reciprocal mean RT performance.
  ///
  /// Higher values indicate faster, more consistent responses.
  /// - Good: > 3.5
  /// - Fair: 2.5-3.5
  /// - Poor: < 2.5
  static PerformanceLevel evaluateReciprocalMean(double reciprocalMean) {
    if (reciprocalMean > _reciprocalGoodThreshold) return PerformanceLevel.good;
    if (reciprocalMean >= _reciprocalFairThreshold) return PerformanceLevel.fair;
    return PerformanceLevel.poor;
  }

  /// Returns the color for a given performance level.
  ///
  /// Uses custom colors if provided, otherwise falls back to defaults.
  static Color getColor(
    PerformanceLevel level, {
    Color? goodColor,
    Color? fairColor,
    Color? poorColor,
  }) {
    switch (level) {
      case PerformanceLevel.good:
        return goodColor ?? level.defaultColor;
      case PerformanceLevel.fair:
        return fairColor ?? level.defaultColor;
      case PerformanceLevel.poor:
        return poorColor ?? level.defaultColor;
    }
  }
}
