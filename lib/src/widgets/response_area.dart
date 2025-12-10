import 'package:flutter/material.dart';
import 'package:psychomotor_vigilance_test/src/models/stimulus_type.dart';

/// A widget that handles user tap responses for the PVT.
class ResponseArea extends StatelessWidget {
  /// Creates a response area widget.
  const ResponseArea({
    super.key,
    required this.onTap,
    required this.responseMode,
    this.buttonText = 'TAP',
    this.buttonColor,
    this.buttonTextColor,
    this.child,
  });

  /// Callback when the user taps.
  final VoidCallback onTap;

  /// The response mode (tap anywhere or tap button).
  final ResponseMode responseMode;

  /// The text to display on the button (only for tapButton mode).
  final String buttonText;

  /// The color of the button (only for tapButton mode).
  final Color? buttonColor;

  /// The text color of the button (only for tapButton mode).
  final Color? buttonTextColor;

  /// The child widget to display in the center (e.g., stimulus).
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (responseMode == ResponseMode.tapAnywhere) {
      return _buildTapAnywhereArea(context);
    } else {
      return _buildTapButtonArea(context);
    }
  }

  Widget _buildTapAnywhereArea(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => onTap(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  Widget _buildTapButtonArea(BuildContext context) {
    final effectiveButtonColor = buttonColor ?? Theme.of(context).primaryColor;
    final effectiveTextColor = buttonTextColor ?? Colors.white;

    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (child != null) ...[
            child!,
            const SizedBox(height: 48),
          ],
          SizedBox(
            width: 200,
            height: 80,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: effectiveButtonColor,
                foregroundColor: effectiveTextColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
