import 'package:flutter/material.dart';

/// Styling options for the PVT widget.
class PvtStyle {
  /// Creates a PVT style configuration.
  const PvtStyle({
    this.backgroundColor = Colors.black,
    this.stimulusColor,
    this.stimulusSize = 100,
    this.buttonColor,
    this.buttonTextColor,
    this.buttonText = 'TAP',
    this.countdownTextStyle,
    this.countdownLabelStyle,
    this.countdownLabel = 'Get ready...',
    this.waitingMessage = '',
    this.waitingMessageStyle,
    this.showTimer = true,
    this.timerStyle,
    this.cancelButtonColor,
    this.cancelButtonIcon = Icons.close,
    this.cancelButtonSize = 40,
    this.showGhostStimulus = false,
    this.ghostStimulusOpacity = 0.2,
    this.showReactionTimeFeedback = false,
    this.feedbackDuration = const Duration(milliseconds: 800),
    this.feedbackTextStyle,
    this.showInstructions = false,
    this.instructionsTitle = 'Ready?',
    this.instructionsBody,
    this.instructionsTitleStyle,
    this.instructionsBodyStyle,
    this.instructionsButtonText = 'Start',
    this.skipPracticeButtonText = 'Skip Practice',
    this.practiceCompleteTitle = 'Practice Complete!',
    this.practiceCompleteMessage = "Now let's start the real test.",
    this.startRealTestButtonText = 'Start Real Test',
    this.practiceCompleteTitleStyle,
    this.practiceCompleteMessageStyle,
  });

  /// The background color of the test screen.
  final Color backgroundColor;

  /// The color of the stimulus. If null, uses the default color for the type.
  final Color? stimulusColor;

  /// The size of the stimulus in logical pixels.
  final double stimulusSize;

  /// The color of the response button (only for tapButton mode).
  final Color? buttonColor;

  /// The text color of the response button.
  final Color? buttonTextColor;

  /// The text to display on the response button.
  final String buttonText;

  /// The text style for the countdown number.
  final TextStyle? countdownTextStyle;

  /// The text style for the countdown label.
  final TextStyle? countdownLabelStyle;

  /// The label to display during countdown.
  final String countdownLabel;

  /// The message to display while waiting for stimulus.
  final String waitingMessage;

  /// The text style for the waiting message.
  final TextStyle? waitingMessageStyle;

  /// Whether to show the remaining time timer.
  final bool showTimer;

  /// The text style for the timer.
  final TextStyle? timerStyle;

  /// The background color of the cancel button.
  ///
  /// If null, uses a semi-transparent white.
  final Color? cancelButtonColor;

  /// The icon to display on the cancel button.
  final IconData cancelButtonIcon;

  /// The size of the cancel button.
  final double cancelButtonSize;

  /// Whether to show a faded "ghost" stimulus during the waiting period.
  ///
  /// When true, displays a semi-transparent version of the stimulus
  /// while waiting, which then becomes fully visible when triggered.
  /// Defaults to false.
  final bool showGhostStimulus;

  /// The opacity of the ghost stimulus during the waiting period.
  ///
  /// Only used when [showGhostStimulus] is true.
  /// Values range from 0.0 (invisible) to 1.0 (fully visible).
  /// Defaults to 0.2.
  final double ghostStimulusOpacity;

  /// Whether to show reaction time feedback after each response.
  ///
  /// When true, displays the reaction time briefly after each tap
  /// before moving to the next trial. Defaults to false.
  final bool showReactionTimeFeedback;

  /// How long to display the reaction time feedback.
  ///
  /// Only used when [showReactionTimeFeedback] is true.
  /// Defaults to 800 milliseconds.
  final Duration feedbackDuration;

  /// The text style for reaction time feedback.
  ///
  /// If null, uses a large bold style with color based on performance
  /// (green for fast, yellow for fair, red for slow).
  final TextStyle? feedbackTextStyle;

  /// Whether to show instructions before the test starts.
  ///
  /// When true, displays an instructions page with test information
  /// before the countdown begins. Defaults to false.
  final bool showInstructions;

  /// The title text for the instructions page.
  ///
  /// Defaults to 'Ready?'.
  final String instructionsTitle;

  /// The body text for the instructions page.
  ///
  /// If null, auto-generates based on stimulus type and color
  /// (e.g., "Tap as quickly as possible when you see the red circle appear.").
  final String? instructionsBody;

  /// The text style for the instructions title.
  ///
  /// If null, uses a large white bold style.
  final TextStyle? instructionsTitleStyle;

  /// The text style for the instructions body.
  ///
  /// If null, uses a medium gray style.
  final TextStyle? instructionsBodyStyle;

  /// The text for the start button on the instructions page.
  ///
  /// Defaults to 'Start'.
  final String instructionsButtonText;

