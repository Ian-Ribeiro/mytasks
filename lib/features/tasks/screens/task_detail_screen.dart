import 'package:flutter/material.dart';
import '../../../../data/models/task_model.dart';
import '../../../../core/theme/app_text_styles.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes da Tarefa"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: AppTextStyles.titleLarge,
            ),
            const SizedBox(height: 16),
            const Text(
              "Descrição:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              task.description.isEmpty ? "Sem descrição." : task.description,
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(
                  task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                  color: task.isCompleted ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  task.isCompleted ? "Concluída" : "Pendente",
                  style: TextStyle(
                    fontSize: 16,
                    color: task.isCompleted ? Colors.green : null,
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
