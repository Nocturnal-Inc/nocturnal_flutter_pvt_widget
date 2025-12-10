# Psychomotor Vigilance Test (PVT)

A Flutter package for implementing the Psychomotor Vigilance Test - a sustained-attention, reaction-time task that measures behavioral alertness.

## Features

- Configurable test duration and stimulus settings
- Multiple stimulus types (circle, square, cross, star)
- Optional practice test before the real test
- Reaction time feedback
- Comprehensive result statistics
- Fully customizable styling

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  psychomotor_vigilance_test: ^1.0.0
```

## Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:psychomotor_vigilance_test/psychomotor_vigilance_test.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PvtWidget(
        onComplete: (result) {
          print('Mean RT: ${result.meanReactionTime.toStringAsFixed(0)}ms');
          print('Lapses: ${result.lapses}');
        },
      ),
    );
  }
}
```

That's it! The widget uses sensible defaults:
- **Duration**: 5 minutes
- **Stimulus**: Red circle
- **Response**: Tap anywhere
- **Background**: Black

## With Common Options

```dart
PvtWidget(
  config: PvtConfig(
    duration: Duration(minutes: 3),
    stimulusType: StimulusType.circle,
    enablePracticeTest: true,
  ),
  style: PvtStyle(
    showInstructions: true,
    showTimer: true,
    showReactionTimeFeedback: true,
    showGhostStimulus: true,
  ),
  showCancelButton: true,
  onCancel: () => Navigator.pop(context),
  onComplete: (result) {
    // Navigate to results screen
  },
)
```

## Configuration Options

### PvtConfig

| Parameter | Default | Description |
|-----------|---------|-------------|
| `duration` | 5 minutes | Total test duration |
| `minInterStimulusInterval` | 2 seconds | Minimum wait before stimulus |
| `maxInterStimulusInterval` | 10 seconds | Maximum wait before stimulus |
| `stimulusType` | circle | Shape: circle, square, cross, star |
| `responseMode` | tapAnywhere | tapAnywhere or tapButton |
| `enableSound` | true | Play sound on response |
| `enableHaptic` | true | Vibrate on response |
| `countdownDuration` | 3 seconds | Pre-test countdown |
| `enablePracticeTest` | false | 30-second practice before test |
| `stimulusTimeout` | 30 seconds | Max wait time before recording a miss |

### PvtStyle

| Parameter | Default | Description |
|-----------|---------|-------------|
| `backgroundColor` | black | Test screen background |
| `stimulusColor` | null (uses default) | Stimulus color |
| `stimulusSize` | 100 | Stimulus size in pixels |
| `showTimer` | true | Show remaining time |
| `showInstructions` | false | Show instructions page |
| `showGhostStimulus` | false | Show faded stimulus while waiting |
| `showReactionTimeFeedback` | false | Show RT after each response |

## Results

The `PvtResult` object contains:

```dart
result.meanReactionTime      // Average RT in milliseconds
result.medianReactionTime    // Median RT
result.standardDeviation     // RT standard deviation
result.lapses                // Responses >= 500ms
result.falseStarts           // Responses < 100ms
result.totalTrials           // Total stimuli shown
result.validTrials           // Valid responses
result.fastestReactionTime   // Best RT
result.slowestReactionTime   // Worst RT
```

## Example App

See the `example/` folder for a full demo app with all configurable options.

## License

MIT
