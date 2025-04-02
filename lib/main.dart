import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_app/config/theme_config.dart';
import 'package:todo_app/controllers/task_controller.dart';
import 'package:todo_app/services/notification_service.dart';
import 'package:todo_app/views/home_view.dart';
import 'package:todo_app/views/onboarding_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  final notificationService = NotificationService();
  await notificationService.initialize();
  Get.put(notificationService);

  Get.put(TaskController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    final isFirstTime = storage.read('isFirstTime') ?? true;

    return GetMaterialApp(
      title: 'Modern Todo App',
      theme: ThemeConfig.lightTheme,
      darkTheme: ThemeConfig.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: isFirstTime ? const OnboardingView() : const HomeView(),
    );
  }
}
