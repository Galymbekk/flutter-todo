import 'dart:convert';

class Task {
  final String id;
  final String title;
  bool isDone;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.isDone = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isDone': isDone,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'] as String,
        title: json['title'] as String,
        isDone: json['isDone'] as bool,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  static List<Task> listFromJson(String jsonString) {
    final List parsed = json.decode(jsonString) as List;
    return parsed.map((e) => Task.fromJson(e)).toList();
  }

  static String listToJson(List<Task> tasks) {
    return json.encode(tasks.map((t) => t.toJson()).toList());
  }
}
