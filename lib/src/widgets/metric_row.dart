import 'package:flutter/material.dart';
import 'package:psychomotor_vigilance_test/src/models/performance_level.dart';
import 'package:psychomotor_vigilance_test/src/widgets/pvt_results_style.dart';

/// A row widget that displays a metric with an optional colored indicator.
///
/// Used internally by [PvtResultsWidget] to display individual metrics
/// with their performance level indicated by a colored dot.
class MetricRow extends StatelessWidget {
  /// Creates a metric row.
  const MetricRow({
    super.key,
    required this.label,
    required this.value,
    this.performanceLevel,
    required this.style,
  });

  /// The label describing the metric.
  final String label;

  /// The formatted value of the metric.
  final String value;

  /// The performance level for this metric.
  ///
  /// If null, no indicator dot is shown.
  final PerformanceLevel? performanceLevel;

  /// The style configuration.
  final PvtResultsStyle style;

  @override
  Widget build(BuildContext context) {
    final labelStyle = style.labelTextStyle ??
        Theme.of(context).textTheme.bodyMedium;

    final valueStyle = style.valueTextStyle ??
        Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: labelStyle,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (performanceLevel != null && style.showIndicatorDot) ...[
                _IndicatorDot(
                  level: performanceLevel!,
                  style: style,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                value,
                style: valueStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A colored dot indicator showing performance level.
class _IndicatorDot extends StatelessWidget {
  const _IndicatorDot({
    required this.level,
    required this.style,
  });

  final PerformanceLevel level;
  final PvtResultsStyle style;

  @override
  Widget build(BuildContext context) {
    final color = PerformanceThresholds.getColor(
      level,
      goodColor: style.goodColor,
      fairColor: style.fairColor,
      poorColor: style.poorColor,
    );

    return Container(
      width: style.indicatorSize,
      height: style.indicatorSize,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
