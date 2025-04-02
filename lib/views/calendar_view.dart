import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/controllers/task_controller.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/widgets/base_layout.dart';
import 'package:todo_app/widgets/task_card.dart';
import 'package:todo_app/widgets/task_form.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskController = Get.find<TaskController>();
    final selectedDate = DateTime.now().obs;

    return BaseLayout(
      currentIndex: 1,
      body: SafeArea(
        child: Column(
          children: [
            // Calendar
            TableCalendar(
              firstDay: DateTime.now().subtract(const Duration(days: 365)),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: selectedDate.value,
              calendarFormat: CalendarFormat.month,
              selectedDayPredicate: (day) => isSameDay(selectedDate.value, day),
              onDaySelected: (selectedDay, focusedDay) {
                selectedDate.value = selectedDay;
                taskController.setSelectedDate(selectedDay);
              },
              onFormatChanged: (format) {
                // Handle format change if needed
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: theme.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Tasks for selected date
            Expanded(
              child: Obx(() {
                final tasks =
                    taskController.getTasksForDate(selectedDate.value);
                if (tasks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 64,
                          color: theme.colorScheme.primary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No tasks for this date',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskCard(
                      task: task,
                      onEdit: () => _showTaskForm(context, task),
                      onDelete: () => taskController.deleteTask(task.taskId),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showTaskForm(BuildContext context, [Task? task]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TaskForm(
        task: task,
        onSubmit: (updatedTask) {
          final taskController = Get.find<TaskController>();
          if (task == null) {
            taskController.addTask(updatedTask);
          } else {
            taskController.updateTask(updatedTask);
          }
          Navigator.pop(context);
        },
      ),
    );
  }
}
