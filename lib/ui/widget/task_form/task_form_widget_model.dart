import 'package:my_flutter_app/domain/data_provider/box.manager.dart';

import 'package:flutter/material.dart';
import 'package:my_flutter_app/domain/entity/task.dart';

class TaskFormWidgetModel {
  String taskText = '';
  int groupKey;
  TaskFormWidgetModel({required this.groupKey});

  void saveTask(BuildContext context) async {
    if (taskText.isEmpty) return;
    final task = Task(isDone: false, text: taskText);
    final box = await BoxManadger.instance.openBoxTask(groupKey);
    await box.add(task);

    Navigator.of(context).pop();
  }
}

class TasksFormWidgetModelProvider extends InheritedNotifier {
  final TaskFormWidgetModel? model;
  const TasksFormWidgetModelProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(key: key, child: child);

  static TasksFormWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TasksFormWidgetModelProvider>();
  }

  static TasksFormWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TasksFormWidgetModelProvider>()
        ?.widget;
    return widget is TasksFormWidgetModelProvider ? widget : null;
  }
}
