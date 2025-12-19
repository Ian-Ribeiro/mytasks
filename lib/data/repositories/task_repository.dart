import 'package:hive/hive.dart';
import '../models/task_model.dart';

class TaskRepository {
  static const String boxName = 'tasksBox';

  Future<Box<Task>> _getBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<Task>(boxName);
    }
    return await Hive.openBox<Task>(boxName);
  }

  Future<List<Task>> getTasks() async {
    final box = await _getBox();
    return box.values.toList();
  }

  Future<void> addTask(Task task) async {
    final box = await _getBox();
    await box.put(task.id, task);
  }

  Future<void> updateTask(Task task) async {
    // Hive objects can save themselves if they are in a box
    if (task.isInBox) {
      await task.save();
    } else {
      final box = await _getBox();
      await box.put(task.id, task);
    }
  }

  Future<void> deleteTask(String taskId) async {
    final box = await _getBox();
    await box.delete(taskId);
  }
}