  /// The text for the "Skip Practice" button on the instructions page.
  ///
  /// Only shown when practice test is enabled.
  /// Defaults to 'Skip Practice'.
  final String skipPracticeButtonText;

  /// The title text for the practice complete screen.
  ///
  /// Defaults to 'Practice Complete!'.
  final String practiceCompleteTitle;

  /// The message text for the practice complete screen.
  ///
  /// Defaults to "Now let's start the real test.".
  final String practiceCompleteMessage;

  /// The text for the button on the practice complete screen.
  ///
  /// Defaults to 'Start Real Test'.
  final String startRealTestButtonText;

  /// The text style for the practice complete title.
  ///
  /// If null, uses a large white bold style.
  final TextStyle? practiceCompleteTitleStyle;

  /// The text style for the practice complete message.
  ///
  /// If null, uses a medium gray style.
  final TextStyle? practiceCompleteMessageStyle;

  /// Creates a copy of this style with the given fields replaced.
  PvtStyle copyWith({
    Color? backgroundColor,
    Color? stimulusColor,
    double? stimulusSize,
    Color? buttonColor,
    Color? buttonTextColor,
    String? buttonText,
    TextStyle? countdownTextStyle,
    TextStyle? countdownLabelStyle,
    String? countdownLabel,
    String? waitingMessage,
    TextStyle? waitingMessageStyle,
    bool? showTimer,
    TextStyle? timerStyle,
    Color? cancelButtonColor,
    IconData? cancelButtonIcon,
    double? cancelButtonSize,
    bool? showGhostStimulus,
    double? ghostStimulusOpacity,
    bool? showReactionTimeFeedback,
    Duration? feedbackDuration,
    TextStyle? feedbackTextStyle,
    bool? showInstructions,
    String? instructionsTitle,
    String? instructionsBody,
    TextStyle? instructionsTitleStyle,
    TextStyle? instructionsBodyStyle,
    String? instructionsButtonText,
    String? skipPracticeButtonText,
    String? practiceCompleteTitle,
    String? practiceCompleteMessage,
    String? startRealTestButtonText,
    TextStyle? practiceCompleteTitleStyle,
    TextStyle? practiceCompleteMessageStyle,
  }) {
    return PvtStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      stimulusColor: stimulusColor ?? this.stimulusColor,
      stimulusSize: stimulusSize ?? this.stimulusSize,
      buttonColor: buttonColor ?? this.buttonColor,
      buttonTextColor: buttonTextColor ?? this.buttonTextColor,
      buttonText: buttonText ?? this.buttonText,
      countdownTextStyle: countdownTextStyle ?? this.countdownTextStyle,
      countdownLabelStyle: countdownLabelStyle ?? this.countdownLabelStyle,
      countdownLabel: countdownLabel ?? this.countdownLabel,
      waitingMessage: waitingMessage ?? this.waitingMessage,
      waitingMessageStyle: waitingMessageStyle ?? this.waitingMessageStyle,
      showTimer: showTimer ?? this.showTimer,
      timerStyle: timerStyle ?? this.timerStyle,
      cancelButtonColor: cancelButtonColor ?? this.cancelButtonColor,
      cancelButtonIcon: cancelButtonIcon ?? this.cancelButtonIcon,
      cancelButtonSize: cancelButtonSize ?? this.cancelButtonSize,
      showGhostStimulus: showGhostStimulus ?? this.showGhostStimulus,
      ghostStimulusOpacity: ghostStimulusOpacity ?? this.ghostStimulusOpacity,
      showReactionTimeFeedback:
          showReactionTimeFeedback ?? this.showReactionTimeFeedback,
      feedbackDuration: feedbackDuration ?? this.feedbackDuration,
      feedbackTextStyle: feedbackTextStyle ?? this.feedbackTextStyle,
      showInstructions: showInstructions ?? this.showInstructions,
      instructionsTitle: instructionsTitle ?? this.instructionsTitle,
      instructionsBody: instructionsBody ?? this.instructionsBody,
      instructionsTitleStyle:
          instructionsTitleStyle ?? this.instructionsTitleStyle,
      instructionsBodyStyle:
          instructionsBodyStyle ?? this.instructionsBodyStyle,
      instructionsButtonText:
          instructionsButtonText ?? this.instructionsButtonText,
      skipPracticeButtonText:
          skipPracticeButtonText ?? this.skipPracticeButtonText,
      practiceCompleteTitle:
          practiceCompleteTitle ?? this.practiceCompleteTitle,
      practiceCompleteMessage:
          practiceCompleteMessage ?? this.practiceCompleteMessage,
      startRealTestButtonText:
          startRealTestButtonText ?? this.startRealTestButtonText,
      practiceCompleteTitleStyle:
          practiceCompleteTitleStyle ?? this.practiceCompleteTitleStyle,
      practiceCompleteMessageStyle:
          practiceCompleteMessageStyle ?? this.practiceCompleteMessageStyle,
    );
  }
}
