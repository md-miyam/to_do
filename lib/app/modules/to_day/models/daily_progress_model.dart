class DailyProgressModel {
  final String date; // yyyy-MM-dd
  final int totalTasks;
  final int completedTasks;
  final int deniedTasks;
  final int pendingTasks;
  final int completionRate;

  DailyProgressModel({
    required this.date,
    required this.totalTasks,
    required this.completedTasks,
    required this.deniedTasks,
    required this.pendingTasks,
    required this.completionRate,
  });

  Map<String, dynamic> toJson() => {
        'date': date,
        'totalTasks': totalTasks,
        'completedTasks': completedTasks,
        'deniedTasks': deniedTasks,
        'pendingTasks': pendingTasks,
        'completionRate': completionRate,
      };

  factory DailyProgressModel.fromJson(Map<String, dynamic> json) => DailyProgressModel(
        date: json['date'],
        totalTasks: json['totalTasks'] ?? 0,
        completedTasks: json['completedTasks'] ?? 0,
        deniedTasks: json['deniedTasks'] ?? 0,
        pendingTasks: json['pendingTasks'] ?? 0,
        completionRate: json['completionRate'] ?? 0,
      );
}
