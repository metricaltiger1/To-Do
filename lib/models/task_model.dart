import 'package:uuid/uuid.dart';

enum TaskPriority { low, medium, high }

class Task {
  final String taskId;
  final String taskTitle;
  final String? taskDescription;
  final DateTime taskDate;
  final bool isCompleted;
  final TaskPriority taskPriority;
  final String category;

  Task({
    required this.taskId,
    required this.taskTitle,
    this.taskDescription,
    required this.taskDate,
    this.isCompleted = false,
    this.taskPriority = TaskPriority.medium,
    this.category = 'General',
  });

  Task copyWith({
    String? taskId,
    String? taskTitle,
    String? taskDescription,
    DateTime? taskDate,
    bool? isCompleted,
    TaskPriority? taskPriority,
    String? category,
  }) {
    return Task(
      taskId: taskId ?? this.taskId,
      taskTitle: taskTitle ?? this.taskTitle,
      taskDescription: taskDescription ?? this.taskDescription,
      taskDate: taskDate ?? this.taskDate,
      isCompleted: isCompleted ?? this.isCompleted,
      taskPriority: taskPriority ?? this.taskPriority,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'taskTitle': taskTitle,
      'taskDescription': taskDescription,
      'taskDate': taskDate.toIso8601String(),
      'isCompleted': isCompleted,
      'taskPriority': taskPriority.toString().split('.').last,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['taskId'] as String,
      taskTitle: json['taskTitle'] as String,
      taskDescription: json['taskDescription'] as String?,
      taskDate: DateTime.parse(json['taskDate'] as String),
      isCompleted: json['isCompleted'] as bool,
      taskPriority: TaskPriority.values.firstWhere(
        (e) => e.toString() == json['taskPriority'],
      ),
    );
  }
}
