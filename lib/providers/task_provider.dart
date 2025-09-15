import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_storage.dart';

enum FilterType { all, active, completed }

class TaskProvider extends ChangeNotifier {
  final TaskStorage storage;
  List<Task> _tasks = [];
  FilterType _filter = FilterType.all;
  bool _isLoading = true;

  TaskProvider({required this.storage}) {
    _load();
  }

  bool get isLoading => _isLoading;
  List<Task> get allTasks => List.unmodifiable(_tasks);

  List<Task> get tasks {
    switch (_filter) {
      case FilterType.active:
        return _tasks.where((t) => !t.isDone).toList();
      case FilterType.completed:
        return _tasks.where((t) => t.isDone).toList();
      case FilterType.all:
      default:
        return List.from(_tasks);
    }
  }

  FilterType get filter => _filter;

  Future<void> _load() async {
    _isLoading = true;
    notifyListeners();
    _tasks = await storage.loadTasks();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(String title) async {
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
    );
    _tasks.insert(0, task);
    await storage.saveTasks(_tasks);
    notifyListeners();
  }

  Future<void> toggleTask(String id) async {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    _tasks[idx].isDone = !_tasks[idx].isDone;
    await storage.saveTasks(_tasks);
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    await storage.saveTasks(_tasks);
    notifyListeners();
  }

  Future<void> setFilter(FilterType f) async {
    _filter = f;
    notifyListeners();
  }

  Future<void> clearAll() async {
    _tasks.clear();
    await storage.saveTasks(_tasks);
    notifyListeners();
  }
}