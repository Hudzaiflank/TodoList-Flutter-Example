import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  final _taskBox = Hive.box('tasks');

  List<Task> get tasks {
    return _taskBox.values
        .map((task) => Task(
              title: task['title'],
              description: task['description'],
              dateTime: DateTime.parse(task['dateTime']),
            ))
        .toList();
  }

  void addTask(Task task) {
    _taskBox.add({
      'title': task.title,
      'description': task.description,
      'dateTime': task.dateTime.toIso8601String(),
    });
    notifyListeners();
  }

  void editTask(int index, Task task) {
    _taskBox.putAt(index, {
      'title': task.title,
      'description': task.description,
      'dateTime': task.dateTime.toIso8601String(),
    });
    notifyListeners();
  }

  void deleteTask(int index) {
    _taskBox.deleteAt(index);
    notifyListeners();
  }

  void printAllTasks() {
    final allTasks = _taskBox.values.toList();
    print("=== List of Tasks in Local Storage ===");
    for (int i = 0; i < allTasks.length; i++) {
      print('Task ${i + 1}: ${allTasks[i]}');
    }
    print("=====================================");
  }
}
