import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_app/views/home_view.dart';

class OnboardingSlide {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingSlide({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;
  final storage = GetStorage();

  final slides = [
    OnboardingSlide(
      title: 'Manage Your Tasks Efficiently!',
      description:
          'Stay organized and boost your productivity with our intuitive task management system.',
      icon: Icons.task_alt,
      color: Colors.blue,
    ),
    OnboardingSlide(
      title: 'Get Notified & Stay On Track',
      description:
          'Never miss a deadline with smart notifications and reminders.',
      icon: Icons.notifications_active,
      color: Colors.orange,
    ),
    OnboardingSlide(
      title: 'Customize Your Experience',
      description:
          'Personalize your task management with themes, categories, and more.',
      icon: Icons.palette,
      color: Colors.purple,
    ),
  ];

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void nextPage() {
    if (currentPage.value < slides.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      getStarted();
    }
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void getStarted() {
    storage.write('isFirstTime', false);
    Get.offAll(() => const HomeView());
  }
}
