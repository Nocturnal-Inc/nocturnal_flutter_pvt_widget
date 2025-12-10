import 'package:flutter/material.dart';
import 'package:psychomotor_vigilance_test/psychomotor_vigilance_test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PVT Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // === Test Settings (PvtConfig) ===
  int _durationMinutes = 1;
  int _minISISeconds = 2;
  int _maxISISeconds = 10;
  int _countdownSeconds = 3;
  StimulusType _stimulusType = StimulusType.circle;
  ResponseMode _responseMode = ResponseMode.tapAnywhere;
  bool _enableSound = false;
  bool _enableHaptic = true;

  // === Visual Settings (PvtStyle) ===
  double _stimulusSize = 120;
  bool _showGhostStimulus = true;
  double _ghostStimulusOpacity = 0.15;
  Color _backgroundColor = Colors.black;
  Color _stimulusColor = Colors.red;
  bool _useDefaultStimulusColor = true;

  // === Display Settings (PvtStyle) ===
  bool _showTimer = true;
  bool _showReactionTimeFeedback = true;
  int _feedbackDurationMs = 800;
  bool _showCancelButton = true;
  bool _showInstructions = true;
  bool _enablePracticeTest = false;

  void _startTest() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TestScreen(
          config: PvtConfig(
            duration: Duration(minutes: _durationMinutes),
            minInterStimulusInterval: Duration(seconds: _minISISeconds),
            maxInterStimulusInterval: Duration(seconds: _maxISISeconds),
            countdownDuration: Duration(seconds: _countdownSeconds),
            stimulusType: _stimulusType,
            responseMode: _responseMode,
            enableSound: _enableSound,
            enableHaptic: _enableHaptic,
            enablePracticeTest: _enablePracticeTest,
          ),
          style: PvtStyle(
            backgroundColor: _backgroundColor,
            stimulusColor: _useDefaultStimulusColor ? null : _stimulusColor,
            stimulusSize: _stimulusSize,
            showTimer: _showTimer,
            showGhostStimulus: _showGhostStimulus,
            ghostStimulusOpacity: _ghostStimulusOpacity,
            showReactionTimeFeedback: _showReactionTimeFeedback,
            feedbackDuration: Duration(milliseconds: _feedbackDurationMs),
            showInstructions: _showInstructions,
          ),
          showCancelButton: _showCancelButton,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PVT Test'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // === Test Settings Section ===
          _buildSectionHeader('Test Settings'),
          const SizedBox(height: 8),

          // Duration
          ListTile(
            title: const Text('Test Duration'),
            subtitle: Text('$_durationMinutes minute${_durationMinutes > 1 ? 's' : ''}'),
            trailing: DropdownButton<int>(
              value: _durationMinutes,
              items: [1, 2, 3, 5, 10].map((minutes) {
                return DropdownMenuItem(
                  value: minutes,
                  child: Text('$minutes min'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _durationMinutes = value);
                }
              },
            ),
          ),

          // Min ISI
          ListTile(
            title: const Text('Min Stimulus Interval'),
            subtitle: Text('$_minISISeconds seconds'),
            trailing: DropdownButton<int>(
              value: _minISISeconds,
              items: [1, 2, 3, 4, 5].map((seconds) {
                return DropdownMenuItem(
                  value: seconds,
                  child: Text('$seconds sec'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null && value <= _maxISISeconds) {
                  setState(() => _minISISeconds = value);
                }
              },
            ),
          ),

          // Max ISI
          ListTile(
            title: const Text('Max Stimulus Interval'),
            subtitle: Text('$_maxISISeconds seconds'),
            trailing: DropdownButton<int>(
              value: _maxISISeconds,
              items: [5, 6, 7, 8, 9, 10, 12, 15].map((seconds) {
                return DropdownMenuItem(
                  value: seconds,
                  child: Text('$seconds sec'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null && value >= _minISISeconds) {
                  setState(() => _maxISISeconds = value);
                }
              },
            ),
          ),

          // Countdown
          ListTile(
            title: const Text('Countdown Duration'),
            subtitle: Text(_countdownSeconds == 0
                ? 'No countdown'
                : '$_countdownSeconds seconds'),
            trailing: DropdownButton<int>(
              value: _countdownSeconds,
              items: [0, 1, 2, 3, 5].map((seconds) {
                return DropdownMenuItem(
                  value: seconds,
                  child: Text(seconds == 0 ? 'None' : '$seconds sec'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _countdownSeconds = value);
                }
              },
            ),
          ),

          const Divider(height: 32),

          // === Stimulus Settings Section ===
          _buildSectionHeader('Stimulus Settings'),
          const SizedBox(height: 8),

          // Stimulus Type
          ListTile(
            title: const Text('Stimulus Type'),
            subtitle: Text(_stimulusType.displayName),
            trailing: DropdownButton<StimulusType>(
              value: _stimulusType,
              items: StimulusType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _stimulusType = value);
                }
              },
            ),
          ),

          // Stimulus Size
          ListTile(
            title: const Text('Stimulus Size'),
            subtitle: Text('${_stimulusSize.toInt()} pixels'),
          ),
          Slider(
            value: _stimulusSize,
            min: 60,
            max: 200,
            divisions: 14,
            label: '${_stimulusSize.toInt()}px',
            onChanged: (value) {
              setState(() => _stimulusSize = value);
            },
          ),

          // Use Default Stimulus Color
          SwitchListTile(
            title: const Text('Use Default Stimulus Color'),
            subtitle: Text(_useDefaultStimulusColor
                ? 'Using default color for stimulus type'
                : 'Using custom color'),
            value: _useDefaultStimulusColor,
            onChanged: (value) {
              setState(() => _useDefaultStimulusColor = value);
            },
          ),

          // Custom Stimulus Color (only show if not using default)
          if (!_useDefaultStimulusColor)
            ListTile(
              title: const Text('Stimulus Color'),
              trailing: _buildColorSelector(
                _stimulusColor,
                (color) => setState(() => _stimulusColor = color),
              ),
            ),

          // Ghost Stimulus
          SwitchListTile(
            title: const Text('Show Ghost Stimulus'),
            subtitle: const Text('Show faded stimulus while waiting'),
            value: _showGhostStimulus,
            onChanged: (value) {
              setState(() => _showGhostStimulus = value);
            },
          ),

          // Ghost Opacity (only show if ghost stimulus enabled)
          if (_showGhostStimulus)
            ListTile(
              title: const Text('Ghost Opacity'),
              subtitle: Text('${(_ghostStimulusOpacity * 100).toInt()}%'),
            ),
          if (_showGhostStimulus)
            Slider(
              value: _ghostStimulusOpacity,
              min: 0.05,
              max: 0.5,
              divisions: 9,
              label: '${(_ghostStimulusOpacity * 100).toInt()}%',
              onChanged: (value) {
                setState(() => _ghostStimulusOpacity = value);
              },
            ),

          const Divider(height: 32),

          // === Response Settings Section ===
          _buildSectionHeader('Response Settings'),
          const SizedBox(height: 8),

          // Response Mode
          ListTile(
            title: const Text('Response Mode'),
            subtitle: Text(_responseMode == ResponseMode.tapAnywhere
                ? 'Tap anywhere on screen'
                : 'Tap button to respond'),
            trailing: DropdownButton<ResponseMode>(
              value: _responseMode,
              items: ResponseMode.values.map((mode) {
                return DropdownMenuItem(
                  value: mode,
                  child: Text(mode == ResponseMode.tapAnywhere
                      ? 'Tap Anywhere'
                      : 'Tap Button'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _responseMode = value);
                }
              },
            ),
          ),

          // Sound Feedback
          SwitchListTile(
            title: const Text('Sound Feedback'),
            subtitle: const Text('Play sound on response'),
            value: _enableSound,
            onChanged: (value) {
              setState(() => _enableSound = value);
            },
          ),

          // Haptic Feedback
          SwitchListTile(
            title: const Text('Haptic Feedback'),
            subtitle: const Text('Vibrate on response'),
            value: _enableHaptic,
            onChanged: (value) {
              setState(() => _enableHaptic = value);
            },
          ),

          // Show Reaction Time Feedback
          SwitchListTile(
            title: const Text('Show Reaction Time'),
            subtitle: const Text('Display RT after each response'),
            value: _showReactionTimeFeedback,
            onChanged: (value) {
              setState(() => _showReactionTimeFeedback = value);
            },
          ),

          // Feedback Duration (only show if RT feedback enabled)
          if (_showReactionTimeFeedback)
            ListTile(
              title: const Text('Feedback Duration'),
              subtitle: Text('$_feedbackDurationMs ms'),
              trailing: DropdownButton<int>(
                value: _feedbackDurationMs,
                items: [400, 600, 800, 1000, 1500].map((ms) {
                  return DropdownMenuItem(
                    value: ms,
                    child: Text('$ms ms'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _feedbackDurationMs = value);
                  }
                },
              ),
            ),

          const Divider(height: 32),

          // === Display Settings Section ===
          _buildSectionHeader('Display Settings'),
          const SizedBox(height: 8),

          // Background Color
          ListTile(
            title: const Text('Background Color'),
            trailing: _buildColorSelector(
              _backgroundColor,
              (color) => setState(() => _backgroundColor = color),
              colors: [Colors.black, Colors.grey[900]!, Colors.blueGrey[900]!],
            ),
          ),

          // Show Timer
          SwitchListTile(
            title: const Text('Show Timer'),
            subtitle: const Text('Display remaining time'),
            value: _showTimer,
            onChanged: (value) {
              setState(() => _showTimer = value);
            },
          ),

          // Show Cancel Button
          SwitchListTile(
            title: const Text('Show Cancel Button'),
            subtitle: const Text('Allow test to be cancelled'),
            value: _showCancelButton,
            onChanged: (value) {
              setState(() => _showCancelButton = value);
            },
          ),

          // Show Instructions
          SwitchListTile(
            title: const Text('Show Instructions'),
            subtitle: const Text('Display instructions before test'),
            value: _showInstructions,
            onChanged: (value) {
              setState(() => _showInstructions = value);
            },
          ),

          // Enable Practice Test
          SwitchListTile(
            title: const Text('Enable Practice Test'),
            subtitle: const Text('30-second practice before real test'),
            value: _enablePracticeTest,
            onChanged: (value) {
              setState(() => _enablePracticeTest = value);
            },
          ),

          const SizedBox(height: 32),

          // Start Button
          FilledButton.icon(
            onPressed: _startTest,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Test'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildColorSelector(
    Color selectedColor,
    ValueChanged<Color> onChanged, {
    List<Color>? colors,
  }) {
    final colorOptions = colors ?? [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: colorOptions.map((color) {
        final isSelected = selectedColor == color;
        return GestureDetector(
          onTap: () => onChanged(color),
          child: Container(
            width: 28,
            height: 28,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: Colors.white, width: 3)
                  : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.5),
                        blurRadius: 4,
                        spreadRadius: 1,
                      )
                    ]
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class TestScreen extends StatelessWidget {
  const TestScreen({
    super.key,
    required this.config,
    required this.style,
    required this.showCancelButton,
  });

  final PvtConfig config;
  final PvtStyle style;
  final bool showCancelButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PvtWidget(
        config: config,
        style: style,
        showCancelButton: showCancelButton,
        onCancel: () {
          Navigator.of(context).pop();
        },
        onComplete: (result) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ResultsScreen(result: result),
            ),
          );
        },
      ),
    );
  }
}

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({
    super.key,
    required this.result,
  });

  final PvtResult result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Results'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: PvtResultsWidget(
              result: result,
              showHelpSection: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Back to Home'),
            ),
          ),
        ],
      ),
    );
  }
}
