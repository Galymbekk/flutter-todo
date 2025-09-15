import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTask(TaskProvider provider) {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Введите заголовок задачи'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    provider.addTask(text);
    _controller.clear();
    FocusScope.of(context).unfocus(); // Скрыть клавиатуру после добавления
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final items = provider.tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ToDo',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, size: 22),
            tooltip: 'Фильтры',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) => SizedBox(
                  height: 200,
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Все задачи'),
                        leading: const Icon(Icons.list),
                        onTap: () {
                          provider.setFilter(FilterType.all);
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Активные'),
                        leading: const Icon(Icons.radio_button_unchecked),
                        onTap: () {
                          provider.setFilter(FilterType.active);
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Завершенные'),
                        leading: const Icon(Icons.check_circle),
                        onTap: () {
                          provider.setFilter(FilterType.completed);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 22),
            tooltip: 'Очистить все',
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Очистить все задачи?'),
                  content: const Text('Это действие нельзя отменить.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Отмена'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text(
                        'Очистить',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
              if (confirmed == true) await provider.clearAll();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Добавить новую задачу...',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    onSubmitted: (_) => _addTask(provider),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.black87,
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () => _addTask(provider),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          
          // Список задач
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : items.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.list_alt, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Задач нет',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (ctx, i) => const Divider(height: 1),
                        itemBuilder: (ctx, i) => TaskItem(task: items[i]),
                      ),
          ),
        ],
      ),
    );
  }
}