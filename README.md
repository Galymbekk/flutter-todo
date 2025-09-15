#  Flutter ToDo App

Простое ToDo-приложение на **Flutter**.

##  Функционал
- Добавление задачи
- Удаление (свайп или иконка)
- Отметка выполнения (чекбокс)
- Фильтрация: All / Active / Completed
- Очистка всех задач
- Сохранение локально через **shared_preferences**

## UI
- Минималистичный Material Design
- Удобный и простой интерфейс

## Структура проекта
lib/
├─ main.dart
├─ models/task.dart
├─ services/task_storage.dart
├─ providers/task_provider.dart
├─ screens/home_screen.dart
└─ widgets/task_item.dart

##  Технологии
- Flutter / Dart  
- provider (состояние)  
- shared_preferences (локальное хранилище)

##  Запуск
1. Клонировать репозиторий:
```bash
- git clone https://github.com/<username>/<repo-name>.git
- cd <repo-name>

Установить зависимости:
- flutter pub get

Запустить в браузере (Chrome):
- flutter run -d chrome

 ## Примечание
- На Android/iOS сохранение работает стабильно.
- На Web данные сохраняются в localStorage, но могут сбрасываться при повторном запуске flutter run. Это ограничение Flutter Web.
