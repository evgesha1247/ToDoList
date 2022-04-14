import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_flutter_app/domain/data_provider/box.manager.dart';
import 'package:my_flutter_app/domain/entity/task.dart';
import 'package:my_flutter_app/ui/navigation/main_navigation.dart';
import 'package:my_flutter_app/ui/widget/task/task_widget.dart';

class TasksWidgetModel extends ChangeNotifier {
  TaskWidgetConfiguration configuration;
  ValueListenable<Object>? _listenablebox;
  late final Future<Box<Task>> _box;
  var _tasks = <Task>[];
  List<Task> get tasks => _tasks.toList();

  TasksWidgetModel({required this.configuration}) {
    _setup();
  }
  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteName.taskForm,
      arguments: configuration.groupKey,
    );
  }

  Future<void> deleteTasks(int taskIndex) async {
    await (await _box).deleteAt(taskIndex);
  }

  Future<void> doneToggle(int taskIndex) async {
    final task = (await _box).getAt(taskIndex);
    task?.isDone = !task.isDone;
    await task?.save();
  }

  Future<void> _readTasksFromHive() async {
    _tasks = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> _setup() async {
    _box = BoxManadger.instance.openBoxTask(configuration.groupKey);
    await _readTasksFromHive();
    _listenablebox = (await _box).listenable();
    _listenablebox?.addListener(_readTasksFromHive);
  }

  @override
  Future<void> dispose() async {
    _listenablebox?.removeListener(_readTasksFromHive);
    await BoxManadger.instance.clousBox(await _box);
    super.dispose();
  }
}

class TasksWidgetModelProvider extends InheritedNotifier {
  final TasksWidgetModel? model;
  const TasksWidgetModelProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(key: key, child: child, notifier: model);

  static TasksWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TasksWidgetModelProvider>();
  }

  static TasksWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TasksWidgetModelProvider>()
        ?.widget;
    return widget is TasksWidgetModelProvider ? widget : null;
  }
}
