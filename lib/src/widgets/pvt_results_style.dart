import 'package:flutter/material.dart';

/// Styling configuration for [PvtResultsWidget].
///
/// Allows customization of colors, text styles, and visual appearance
/// of the results display.
class PvtResultsStyle {
  /// Creates a results style configuration.
  const PvtResultsStyle({
    this.goodColor = Colors.green,
    this.fairColor = Colors.orange,
    this.poorColor = Colors.red,
    this.cardMargin = const EdgeInsets.only(bottom: 16),
    this.cardPadding = const EdgeInsets.all(16),
    this.headerTextStyle,
    this.labelTextStyle,
    this.valueTextStyle,
    this.indicatorSize = 12,
    this.showIndicatorDot = true,
    this.helpSectionInitiallyExpanded = false,
  });

  /// Color for good performance indicators.
  final Color goodColor;

  /// Color for fair performance indicators.
  final Color fairColor;

  /// Color for poor performance indicators.
  final Color poorColor;

  /// Margin around each card.
  final EdgeInsets cardMargin;

  /// Padding inside each card.
  final EdgeInsets cardPadding;

  /// Text style for card headers.
  ///
  /// If null, uses `Theme.of(context).textTheme.titleLarge`.
  final TextStyle? headerTextStyle;

  /// Text style for metric labels.
  ///
  /// If null, uses default body text style.
  final TextStyle? labelTextStyle;

  /// Text style for metric values.
  ///
  /// If null, uses bold body text style.
  final TextStyle? valueTextStyle;

  /// Size of the colored indicator dot.
  final double indicatorSize;

  /// Whether to show the colored dot indicator next to values.
  final bool showIndicatorDot;

  /// Whether the help section is initially expanded.
  final bool helpSectionInitiallyExpanded;

  /// Creates a copy of this style with the given fields replaced.
  PvtResultsStyle copyWith({
    Color? goodColor,
    Color? fairColor,
    Color? poorColor,
    EdgeInsets? cardMargin,
    EdgeInsets? cardPadding,
    TextStyle? headerTextStyle,
    TextStyle? labelTextStyle,
    TextStyle? valueTextStyle,
    double? indicatorSize,
    bool? showIndicatorDot,
    bool? helpSectionInitiallyExpanded,
  }) {
    return PvtResultsStyle(
      goodColor: goodColor ?? this.goodColor,
      fairColor: fairColor ?? this.fairColor,
      poorColor: poorColor ?? this.poorColor,
      cardMargin: cardMargin ?? this.cardMargin,
      cardPadding: cardPadding ?? this.cardPadding,
      headerTextStyle: headerTextStyle ?? this.headerTextStyle,
      labelTextStyle: labelTextStyle ?? this.labelTextStyle,
      valueTextStyle: valueTextStyle ?? this.valueTextStyle,
      indicatorSize: indicatorSize ?? this.indicatorSize,
      showIndicatorDot: showIndicatorDot ?? this.showIndicatorDot,
      helpSectionInitiallyExpanded:
          helpSectionInitiallyExpanded ?? this.helpSectionInitiallyExpanded,
    );
  }
}
