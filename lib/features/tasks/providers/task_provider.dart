import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/task_model.dart';
import '../../../data/models/search_history_model.dart';
import '../../../data/repositories/task_repository.dart';
import '../../../data/repositories/search_repository.dart';

final taskRepositoryProvider = Provider((ref) => TaskRepository());
final searchRepositoryProvider = Provider((ref) => SearchRepository());

// Tasks Logic
class TaskNotifier extends StateNotifier<List<Task>> {
  final TaskRepository _repository;

  TaskNotifier(this._repository) : super([]) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    final tasks = await _repository.getTasks();
    state = tasks;
  }

  Future<void> addTask(String title, String description) async {
    final task = Task(
      id: const Uuid().v4(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );
    await _repository.addTask(task);
    state = [...state, task];
  }

  Future<void> updateTask(Task task) async {
    await _repository.updateTask(task);
    // Reload or update locally
    state = [
      for (final t in state)
        if (t.id == task.id) task else t
    ];
  }

  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
    state = state.where((t) => t.id != id).toList();
  }

  Future<void> toggleTaskCompletion(String id) async {
    final task = state.firstWhere((t) => t.id == id);
    task.isCompleted = !task.isCompleted;
    await updateTask(task); 
    // State update handled in updateTask logic if we passed the same instance but modified?
    // Hive objects are mutable.
    // To trigger riverpod update, we need new object or new list ref.
    // 'state = [...]' in updateTask does that.
  }
}

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier(ref.watch(taskRepositoryProvider));
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(taskProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();

  if (query.isEmpty) {
    return tasks;
  }
  return tasks.where((t) {
    return t.title.toLowerCase().contains(query) ||
           t.description.toLowerCase().contains(query);
  }).toList();
});


// Search History Logic
class SearchHistoryNotifier extends StateNotifier<List<SearchHistory>> {
  final SearchRepository _repository;

  SearchHistoryNotifier(this._repository) : super([]) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    final history = await _repository.getHistory();
    state = history;
  }

  Future<void> addSearchTerm(String term) async {
    if (term.isEmpty) return;
    await _repository.addSearchTerm(term);
    await loadHistory();
  }

  Future<void> clearHistory() async {
    await _repository.clearHistory();
    state = [];
  }
}

final searchHistoryProvider = StateNotifierProvider<SearchHistoryNotifier, List<SearchHistory>>((ref) {
  return SearchHistoryNotifier(ref.watch(searchRepositoryProvider));
});
