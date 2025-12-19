import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_app_header.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/task_card.dart';
import '../providers/task_provider.dart';
import 'new_task_screen.dart';
import 'search_screen.dart';
import 'task_detail_screen.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(filteredTasksProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          const CustomAppHeader(title: "Focus.Me", showSettings: true),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SearchScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).cardColor : const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              ref.watch(searchQueryProvider).isEmpty ? "Search" : ref.watch(searchQueryProvider),
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: ref.watch(searchQueryProvider).isEmpty ? Colors.grey : Theme.of(context).textTheme.bodyMedium?.color,
                              ),
                            ),
                          ),
                          if (ref.watch(searchQueryProvider).isNotEmpty)
                            GestureDetector(
                              onTap: () => ref.read(searchQueryProvider.notifier).state = '',
                              child: const Icon(Icons.close, color: Colors.grey),
                            )
                          else
                            Container(
                               margin: const EdgeInsets.all(8), // Placeholder to match height? Or just null
                               width: 24, height: 24, // Approximation of IconButton size
                               decoration: const BoxDecoration(
                                 // color: Color(0xFFE0E0E0), // Matching the old logic circle
                                 // shape: BoxShape.circle,
                               ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text("Tarefas", style: AppTextStyles.titleMedium),
                  const SizedBox(height: 16),
                  if (tasks.isEmpty)
                     Padding(
                       padding: const EdgeInsets.only(top: 32.0),
                       child: Center(child: Text("Nenhuma tarefa encontrada.", style: AppTextStyles.bodyMedium)),
                     ),
                  ...tasks.map((task) => TaskCard(
                    key: ValueKey(task.id),
                    title: task.title,
                    description: task.description,
                    isCompleted: task.isCompleted,
                    onToggle: (_) => ref.read(taskProvider.notifier).toggleTaskCompletion(task.id),
                    onDescriptionChanged: (val) {
                         // Logic from before
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
                      );
                    },
                  )).toList(),
                  const SizedBox(height: 80), // Space for FAB
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewTaskScreen()),
          );
        },
        backgroundColor: Colors.grey[300], // Adjust per image 0 if visible
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
