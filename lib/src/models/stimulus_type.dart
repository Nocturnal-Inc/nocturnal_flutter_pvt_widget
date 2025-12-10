import 'package:flutter/material.dart';

/// Defines the type of visual stimulus shown during the PVT.
enum StimulusType {
  /// A filled circle (default: red)
  circle,

  /// A filled square (default: blue)
  square,

  /// A cross/plus sign (default: green)
  cross,

  /// A star shape (default: yellow)
  star,
}

/// Extension methods for [StimulusType].
extension StimulusTypeExtension on StimulusType {
  /// Returns the default color for this stimulus type.
  Color get defaultColor {
    switch (this) {
      case StimulusType.circle:
        return Colors.red;
      case StimulusType.square:
        return Colors.blue;
      case StimulusType.cross:
        return Colors.green;
      case StimulusType.star:
        return Colors.yellow;
    }
  }

  /// Returns a human-readable name for this stimulus type.
  String get displayName {
    switch (this) {
      case StimulusType.circle:
        return 'Circle';
      case StimulusType.square:
        return 'Square';
      case StimulusType.cross:
        return 'Cross';
      case StimulusType.star:
        return 'Star';
    }
  }
}

/// Defines how the user should respond to the stimulus.
enum ResponseMode {
  /// User can tap anywhere on the screen to respond.
  tapAnywhere,

  /// User must tap a specific button to respond.
  tapButton,
}
