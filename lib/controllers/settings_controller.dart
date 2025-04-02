import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  final _storage = GetStorage();

  // Theme settings
  final isDarkMode = false.obs;
  final accentColor = Colors.blue.obs;

  // Notification settings
  final pushNotifications = true.obs;
  final emailNotifications = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  void loadSettings() {
    // Load theme settings
    isDarkMode.value = _storage.read('isDarkMode') ?? false;
    final savedColor = _storage.read('accentColor');
    if (savedColor != null) {
      accentColor.value = _getMaterialColor(savedColor);
    }

    // Load notification settings
    pushNotifications.value = _storage.read('pushNotifications') ?? true;
    emailNotifications.value = _storage.read('emailNotifications') ?? false;
  }

  void _saveSettings() {
    _storage.write('isDarkMode', isDarkMode.value);
    _storage.write('accentColor', accentColor.value.value);
    _storage.write('pushNotifications', pushNotifications.value);
    _storage.write('emailNotifications', emailNotifications.value);
  }

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
    _saveSettings();
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  void setAccentColor(MaterialColor color) {
    accentColor.value = color;
    _saveSettings();
    // TODO: Update app theme with new accent color
  }

  void togglePushNotifications(bool value) {
    pushNotifications.value = value;
    _saveSettings();
  }

  void toggleEmailNotifications(bool value) {
    emailNotifications.value = value;
    _saveSettings();
  }

  void clearAllData() {
    _storage.erase();
    loadSettings();
    // TODO: Clear other app data (tasks, categories, etc.)
    Get.snackbar(
      'Data Cleared',
      'All app data has been cleared',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void exportData() {
    // TODO: Implement data export functionality
    Get.snackbar(
      'Export Data',
      'Data export functionality coming soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  MaterialColor _getMaterialColor(int colorValue) {
    final color = Color(colorValue);
    if (color == Colors.blue) return Colors.blue;
    if (color == Colors.purple) return Colors.purple;
    if (color == Colors.pink) return Colors.pink;
    if (color == Colors.red) return Colors.red;
    if (color == Colors.orange) return Colors.orange;
    if (color == Colors.amber) return Colors.amber;
    if (color == Colors.yellow) return Colors.yellow;
    if (color == Colors.lightGreen) return Colors.lightGreen;
    if (color == Colors.green) return Colors.green;
    if (color == Colors.teal) return Colors.teal;
    return Colors.blue; // Default color
  }
}
