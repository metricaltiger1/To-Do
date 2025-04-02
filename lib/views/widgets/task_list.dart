import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../controllers/task_controller.dart';
import '../../models/task_model.dart';
import 'task_tile.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;

  const TaskList({
    super.key,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();

    return AnimationLimiter(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) =>
                            taskController.toggleTaskCompletion(task.taskId),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        icon: task.isCompleted ? Icons.undo : Icons.check,
                        label: task.isCompleted ? 'Undo' : 'Complete',
                      ),
                      SlidableAction(
                        onPressed: (_) =>
                            taskController.deleteTask(task.taskId),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: TaskTile(task: task),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
