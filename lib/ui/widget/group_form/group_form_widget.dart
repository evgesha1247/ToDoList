import 'package:flutter/material.dart';
import 'package:my_flutter_app/ui/widget/group_form/group_form_widget_model.dart';
import 'package:provider/provider.dart';

class GroupFormWidget extends StatelessWidget {
  const GroupFormWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GroupFormWidgetModel(),
      child: const _GroupFormWidgetBody(),
    );
  }
}

class _GroupFormWidgetBody extends StatelessWidget {
  const _GroupFormWidgetBody({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    GroupFormWidgetModel model = context.read<GroupFormWidgetModel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.chevron_left,
            color: Color(0xff808080),
          ),
        ),
        title: const Text(
          'new group',
          style: TextStyle(
            color: Color(0xff212121),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const GroupNameWidget(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'сохранить группу',
        backgroundColor: Colors.transparent,
        hoverColor: Colors.grey[300],
        splashColor: Colors.grey,
        elevation: 0,
        hoverElevation: 0,
        focusElevation: 0,
        disabledElevation: 0,
        highlightElevation: 0,
        child: Icon(
          Icons.done,
          color: Colors.grey[800],
          size: 28,
        ),
        onPressed: () => model.saveGroup(context),
      ),
    );
  }
}

class GroupNameWidget extends StatelessWidget {
  const GroupNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GroupFormWidgetModel model = context.read<GroupFormWidgetModel>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text('Введите название для этой группы'),
          const SizedBox(height: 10),
          TextField(
            autofocus: true,
            onEditingComplete: () => model.saveGroup(context),
            onChanged: (value) => model.nameGroup = value,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromARGB(255, 66, 66, 66), width: 1.5),
              ),
              hintText: 'name',
            ),
          ),
        ],
      ),
    );
  }
}
