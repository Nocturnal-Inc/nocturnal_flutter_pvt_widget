import 'package:flutter/material.dart';
import 'package:psychomotor_vigilance_test/src/models/pvt_config.dart';
import 'package:psychomotor_vigilance_test/src/models/pvt_result.dart';
import 'package:psychomotor_vigilance_test/src/models/stimulus_type.dart';
import 'package:psychomotor_vigilance_test/src/pvt_controller.dart';
import 'package:psychomotor_vigilance_test/src/pvt_style.dart';
import 'package:psychomotor_vigilance_test/src/services/feedback_service.dart';
import 'package:psychomotor_vigilance_test/src/widgets/countdown_widget.dart';
import 'package:psychomotor_vigilance_test/src/widgets/response_area.dart';
import 'package:psychomotor_vigilance_test/src/widgets/stimulus_widget.dart';

/// Callback type for when the PVT test completes.
typedef PvtCompleteCallback = void Function(PvtResult result);

/// Callback type for custom sound feedback.
typedef SoundCallback = Future<void> Function();

/// Callback type for when the PVT test is cancelled.
typedef PvtCancelCallback = void Function();

/// A widget that runs a complete Psychomotor Vigilance Test (PVT).
///
/// The PVT is a sustained-attention, reaction-time task that measures
/// behavioral alertness by presenting visual stimuli at random intervals
/// and measuring the user's reaction time.
///
/// Example usage:
/// ```dart
/// PvtWidget(
///   config: PvtConfig(
///     duration: Duration(minutes: 5),
///     stimulusType: StimulusType.circle,
///   ),
///   onComplete: (result) {
///     print('Mean RT: ${result.meanReactionTime}ms');
///     print('Lapses: ${result.lapses}');
///   },
/// )
/// ```
class PvtWidget extends StatefulWidget {
  /// Creates a PVT widget.
  const PvtWidget({
    super.key,
    this.config = const PvtConfig(),
    required this.onComplete,
    this.style = const PvtStyle(),
    this.autoStart = true,
    this.soundCallback,
    this.showCancelButton = false,
    this.onCancel,
  });

  /// The configuration for the test.
  final PvtConfig config;

  /// Callback when the test completes.
  final PvtCompleteCallback onComplete;

  /// Styling options for the widget.
  final PvtStyle style;

  /// Whether to automatically start the test when the widget is mounted.
  final bool autoStart;

  /// Optional callback for custom sound feedback.
  ///
  /// If provided, this will be called when sound feedback should be played.
  final SoundCallback? soundCallback;

  /// Whether to show a cancel button during the test.
  ///
  /// Defaults to false.
  final bool showCancelButton;

  /// Callback when the test is cancelled.
  ///
  /// Called when the user taps the cancel button. The test is stopped
  /// before this callback is invoked.
  final PvtCancelCallback? onCancel;

  @override
  State<PvtWidget> createState() => _PvtWidgetState();
}

class _PvtWidgetState extends State<PvtWidget> {
  late PvtController _controller;

