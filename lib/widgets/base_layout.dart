import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/views/home_view.dart';
import 'package:todo_app/views/calendar_view.dart';
import 'package:todo_app/views/stats_view.dart';
import 'package:todo_app/views/settings_view.dart';

class BaseLayout extends StatelessWidget {
  final Widget body;
  final int currentIndex;

  const BaseLayout({
    super.key,
    required this.body,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              Get.offAll(() => const HomeView());
              break;
            case 1:
              Get.offAll(() => const CalendarView());
              break;
            case 2:
              Get.offAll(() => const StatsView());
              break;
            case 3:
              Get.offAll(() => const SettingsView());
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
