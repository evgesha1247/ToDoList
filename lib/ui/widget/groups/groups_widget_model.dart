import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_flutter_app/domain/data_provider/box.manager.dart';
import 'package:my_flutter_app/domain/entity/group.dart';
import 'package:my_flutter_app/ui/navigation/main_navigation.dart';
import 'package:my_flutter_app/ui/widget/task/task_widget.dart';

class GroupWidgetModel extends ChangeNotifier {
  late final Future<Box<Group>> _box;
  ValueListenable<Object>? _listenablebox;
  var _groups = <Group>[];
  var isEditor = true;

  List<Group> get groups => _groups.toList();
  GroupWidgetModel() {
    _setup();
  }
  void editorToggle() {
    isEditor = !isEditor;
    notifyListeners();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteName.groupsForm);
  }

  Future<void> showTasks(BuildContext context, int groupIndex) async {
    final group = (await _box).getAt(groupIndex);
    if (group != null) {
      final configuration =
          TaskWidgetConfiguration(group.key as int, group.name);
      Navigator.of(context).pushNamed(
        MainNavigationRouteName.task,
        arguments: configuration,
      );
    }
  }

  Future<void> _readGroupFromHive() async {
    _groups = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> _setup() async {
    _box = BoxManadger.instance.openBoxGroup();
    await _readGroupFromHive();
    _listenablebox = (await _box).listenable();
    _listenablebox?.addListener(_readGroupFromHive);
  }

  Future<void> deleteGroup(int groupIndex) async {
    final box = await _box;
    final groupKey = (await _box).keyAt(groupIndex) as int;
    final taskBoxName = BoxManadger.instance.makeTaskBoxName(groupKey);
    await Hive.deleteBoxFromDisk(taskBoxName);
    await box.deleteAt(groupIndex);
  }

  @override
  Future<void> dispose() async {
    _listenablebox?.removeListener(_readGroupFromHive);
    await BoxManadger.instance.clousBox(await _box);
    super.dispose();
  }
}