  @override
  void initState() {
    super.initState();
    _initializeController();

    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.start();
      });
    }
  }

  void _initializeController() {
    // Set up sound callback if provided
    if (widget.soundCallback != null) {
      FeedbackService.instance.setSoundCallback(widget.soundCallback);
    }

    _controller = PvtController(
      config: widget.config,
      onComplete: _handleComplete,
    );

    // Configure feedback duration if enabled
    if (widget.style.showReactionTimeFeedback) {
      _controller.feedbackDuration = widget.style.feedbackDuration;
    }

    // Configure instructions if enabled
    if (widget.style.showInstructions) {
      _controller.showInstructions = true;
    }

    _controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  void _handleComplete() {
    final result = _controller.getResults();
    if (result != null) {
      widget.onComplete(result);
    }
  }

  void _handleTap() {
    _controller.recordResponse();
  }

  void _handleCancel() {
    _controller.stop();
    widget.onCancel?.call();
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.style.backgroundColor,
      child: SafeArea(
        child: Stack(
          children: [
            _buildContent(),
            if (widget.style.showTimer && _shouldShowTimer())
              _buildTimer(),
            if (widget.showCancelButton && _shouldShowCancelButton())
              _buildCancelButton(),
          ],
        ),
      ),
    );
  }

  bool _shouldShowCancelButton() {
    final state = _controller.state;
    return state == PvtState.waitingForStimulus ||
        state == PvtState.stimulusShown ||
        state == PvtState.showingFeedback;
  }

  Widget _buildCancelButton() {
    final buttonColor = widget.style.cancelButtonColor ?? Colors.white24;
    final size = widget.style.cancelButtonSize;

    return Positioned(
      top: 8,
      right: 8,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleCancel,
          borderRadius: BorderRadius.circular(size / 2),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: buttonColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.style.cancelButtonIcon,
              color: Colors.white,
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );
  }

  bool _shouldShowTimer() {
    final state = _controller.state;
    return state == PvtState.waitingForStimulus ||
        state == PvtState.stimulusShown ||
        state == PvtState.showingFeedback;
  }

  Widget _buildContent() {
    switch (_controller.state) {
      case PvtState.idle:
        return _buildIdleState();
      case PvtState.instructions:
        return _buildInstructionsState();
      case PvtState.countdown:
        return _buildCountdownState();
      case PvtState.waitingForStimulus:
        return _buildWaitingState();
      case PvtState.stimulusShown:
        return _buildStimulusState();
      case PvtState.showingFeedback:
        return _buildFeedbackState();
      case PvtState.practiceComplete:
        return _buildPracticeCompleteState();
      case PvtState.complete:
        return _buildCompleteState();
    }
  }

  Widget _buildIdleState() {
    return Center(
      child: ElevatedButton(
        onPressed: () => _controller.start(),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
        ),
        child: const Text(
          'Start Test',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget _buildInstructionsState() {
    final titleStyle = widget.style.instructionsTitleStyle ??
        const TextStyle(
          color: Colors.white,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        );

    final bodyStyle = widget.style.instructionsBodyStyle ??
        const TextStyle(
          color: Colors.white70,
          fontSize: 18,
        );

    // Build instructions body, adding practice test mention if enabled
    String instructionsBody;
    if (widget.style.instructionsBody != null) {
      instructionsBody = widget.style.instructionsBody!;
    } else {
      instructionsBody = _getDefaultInstructionsBody();

      // Add practice test mention if enabled
      if (widget.config.enablePracticeTest) {
        instructionsBody +=
            '\n\nYou\'ll first complete a 30-second practice test to familiarize yourself with the task.';
      }
    }

    final durationText = _formatDuration(widget.config.duration);

    // Determine button text based on practice mode
    final buttonText = widget.config.enablePracticeTest
        ? 'Start Practice'
        : widget.style.instructionsButtonText;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.style.instructionsTitle,
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              instructionsBody,
              style: bodyStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Test Duration',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    durationText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () => _controller.proceedFromInstructions(),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            // Skip Practice button (only if practice enabled)
            if (widget.config.enablePracticeTest) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => _controller.skipPractice(),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text(
                  widget.style.skipPracticeButtonText,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white60,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getDefaultInstructionsBody() {
    final type = widget.config.stimulusType;
    final color = widget.style.stimulusColor ?? type.defaultColor;
    final colorName = _getColorName(color);
    final shapeName = type.displayName.toLowerCase();

    return 'Tap as quickly as possible when you see the $colorName $shapeName appear.';
  }

  String _getColorName(Color color) {
    if (color == Colors.red) return 'red';
    if (color == Colors.green) return 'green';
    if (color == Colors.blue) return 'blue';
    if (color == Colors.orange) return 'orange';
    if (color == Colors.purple) return 'purple';
    if (color == Colors.cyan) return 'cyan';
    if (color == Colors.yellow) return 'yellow';
    if (color == Colors.pink) return 'pink';
    if (color == Colors.white) return 'white';
    return 'colored';
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    if (minutes == 1) {
      return '1 minute';
    } else {
      return '$minutes minutes';
    }
  }

  Widget _buildCountdownState() {
    return Center(
      child: CountdownWidget(
        value: _controller.countdownValue,
        textStyle: widget.style.countdownTextStyle,
        label: widget.style.countdownLabel,
        labelStyle: widget.style.countdownLabelStyle,
      ),
    );
  }

  Widget _buildWaitingState() {
    // Show ghost stimulus if enabled
    if (widget.style.showGhostStimulus) {
      return ResponseArea(
        onTap: _handleTap,
        responseMode: widget.config.responseMode,
        buttonColor: widget.style.buttonColor,
        buttonTextColor: widget.style.buttonTextColor,
        buttonText: widget.style.buttonText,
        child: Opacity(
          opacity: widget.style.ghostStimulusOpacity,
          child: StimulusWidget(
            type: widget.config.stimulusType,
            size: widget.style.stimulusSize,
            color: Colors.grey,
          ),
        ),
      );
    }

    // Default: show waiting message
    final messageStyle = widget.style.waitingMessageStyle ??
        const TextStyle(
          color: Colors.white54,
          fontSize: 18,
        );

    return ResponseArea(
      onTap: _handleTap,
      responseMode: widget.config.responseMode,
      buttonColor: widget.style.buttonColor,
      buttonTextColor: widget.style.buttonTextColor,
      buttonText: widget.style.buttonText,
      child: Text(
        widget.style.waitingMessage,
        style: messageStyle,
      ),
    );
  }

  Widget _buildStimulusState() {
    return ResponseArea(
      onTap: _handleTap,
      responseMode: widget.config.responseMode,
      buttonColor: widget.style.buttonColor,
      buttonTextColor: widget.style.buttonTextColor,
      buttonText: widget.style.buttonText,
      child: StimulusWidget(
        type: widget.config.stimulusType,
        size: widget.style.stimulusSize,
        color: widget.style.stimulusColor,
      ),
    );
  }

  Widget _buildFeedbackState() {
    final rt = _controller.lastReactionTimeMs ?? 0;
    final color = _getColorForReactionTime(rt);

    final textStyle = widget.style.feedbackTextStyle ??
        TextStyle(
          color: color,
          fontSize: 48,
          fontWeight: FontWeight.bold,
        );

    return Center(
      child: Text(
        '${rt}ms',
        style: textStyle,
      ),
    );
  }

  Color _getColorForReactionTime(int rtMs) {
    if (rtMs < 300) {
      return Colors.green;
    } else if (rtMs <= 400) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Widget _buildPracticeCompleteState() {
    final titleStyle = widget.style.practiceCompleteTitleStyle ??
        const TextStyle(
          color: Colors.white,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        );

    final messageStyle = widget.style.practiceCompleteMessageStyle ??
        const TextStyle(
          color: Colors.white70,
          fontSize: 18,
        );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.green[400],
            ),
            const SizedBox(height: 24),
            Text(
              widget.style.practiceCompleteTitle,
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              widget.style.practiceCompleteMessage,
              style: messageStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () => _controller.proceedFromPracticeComplete(),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              ),
              child: Text(
                widget.style.startRealTestButtonText,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompleteState() {
    return const Center(
      child: Text(
        'Test Complete',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTimer() {
    final remaining = _controller.remainingTestTime;
    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;
    final timeString = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    final timerStyle = widget.style.timerStyle ??
        const TextStyle(
          color: Colors.white38,
          fontSize: 16,
          fontFeatures: [FontFeature.tabularFigures()],
        );

    return Positioned(
      top: 16,
      left: 0,
      right: 0,
      child: Center(
        child: Text(
          timeString,
          style: timerStyle,
        ),
      ),
    );
  }
}
