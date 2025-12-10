import 'package:flutter/material.dart';
import 'package:psychomotor_vigilance_test/src/widgets/pvt_results_style.dart';

/// An expandable help section explaining PVT results and color indicators.
///
/// Provides users with context about what each metric means and how to
/// interpret the color-coded performance indicators.
class HelpSection extends StatelessWidget {
  /// Creates a help section widget.
  const HelpSection({
    super.key,
    required this.style,
  });

  /// The style configuration.
  final PvtResultsStyle style;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: style.cardMargin,
      child: ExpansionTile(
        initiallyExpanded: style.helpSectionInitiallyExpanded,
        leading: const Icon(Icons.help_outline),
        title: const Text('Understanding Your Results'),
        children: [
          Padding(
            padding: style.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildColorLegend(context),
                const SizedBox(height: 20),
                _buildMetricDescriptions(context),
                const SizedBox(height: 20),
                _buildInterpretationTips(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorLegend(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color Legend',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        _ColorLegendItem(
          color: style.goodColor,
          label: 'Good',
          description: 'Performance is within optimal range',
        ),
        const SizedBox(height: 8),
        _ColorLegendItem(
          color: style.fairColor,
          label: 'Fair',
          description: 'Performance is slightly below optimal',
        ),
        const SizedBox(height: 8),
        _ColorLegendItem(
          color: style.poorColor,
          label: 'Needs Attention',
          description: 'Performance may indicate fatigue or sleepiness',
        ),
      ],
    );
  }

  Widget _buildMetricDescriptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Metric Descriptions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        const _MetricDescription(
          title: 'Mean RT (Reaction Time)',
          description:
              'The average time it takes you to respond to the stimulus. '
              'Lower values indicate faster reactions.',
          optimalRange: '< 300ms',
        ),
        const _MetricDescription(
          title: 'Median RT',
          description:
              'The middle value of your reaction times. Less affected by '
              'occasional slow responses than the mean.',
          optimalRange: '< 300ms',
        ),
        const _MetricDescription(
          title: 'Standard Deviation',
          description:
              'Measures consistency of your responses. Lower values mean '
              'more consistent performance.',
          optimalRange: '< 60ms',
        ),
        const _MetricDescription(
          title: 'Reciprocal Mean',
          description:
              'A measure of response speed (1/RT). Higher values indicate '
              'better performance. More sensitive to detecting impairment.',
          optimalRange: '> 3.5',
        ),
        const _MetricDescription(
          title: 'Lapses',
          description:
              'Responses slower than 500ms. These indicate momentary '
              'attention failures and are key indicators of sleepiness.',
          optimalRange: '0-1',
        ),
        const _MetricDescription(
          title: 'Lapse Percentage',
          description:
              'The proportion of trials that were lapses. High percentages '
              'suggest sustained attention difficulties.',
          optimalRange: '< 5%',
        ),
        const _MetricDescription(
          title: 'False Starts',
          description:
              'Responses faster than 100ms. These are too fast to be '
              'genuine reactions and indicate anticipatory responses.',
          optimalRange: '0',
        ),
        const _MetricDescription(
          title: 'Misses',
          description:
              'Trials where no response was recorded. May indicate '
              'severe attention lapses or test engagement issues.',
          optimalRange: '0',
        ),
      ],
    );
  }

  Widget _buildInterpretationTips(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Interpretation Tips',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        const _TipItem(
          icon: Icons.lightbulb_outline,
          text:
              'The number of lapses is often more sensitive to sleep '
              'deprivation than average reaction time.',
        ),
        const _TipItem(
          icon: Icons.trending_up,
          text:
              'Compare your results across multiple tests to track changes '
              'in alertness over time.',
        ),
        const _TipItem(
          icon: Icons.schedule,
          text:
              'Performance typically varies throughout the day due to '
              'circadian rhythms. Test at consistent times for best comparisons.',
        ),
        const _TipItem(
          icon: Icons.coffee,
          text:
              'Factors like sleep quality, caffeine, medications, and stress '
              'can all affect PVT performance.',
        ),
      ],
    );
  }
}

/// A single item in the color legend.
class _ColorLegendItem extends StatelessWidget {
  const _ColorLegendItem({
    required this.color,
    required this.label,
    required this.description,
  });

  final Color color;
  final String label;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A metric description item.
class _MetricDescription extends StatelessWidget {
  const _MetricDescription({
    required this.title,
    required this.description,
    this.optimalRange,
  });

  final String title;
  final String description;
  final String? optimalRange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (optimalRange != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Optimal: $optimalRange',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// A tip item with an icon.
class _TipItem extends StatelessWidget {
  const _TipItem({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
