import 'package:flutter/material.dart';
import 'package:my_flutter_app/ui/widget/group_form/group_form_widget.dart';
import 'package:my_flutter_app/ui/widget/groups/groups_widget.dart';
import 'package:my_flutter_app/ui/widget/task/task_widget.dart';
import 'package:my_flutter_app/ui/widget/task_form/task_form_widget.dart';

abstract class MainNavigationRouteName {
  static const groups = '/groups';
  static const groupsForm = '/groups/form';
  static const task = '/groups/task';
  static const taskForm = '/groups/task/form';
}

class MainNavigation {
  final initialRoute = MainNavigationRouteName.groups;
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteName.groups: (context) => const GroupsWidget(),
    MainNavigationRouteName.groupsForm: (context) => const GroupFormWidget(),
  };
  Route<Object>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteName.task:
        final configuration = settings.arguments as TaskWidgetConfiguration;
        return MaterialPageRoute(
          builder: (context) => TaskWidget(configuration: configuration),
        );
      case MainNavigationRouteName.taskForm:
        final groupkey = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) => TaskFormWidget(groupkey: groupkey),
        );
      default:
        MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('ошибка навигации !'),
            ),
          ),
        );
    }
    return null;
  }
}
