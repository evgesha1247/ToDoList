import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_flutter_app/domain/entity/group.dart';
import '../entity/task.dart';

class BoxManadger {
  static final BoxManadger instance = BoxManadger._();
  final Map<String, int> _boxCount = <String, int>{};
  BoxManadger._();
  Future<Box<Group>> openBoxGroup() async {
    return _openBox('group_box', 1, GroupAdapter());
  }

  Future<Box<Task>> openBoxTask(int groupKey) async {
    return _openBox(makeTaskBoxName(groupKey), 2, TaskAdapter());
  }

  String makeTaskBoxName(int groupKey) => 'tasks_box_$groupKey';

  Future<void> clousBox<T>(Box<T> box) async {
    if (!box.isOpen) {
      _boxCount.remove(box.name);
      return;
    }
    final count = _boxCount[box.name] ?? 1;
    _boxCount[box.name] = count - 1;
    if (count > 0) return;
    _boxCount.remove(box.name);
    await box.compact();
    await box.close();
  }

  Future<Box<T>> _openBox<T>(
    String name,
    int typeId,
    TypeAdapter<T> adapter,
  ) async {
    if (Hive.isBoxOpen(name)) {
      final count = _boxCount[name] ?? 1;
      _boxCount[name] = count + 1;
      return Hive.box(name);
    }
    _boxCount[name] = 1;
    if (!Hive.isAdapterRegistered(typeId)) {
      Hive.registerAdapter(adapter);
    }
    return await Hive.openBox<T>(name);
  }
}
