import 'package:flutter_test/flutter_test.dart';
import 'package:psychomotor_vigilance_test/src/utils/random_interval.dart';

void main() {
  group('RandomIntervalGenerator', () {
    test('generates intervals within specified range', () {
      final generator = RandomIntervalGenerator(
        minInterval: const Duration(seconds: 2),
        maxInterval: const Duration(seconds: 10),
      );

      for (var i = 0; i < 100; i++) {
        final interval = generator.next();
        expect(
          interval.inMilliseconds,
          greaterThanOrEqualTo(2000),
        );
        expect(
          interval.inMilliseconds,
          lessThanOrEqualTo(10000),
        );
      }
    });

    test('generates reproducible sequence with seed', () {
      final generator1 = RandomIntervalGenerator(
        minInterval: const Duration(seconds: 2),
        maxInterval: const Duration(seconds: 10),
        seed: 42,
      );

      final generator2 = RandomIntervalGenerator(
        minInterval: const Duration(seconds: 2),
        maxInterval: const Duration(seconds: 10),
        seed: 42,
      );

      for (var i = 0; i < 10; i++) {
        expect(generator1.next(), generator2.next());
      }
    });

    test('generateMany returns correct number of intervals', () {
      final generator = RandomIntervalGenerator(
        minInterval: const Duration(seconds: 2),
        maxInterval: const Duration(seconds: 10),
      );

      final intervals = generator.generateMany(5);
      expect(intervals.length, 5);

      for (final interval in intervals) {
        expect(
          interval.inMilliseconds,
          greaterThanOrEqualTo(2000),
        );
        expect(
          interval.inMilliseconds,
          lessThanOrEqualTo(10000),
        );
      }
    });

    test('works with equal min and max intervals', () {
      final generator = RandomIntervalGenerator(
        minInterval: const Duration(seconds: 5),
        maxInterval: const Duration(seconds: 5),
      );

      for (var i = 0; i < 10; i++) {
        final interval = generator.next();
        expect(interval.inSeconds, 5);
      }
    });
  });
}
