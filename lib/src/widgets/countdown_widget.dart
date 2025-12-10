import 'package:flutter/material.dart';

/// A widget that displays a countdown before the test starts.
class CountdownWidget extends StatelessWidget {
  /// Creates a countdown widget.
  const CountdownWidget({
    super.key,
    required this.value,
    this.textStyle,
    this.label = 'Get ready...',
    this.labelStyle,
  });

  /// The current countdown value.
  final int value;

  /// The text style for the countdown number.
  final TextStyle? textStyle;

  /// The label to display above the countdown.
  final String label;

  /// The text style for the label.
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectiveTextStyle = textStyle ??
        theme.textTheme.displayLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 120,
        );

    final effectiveLabelStyle = labelStyle ??
        theme.textTheme.headlineSmall?.copyWith(
          color: Colors.white70,
        );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: effectiveLabelStyle,
        ),
        const SizedBox(height: 24),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: Text(
            value.toString(),
            key: ValueKey(value),
            style: effectiveTextStyle,
          ),
        ),
      ],
    );
  }
}
