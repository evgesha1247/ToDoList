import 'package:flutter/material.dart';
import 'package:my_flutter_app/ui/widget/task_form/task_form_widget_model.dart';

class TaskFormWidget extends StatefulWidget {
  final int groupkey;
  const TaskFormWidget({Key? key, required this.groupkey}) : super(key: key);
  @override
  State<TaskFormWidget> createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  late final TaskFormWidgetModel _model;
  @override
  void initState() {
    _model = TaskFormWidgetModel(groupKey: widget.groupkey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TasksFormWidgetModelProvider(
      model: _model,
      child: const _TaskFormWidgetBody(),
    );
  }
}

class _TaskFormWidgetBody extends StatelessWidget {
  const _TaskFormWidgetBody({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
          'new task',
          style: TextStyle(
            color: Color(0xff212121),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: _TasksTextWidget(),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'сохранить задачу',
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
        onPressed: () => TasksFormWidgetModelProvider.read(context)
            ?.model
            ?.saveTask(context),
      ),
    );
  }
}

class _TasksTextWidget extends StatelessWidget {
  const _TasksTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TasksFormWidgetModelProvider.read(context)?.model;
    return TextField(
      autofocus: true,
      maxLines: null,
      minLines: null,
      expands: true,
      onEditingComplete: () => model?.saveTask(context),
      onChanged: (value) => model?.taskText = value,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'text task . . .',
      ),
    );
  }
}
