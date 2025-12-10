import 'package:flutter/material.dart';
import 'package:psychomotor_vigilance_test/src/models/performance_level.dart';
import 'package:psychomotor_vigilance_test/src/models/pvt_result.dart';
import 'package:psychomotor_vigilance_test/src/widgets/help_section.dart';
import 'package:psychomotor_vigilance_test/src/widgets/metric_row.dart';
import 'package:psychomotor_vigilance_test/src/widgets/pvt_results_style.dart';

/// A widget that displays PVT test results with color-coded performance indicators.
///
/// This widget provides a comprehensive view of test results including:
/// - Summary statistics (total trials, valid trials, duration)
/// - Reaction time metrics with performance indicators
/// - Trial counts (lapses, false starts, misses)
/// - An expandable help section explaining the results
///
/// Example usage:
/// ```dart
/// PvtResultsWidget(
///   result: pvtResult,
///   showHelpSection: true,
///   style: PvtResultsStyle(
///     goodColor: Colors.green,
///     fairColor: Colors.amber,
///     poorColor: Colors.red,
///   ),
/// )
/// ```
class PvtResultsWidget extends StatelessWidget {
  /// Creates a PVT results widget.
  const PvtResultsWidget({
    super.key,
    required this.result,
    this.style = const PvtResultsStyle(),
    this.showHelpSection = true,
    this.padding = const EdgeInsets.all(16),
  });

  /// The PVT test result to display.
  final PvtResult result;

  /// Styling configuration for the results display.
  final PvtResultsStyle style;

  /// Whether to show the expandable help section.
  final bool showHelpSection;

  /// Padding around the entire results widget.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: padding,
      children: [
        _buildSummaryCard(context),
        _buildReactionTimeCard(context),
        _buildTrialCountsCard(context),
        if (showHelpSection) HelpSection(style: style),
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    final headerStyle = style.headerTextStyle ??
        Theme.of(context).textTheme.titleLarge;

    return Card(
      margin: style.cardMargin,
      child: Padding(
        padding: style.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Summary', style: headerStyle),
            const SizedBox(height: 16),
            MetricRow(
              label: 'Total Trials',
              value: '${result.totalTrials}',
              style: style,
            ),
            MetricRow(
              label: 'Valid Trials',
              value: '${result.validTrials}',
              style: style,
            ),
            MetricRow(
              label: 'Test Duration',
              value: _formatDuration(result.testDuration),
              style: style,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReactionTimeCard(BuildContext context) {
    final headerStyle = style.headerTextStyle ??
        Theme.of(context).textTheme.titleLarge;

    return Card(
      margin: style.cardMargin,
      child: Padding(
        padding: style.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reaction Time Statistics', style: headerStyle),
            const SizedBox(height: 16),
            MetricRow(
              label: 'Mean RT',
              value: '${result.meanReactionTime.toStringAsFixed(1)} ms',
              performanceLevel:
                  PerformanceThresholds.evaluateMeanRT(result.meanReactionTime),
              style: style,
            ),
            MetricRow(
              label: 'Median RT',
              value: '${result.medianReactionTime.toStringAsFixed(1)} ms',
              performanceLevel: PerformanceThresholds.evaluateMedianRT(
                  result.medianReactionTime),
              style: style,
            ),
            MetricRow(
              label: 'Std Deviation',
              value: '${result.standardDeviation.toStringAsFixed(1)} ms',
              performanceLevel: PerformanceThresholds.evaluateStdDeviation(
                  result.standardDeviation),
              style: style,
            ),
            if (result.fastestReactionTime != null)
              MetricRow(
                label: 'Fastest RT',
                value: '${result.fastestReactionTime} ms',
                style: style,
              ),
            if (result.slowestReactionTime != null)
              MetricRow(
                label: 'Slowest RT',
                value: '${result.slowestReactionTime} ms',
                style: style,
              ),
            MetricRow(
              label: 'Reciprocal Mean',
              value: result.reciprocalMeanRT.toStringAsFixed(3),
              performanceLevel: PerformanceThresholds.evaluateReciprocalMean(
                  result.reciprocalMeanRT),
              style: style,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrialCountsCard(BuildContext context) {
    final headerStyle = style.headerTextStyle ??
        Theme.of(context).textTheme.titleLarge;

    return Card(
      margin: style.cardMargin,
      child: Padding(
        padding: style.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trial Counts', style: headerStyle),
            const SizedBox(height: 16),
            MetricRow(
              label: 'Lapses (>= 500ms)',
              value: '${result.lapses}',
              performanceLevel:
                  PerformanceThresholds.evaluateLapses(result.lapses),
              style: style,
            ),
            MetricRow(
              label: 'Lapse Percentage',
              value: '${result.lapsePercentage.toStringAsFixed(1)}%',
              performanceLevel: PerformanceThresholds.evaluateLapsePercentage(
                  result.lapsePercentage),
              style: style,
            ),
            MetricRow(
              label: 'False Starts (< 100ms)',
              value: '${result.falseStarts}',
              performanceLevel:
                  PerformanceThresholds.evaluateFalseStarts(result.falseStarts),
              style: style,
            ),
            MetricRow(
              label: 'Misses',
              value: '${result.misses}',
              performanceLevel:
                  PerformanceThresholds.evaluateMisses(result.misses),
              style: style,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }
}
