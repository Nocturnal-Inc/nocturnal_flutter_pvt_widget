import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibration/vibration.dart';

/// Callback type for custom sound feedback.
typedef SoundFeedbackCallback = Future<void> Function();

/// Service for providing haptic and audio feedback during the PVT.
///
/// By default, plays a built-in beep sound. Custom sound can be provided
/// via a callback.
class FeedbackService {
  FeedbackService._();

  static FeedbackService? _instance;
  static bool _isInitialized = false;
  static bool _hasVibrator = false;
  static SoundFeedbackCallback? _customSoundCallback;
  static AudioPlayer? _audioPlayer;
  static bool _useDefaultSound = true;

  /// Gets the singleton instance of the feedback service.
  static FeedbackService get instance {
    _instance ??= FeedbackService._();
    return _instance!;
  }

  /// Initializes the feedback service.
  ///
  /// Optionally accepts a custom sound callback for playing audio feedback.
  /// If no callback is provided, the default beep sound will be used.
  Future<void> initialize({SoundFeedbackCallback? soundCallback}) async {
    if (_isInitialized) return;

    _customSoundCallback = soundCallback;
    _useDefaultSound = soundCallback == null;

    try {
      _hasVibrator = await Vibration.hasVibrator();
    } catch (e) {
      _hasVibrator = false;
    }

    // Initialize audio player for default beep sound
    if (_useDefaultSound) {
      try {
        _audioPlayer = AudioPlayer();
        await _audioPlayer!.setAsset(
          'packages/psychomotor_vigilance_test/assets/sounds/beep.wav',
        );
      } catch (e) {
        // If asset loading fails, disable default sound
        _useDefaultSound = false;
        _audioPlayer?.dispose();
        _audioPlayer = null;
      }
    }

    _isInitialized = true;
  }

  /// Sets a custom sound callback.
  ///
  /// This allows consuming apps to provide their own sound implementation.
  /// Setting a callback disables the default beep sound.
  void setSoundCallback(SoundFeedbackCallback? callback) {
    _customSoundCallback = callback;
    _useDefaultSound = callback == null;

    // Dispose audio player if custom callback is set
    if (callback != null && _audioPlayer != null) {
      _audioPlayer!.dispose();
      _audioPlayer = null;
    }
  }

  /// Provides haptic feedback.
  ///
  /// Uses medium impact haptic feedback on supported devices.
  Future<void> playHaptic() async {
    try {
      // Use Flutter's built-in haptic feedback
      await HapticFeedback.mediumImpact();

      // Also use vibration package for stronger feedback if available
      if (_hasVibrator) {
        await Vibration.vibrate(duration: 50, amplitude: 128);
      }
    } catch (e) {
      // Silently ignore haptic feedback errors
    }
  }

  /// Plays sound feedback.
  ///
  /// Uses custom callback if provided, otherwise plays the default beep.
  Future<void> playSound() async {
    if (_customSoundCallback != null) {
      try {
        await _customSoundCallback!();
      } catch (e) {
        // Silently ignore sound errors
      }
    } else if (_useDefaultSound && _audioPlayer != null) {
      try {
        await _audioPlayer!.seek(Duration.zero);
        await _audioPlayer!.play();
      } catch (e) {
        // Silently ignore sound errors
      }
    }
  }

  /// Provides both sound and haptic feedback based on configuration.
  Future<void> playFeedback({
    bool enableSound = true,
    bool enableHaptic = true,
  }) async {
    final futures = <Future>[];

    if (enableHaptic) {
      futures.add(playHaptic());
    }

    if (enableSound) {
      futures.add(playSound());
    }

    if (futures.isNotEmpty) {
      await Future.wait(futures);
    }
  }

  /// Resets the service state.
  void dispose() {
    _audioPlayer?.dispose();
    _audioPlayer = null;
    _customSoundCallback = null;
    _useDefaultSound = true;
    _isInitialized = false;
  }
}
