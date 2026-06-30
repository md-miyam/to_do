import 'dart:typed_data';

class AppUsageModel {
  final String packageName;
  String appLabel;
  final Uint8List? icon;
  final Duration usageTime;
  final DateTime lastUsed;

  AppUsageModel({
    required this.packageName,
    required this.appLabel,
    this.icon,
    required this.usageTime,
    required this.lastUsed,
  });

  Map<String, dynamic> toJson() {
    return {
      'packageName': packageName,
      'appLabel': appLabel,
      'usageTimeMs': usageTime.inMilliseconds,
      'lastUsedMs': lastUsed.millisecondsSinceEpoch,
    };
  }

  factory AppUsageModel.fromJson(Map<String, dynamic> json, {Uint8List? icon, String? label}) {
    return AppUsageModel(
      packageName: json['packageName'],
      appLabel: label ?? json['packageName'],
      icon: icon,
      usageTime: Duration(milliseconds: json['totalTimeInForeground']),
      lastUsed: DateTime.fromMillisecondsSinceEpoch(json['lastTimeUsed']),
    );
  }
}
