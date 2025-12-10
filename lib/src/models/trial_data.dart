import 'package:psychomotor_vigilance_test/src/models/pvt_config.dart';

/// Data for a single trial in the PVT.
class TrialData {
  /// Creates a new trial data record.
  const TrialData({
    required this.trialNumber,
    required this.stimulusOnsetTime,
    this.responseTime,
    this.reactionTimeMs,
  });

  /// The sequential number of this trial (1-indexed).
  final int trialNumber;

  /// The exact time when the stimulus appeared.
  final DateTime stimulusOnsetTime;

  /// The exact time when the user responded, or null if no response.
  final DateTime? responseTime;

  /// The reaction time in milliseconds, or null if no response.
  final int? reactionTimeMs;

  /// Whether this trial was a false start (response too fast).
  ///
  /// A response is considered a false start if it occurs within
  /// [PvtConfig.falseStartThreshold] of the stimulus onset.
  bool get isFalseStart {
    if (reactionTimeMs == null) return false;
    return reactionTimeMs! < PvtConfig.falseStartThreshold.inMilliseconds;
  }

  /// Whether this trial was a lapse (response too slow).
  ///
  /// A response is considered a lapse if it takes longer than
  /// [PvtConfig.lapseThreshold].
  bool get isLapse {
    if (reactionTimeMs == null) return false;
    return reactionTimeMs! >= PvtConfig.lapseThreshold.inMilliseconds;
  }

  /// Whether this trial was a miss (no response).
  bool get isMiss => responseTime == null;

  /// Whether this trial had a valid response.
  ///
  /// A valid response is one that is not a false start, not a miss,
  /// and the user actually responded.
  bool get isValid => !isFalseStart && !isMiss && reactionTimeMs != null;

  /// Creates a copy of this trial data with the given fields replaced.
  TrialData copyWith({
    int? trialNumber,
    DateTime? stimulusOnsetTime,
    DateTime? responseTime,
    int? reactionTimeMs,
  }) {
    return TrialData(
      trialNumber: trialNumber ?? this.trialNumber,
      stimulusOnsetTime: stimulusOnsetTime ?? this.stimulusOnsetTime,
      responseTime: responseTime ?? this.responseTime,
      reactionTimeMs: reactionTimeMs ?? this.reactionTimeMs,
    );
  }

  /// Creates a completed trial from the current pending trial.
  TrialData complete({
    required DateTime responseTime,
    required int reactionTimeMs,
  }) {
    return TrialData(
      trialNumber: trialNumber,
      stimulusOnsetTime: stimulusOnsetTime,
      responseTime: responseTime,
      reactionTimeMs: reactionTimeMs,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TrialData &&
        other.trialNumber == trialNumber &&
        other.stimulusOnsetTime == stimulusOnsetTime &&
        other.responseTime == responseTime &&
        other.reactionTimeMs == reactionTimeMs;
  }

  @override
  int get hashCode {
    return Object.hash(
      trialNumber,
      stimulusOnsetTime,
      responseTime,
      reactionTimeMs,
    );
  }

  @override
  String toString() {
    return 'TrialData('
        'trial: $trialNumber, '
        'rt: ${reactionTimeMs}ms, '
        'falseStart: $isFalseStart, '
        'lapse: $isLapse, '
        'miss: $isMiss)';
  }

  /// Converts this trial data to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'trialNumber': trialNumber,
      'stimulusOnsetTime': stimulusOnsetTime.toIso8601String(),
      'responseTime': responseTime?.toIso8601String(),
      'reactionTimeMs': reactionTimeMs,
      'isFalseStart': isFalseStart,
      'isLapse': isLapse,
      'isMiss': isMiss,
      'isValid': isValid,
    };
  }

  /// Creates trial data from a JSON map.
  factory TrialData.fromJson(Map<String, dynamic> json) {
    return TrialData(
      trialNumber: json['trialNumber'] as int,
      stimulusOnsetTime: DateTime.parse(json['stimulusOnsetTime'] as String),
      responseTime: json['responseTime'] != null
          ? DateTime.parse(json['responseTime'] as String)
          : null,
      reactionTimeMs: json['reactionTimeMs'] as int?,
    );
  }
}
