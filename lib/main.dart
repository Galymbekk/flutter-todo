import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'services/task_storage.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = TaskStorage();
  runApp(MyApp(storage: storage));
}

class MyApp extends StatelessWidget {
  final TaskStorage storage;
  const MyApp({Key? key, required this.storage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskProvider>(
      create: (_) => TaskProvider(storage: storage),
      child: MaterialApp(
        title: 'ToDo Flutter',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}