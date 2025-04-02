import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import '../models/task_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final _notifications = AwesomeNotifications();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    await _notifications.initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'task_reminders',
          channelName: 'Task Reminders',
          channelDescription: 'Notifications for task reminders',
          defaultColor: const Color(0xFF6750A4),
          importance: NotificationImportance.High,
          defaultRingtoneType: DefaultRingtoneType.Notification,
        )
      ],
    );
    _isInitialized = true;
  }

  Future<void> scheduleTaskReminder(Task task) async {
    if (!_isInitialized) await initialize();
    if (task.taskDate.isBefore(DateTime.now())) return;

    await _notifications.createNotification(
      content: NotificationContent(
        id: task.taskId.hashCode,
        channelKey: 'task_reminders',
        title: task.taskTitle,
        body: task.taskDescription ?? '',
      ),
      schedule: NotificationCalendar.fromDate(date: task.taskDate),
    );
  }

  Future<void> cancelTaskReminder(String taskId) async {
    if (!_isInitialized) await initialize();
    await _notifications.cancel(taskId.hashCode);
  }

  Future<void> cancelAllReminders() async {
    if (!_isInitialized) await initialize();
    await _notifications.cancelAll();
  }
}
