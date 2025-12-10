import 'dart:math';

/// Generates random inter-stimulus intervals for the PVT.
class RandomIntervalGenerator {
  /// Creates a new random interval generator.
  ///
  /// [minInterval] is the minimum interval duration.
  /// [maxInterval] is the maximum interval duration.
  /// [seed] is an optional seed for reproducible random sequences.
  RandomIntervalGenerator({
    required this.minInterval,
    required this.maxInterval,
    int? seed,
  })  : assert(minInterval <= maxInterval),
        _random = seed != null ? Random(seed) : Random();

  /// The minimum interval duration.
  final Duration minInterval;

  /// The maximum interval duration.
  final Duration maxInterval;

  final Random _random;

  /// Generates the next random interval.
  ///
  /// Returns a [Duration] uniformly distributed between
  /// [minInterval] and [maxInterval].
  Duration next() {
    final minMs = minInterval.inMilliseconds;
    final maxMs = maxInterval.inMilliseconds;
    final rangeMs = maxMs - minMs;

    final randomMs = minMs + _random.nextInt(rangeMs + 1);
    return Duration(milliseconds: randomMs);
  }

  /// Generates multiple random intervals.
  ///
  /// Returns a list of [count] random intervals.
  List<Duration> generateMany(int count) {
    return List.generate(count, (_) => next());
  }
}
