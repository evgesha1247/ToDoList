import 'package:flutter/cupertino.dart';
import 'package:my_flutter_app/domain/data_provider/box.manager.dart';
import 'package:my_flutter_app/domain/entity/group.dart';

class GroupFormWidgetModel extends ChangeNotifier {
  String nameGroup = '';
  void saveGroup(BuildContext context) async {
    if (nameGroup.isEmpty) return;
    final box = await BoxManadger.instance.openBoxGroup();
    final group = Group(name: nameGroup);
    await box.add(group);

    Navigator.of(context).pop();
  }
}
