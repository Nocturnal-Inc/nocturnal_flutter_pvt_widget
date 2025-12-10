import 'package:flutter_test/flutter_test.dart';
import 'package:psychomotor_vigilance_test/psychomotor_vigilance_test.dart';

void main() {
  group('StatisticsService', () {
    test('calculates correct statistics for valid trials', () {
      final now = DateTime.now();
      final trials = [
        TrialData(
          trialNumber: 1,
          stimulusOnsetTime: now,
          responseTime: now.add(const Duration(milliseconds: 200)),
          reactionTimeMs: 200,
        ),
        TrialData(
          trialNumber: 2,
          stimulusOnsetTime: now.add(const Duration(seconds: 5)),
          responseTime: now.add(const Duration(seconds: 5, milliseconds: 300)),
          reactionTimeMs: 300,
        ),
        TrialData(
          trialNumber: 3,
          stimulusOnsetTime: now.add(const Duration(seconds: 10)),
          responseTime: now.add(const Duration(seconds: 10, milliseconds: 400)),
          reactionTimeMs: 400,
        ),
      ];

      final result = StatisticsService.calculateResults(
        trials: trials,
        testStartTime: now,
        testEndTime: now.add(const Duration(minutes: 1)),
      );

      expect(result.totalTrials, 3);
      expect(result.validTrials, 3);
      expect(result.meanReactionTime, 300); // (200 + 300 + 400) / 3
      expect(result.medianReactionTime, 300);
      expect(result.fastestReactionTime, 200);
      expect(result.slowestReactionTime, 400);
      expect(result.falseStarts, 0);
      expect(result.lapses, 0);
      expect(result.misses, 0);
    });

    test('detects false starts correctly', () {
      final now = DateTime.now();
      final trials = [
        TrialData(
          trialNumber: 1,
          stimulusOnsetTime: now,
          responseTime: now.add(const Duration(milliseconds: 50)), // False start
          reactionTimeMs: 50,
        ),
        TrialData(
          trialNumber: 2,
          stimulusOnsetTime: now.add(const Duration(seconds: 5)),
          responseTime: now.add(const Duration(seconds: 5, milliseconds: 300)),
          reactionTimeMs: 300,
        ),
      ];

      final result = StatisticsService.calculateResults(
        trials: trials,
        testStartTime: now,
        testEndTime: now.add(const Duration(minutes: 1)),
      );

      expect(result.totalTrials, 2);
      expect(result.validTrials, 1);
      expect(result.falseStarts, 1);
    });

    test('detects lapses correctly', () {
      final now = DateTime.now();
      final trials = [
        TrialData(
          trialNumber: 1,
          stimulusOnsetTime: now,
          responseTime: now.add(const Duration(milliseconds: 600)), // Lapse
          reactionTimeMs: 600,
        ),
        TrialData(
          trialNumber: 2,
          stimulusOnsetTime: now.add(const Duration(seconds: 5)),
          responseTime: now.add(const Duration(seconds: 5, milliseconds: 300)),
          reactionTimeMs: 300,
        ),
      ];

      final result = StatisticsService.calculateResults(
        trials: trials,
        testStartTime: now,
        testEndTime: now.add(const Duration(minutes: 1)),
      );

      expect(result.totalTrials, 2);
      expect(result.lapses, 1);
      expect(result.lapsePercentage, 50.0);
    });

    test('handles empty trials', () {
      final now = DateTime.now();
      final result = StatisticsService.calculateResults(
        trials: [],
        testStartTime: now,
        testEndTime: now.add(const Duration(minutes: 1)),
      );

      expect(result.totalTrials, 0);
      expect(result.validTrials, 0);
      expect(result.meanReactionTime, 0);
      expect(result.medianReactionTime, 0);
      expect(result.standardDeviation, 0);
    });

    test('handles misses correctly', () {
      final now = DateTime.now();
      final trials = [
        TrialData(
          trialNumber: 1,
          stimulusOnsetTime: now,
          responseTime: null, // Miss
          reactionTimeMs: null,
        ),
        TrialData(
          trialNumber: 2,
          stimulusOnsetTime: now.add(const Duration(seconds: 5)),
          responseTime: now.add(const Duration(seconds: 5, milliseconds: 300)),
          reactionTimeMs: 300,
        ),
      ];

      final result = StatisticsService.calculateResults(
        trials: trials,
        testStartTime: now,
        testEndTime: now.add(const Duration(minutes: 1)),
      );

      expect(result.totalTrials, 2);
      expect(result.validTrials, 1);
      expect(result.misses, 1);
    });

    test('calculates median correctly for even number of trials', () {
      final now = DateTime.now();
      final trials = [
        TrialData(
          trialNumber: 1,
          stimulusOnsetTime: now,
          responseTime: now.add(const Duration(milliseconds: 200)),
          reactionTimeMs: 200,
        ),
        TrialData(
          trialNumber: 2,
          stimulusOnsetTime: now.add(const Duration(seconds: 5)),
          responseTime: now.add(const Duration(seconds: 5, milliseconds: 400)),
          reactionTimeMs: 400,
        ),
      ];

      final result = StatisticsService.calculateResults(
        trials: trials,
        testStartTime: now,
        testEndTime: now.add(const Duration(minutes: 1)),
      );

      expect(result.medianReactionTime, 300); // (200 + 400) / 2
    });
  });

  group('TrialData', () {
    test('identifies false start correctly', () {
      final now = DateTime.now();
      final trial = TrialData(
        trialNumber: 1,
        stimulusOnsetTime: now,
        responseTime: now.add(const Duration(milliseconds: 50)),
        reactionTimeMs: 50,
      );

      expect(trial.isFalseStart, true);
      expect(trial.isLapse, false);
      expect(trial.isMiss, false);
      expect(trial.isValid, false);
    });

    test('identifies lapse correctly', () {
      final now = DateTime.now();
      final trial = TrialData(
        trialNumber: 1,
        stimulusOnsetTime: now,
        responseTime: now.add(const Duration(milliseconds: 600)),
        reactionTimeMs: 600,
      );

      expect(trial.isFalseStart, false);
      expect(trial.isLapse, true);
      expect(trial.isMiss, false);
      expect(trial.isValid, true); // Lapses are still valid responses
    });

    test('identifies miss correctly', () {
      final now = DateTime.now();
      final trial = TrialData(
        trialNumber: 1,
        stimulusOnsetTime: now,
        responseTime: null,
        reactionTimeMs: null,
      );

      expect(trial.isFalseStart, false);
      expect(trial.isLapse, false);
      expect(trial.isMiss, true);
      expect(trial.isValid, false);
    });

    test('identifies valid response correctly', () {
      final now = DateTime.now();
      final trial = TrialData(
        trialNumber: 1,
        stimulusOnsetTime: now,
        responseTime: now.add(const Duration(milliseconds: 300)),
        reactionTimeMs: 300,
      );

      expect(trial.isFalseStart, false);
      expect(trial.isLapse, false);
      expect(trial.isMiss, false);
      expect(trial.isValid, true);
    });

    test('serializes to and from JSON correctly', () {
      final now = DateTime(2024, 1, 15, 10, 30, 0);
      final trial = TrialData(
        trialNumber: 1,
        stimulusOnsetTime: now,
        responseTime: now.add(const Duration(milliseconds: 300)),
        reactionTimeMs: 300,
      );

      final json = trial.toJson();
      final restored = TrialData.fromJson(json);

      expect(restored.trialNumber, trial.trialNumber);
      expect(restored.stimulusOnsetTime, trial.stimulusOnsetTime);
      expect(restored.responseTime, trial.responseTime);
      expect(restored.reactionTimeMs, trial.reactionTimeMs);
    });
  });

  group('PvtConfig', () {
    test('creates with default values', () {
      const config = PvtConfig();

      expect(config.duration, const Duration(minutes: 5));
      expect(config.minInterStimulusInterval, const Duration(seconds: 2));
      expect(config.maxInterStimulusInterval, const Duration(seconds: 10));
      expect(config.stimulusType, StimulusType.circle);
      expect(config.responseMode, ResponseMode.tapAnywhere);
      expect(config.enableSound, true);
      expect(config.enableHaptic, true);
      expect(config.countdownDuration, const Duration(seconds: 3));
    });

    test('copyWith creates modified copy', () {
      const original = PvtConfig();
      final modified = original.copyWith(
        duration: const Duration(minutes: 10),
        stimulusType: StimulusType.square,
      );

      expect(modified.duration, const Duration(minutes: 10));
      expect(modified.stimulusType, StimulusType.square);
      expect(modified.responseMode, original.responseMode);
    });

    test('equality works correctly', () {
      const config1 = PvtConfig();
      const config2 = PvtConfig();
      const config3 = PvtConfig(duration: Duration(minutes: 10));

      expect(config1, config2);
      expect(config1, isNot(config3));
    });
  });

  group('PvtResult', () {
    test('serializes to and from JSON correctly', () {
      final now = DateTime(2024, 1, 15, 10, 30, 0);
      final trials = [
        TrialData(
          trialNumber: 1,
          stimulusOnsetTime: now,
          responseTime: now.add(const Duration(milliseconds: 300)),
          reactionTimeMs: 300,
        ),
      ];

      final result = StatisticsService.calculateResults(
        trials: trials,
        testStartTime: now,
        testEndTime: now.add(const Duration(minutes: 1)),
      );

      final json = result.toJson();
      final restored = PvtResult.fromJson(json);

      expect(restored.totalTrials, result.totalTrials);
      expect(restored.validTrials, result.validTrials);
      expect(restored.meanReactionTime, result.meanReactionTime);
      expect(restored.medianReactionTime, result.medianReactionTime);
      expect(restored.trials.length, result.trials.length);
    });
  });
}
