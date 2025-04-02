import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NotificationItem {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'timestamp': timestamp.toIso8601String(),
        'isRead': isRead,
      };

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      NotificationItem(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        timestamp: DateTime.parse(json['timestamp']),
        isRead: json['isRead'] ?? false,
      );
}

class NotificationsController extends GetxController {
  final _storage = GetStorage();
  final _notificationsKey = 'notifications';

  final notifications = <NotificationItem>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void loadNotifications() {
    isLoading.value = true;
    try {
      final List<dynamic>? storedNotifications =
          _storage.read(_notificationsKey);
      if (storedNotifications != null) {
        notifications.value = storedNotifications
            .map((json) => NotificationItem.fromJson(json))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _saveNotifications() {
    try {
      _storage.write(
        _notificationsKey,
        notifications.map((n) => n.toJson()).toList(),
      );
    } catch (e) {
      debugPrint('Error saving notifications: $e');
    }
  }

  void addNotification(String title, String description) {
    final notification = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      timestamp: DateTime.now(),
    );
    notifications.insert(0, notification);
    _saveNotifications();
  }

  void deleteNotification(String id) {
    notifications.removeWhere((n) => n.id == id);
    _saveNotifications();
  }

  void clearAllNotifications() {
    notifications.clear();
    _saveNotifications();
  }

  void toggleReadStatus(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index].isRead = !notifications[index].isRead;
      _saveNotifications();
    }
  }

  void markAllAsRead() {
    for (var notification in notifications) {
      notification.isRead = true;
    }
    _saveNotifications();
  }
}
