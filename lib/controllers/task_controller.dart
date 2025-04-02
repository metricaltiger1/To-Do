import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/task_model.dart';
import 'package:todo_app/services/notification_service.dart';

class TaskController extends GetxController {
  final _storage = GetStorage();
  final _tasksKey = 'tasks';
  final _notificationService = Get.find<NotificationService>();

  // Observable variables
  final _tasks = <Task>[].obs;
  final _filteredTasks = <Task>[].obs;
  final _searchQuery = ''.obs;
  final _selectedDate = DateTime.now().obs;
  final searchController = TextEditingController();

  // Getters
  List<Task> get tasks => _tasks;
  List<Task> get filteredTasks => _filteredTasks;
  String get searchQuery => _searchQuery.value;
  DateTime get selectedDate => _selectedDate.value;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
    // Set up a debounced search listener
    debounce(_searchQuery, (_) => filterTasks(),
        time: const Duration(milliseconds: 300));
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void loadTasks() {
    final tasksJson = _storage.read<List<dynamic>>(_tasksKey) ?? [];
    _tasks.value = tasksJson.map((json) => Task.fromJson(json)).toList();
    filterTasks();
  }

  void saveTasks() {
    final tasksJson = _tasks.map((task) => task.toJson()).toList();
    _storage.write(_tasksKey, tasksJson);
  }

  void addTask(Task task) {
    _tasks.add(task);
    saveTasks();
    filterTasks();
    _notificationService.scheduleTaskReminder(task);
  }

  void updateTask(Task task) {
    final index = _tasks.indexWhere((t) => t.taskId == task.taskId);
    if (index != -1) {
      _tasks[index] = task;
      saveTasks();
      filterTasks();
      _notificationService.cancelTaskReminder(task.taskId);
      _notificationService.scheduleTaskReminder(task);
    }
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.taskId == taskId);
    saveTasks();
    filterTasks();
    _notificationService.cancelTaskReminder(taskId);
  }

  void toggleTaskCompletion(String taskId) {
    final index = _tasks.indexWhere((task) => task.taskId == taskId);
    if (index != -1) {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
      saveTasks();
      filterTasks();
      if (task.isCompleted) {
        _notificationService.cancelTaskReminder(taskId);
      } else {
        _notificationService.scheduleTaskReminder(task);
      }
    }
  }

  void filterTasks() {
    if (_searchQuery.isEmpty) {
      _filteredTasks.value = _tasks;
      return;
    }

    final query = _searchQuery.value.toLowerCase();
    _filteredTasks.value = _tasks.where((task) {
      final titleMatch = task.taskTitle.toLowerCase().contains(query);
      final descriptionMatch =
          task.taskDescription?.toLowerCase().contains(query) ?? false;
      return titleMatch || descriptionMatch;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery.value = query;
  }

  void clearSearch() {
    _searchQuery.value = '';
    searchController.clear();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate.value = date;
    filterTasks();
  }

  List<Task> getTasksForDate(DateTime date) {
    return _tasks
        .where((task) =>
            task.taskDate.year == date.year &&
            task.taskDate.month == date.month &&
            task.taskDate.day == date.day)
        .toList();
  }

  List<Task> getTodayTasks() {
    final now = DateTime.now();
    return _tasks
        .where((task) =>
            task.taskDate.year == now.year &&
            task.taskDate.month == now.month &&
            task.taskDate.day == now.day)
        .toList();
  }

  List<Task> getUpcomingTasks() {
    final now = DateTime.now();
    return _tasks.where((task) => task.taskDate.isAfter(now)).toList();
  }

  List<Task> getCompletedTasks() {
    return _tasks.where((task) => task.isCompleted).toList();
  }
}
