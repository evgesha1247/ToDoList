import 'package:flutter/material.dart';
import 'package:my_flutter_app/ui/widget/task/task_widget_model.dart';

class TaskWidgetConfiguration {
  int groupKey;
  String title;
  TaskWidgetConfiguration(this.groupKey, this.title);
}

class TaskWidget extends StatefulWidget {
  final TaskWidgetConfiguration configuration;
  const TaskWidget({Key? key, required this.configuration}) : super(key: key);
  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  late final TasksWidgetModel _model;
  @override
  @override
  void initState() {
    _model = TasksWidgetModel(configuration: widget.configuration);
    super.initState();
  }

  @override
  void deactivate() async {
    await _model.dispose();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return TasksWidgetModelProvider(
      model: _model,
      child: const TaskWidgetBody(),
    );
  }
}

class TaskWidgetBody extends StatelessWidget {
  const TaskWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.watch(context)?.model;
    final title = model?.configuration.title ?? 'задачи';
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
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xff212121),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const _TasksListWidget(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'добавить задачу',
        backgroundColor: Colors.transparent,
        hoverColor: Colors.grey[300],
        splashColor: Colors.grey,
        elevation: 0,
        hoverElevation: 0,
        focusElevation: 0,
        disabledElevation: 0,
        highlightElevation: 0,
        onPressed: () => model?.showForm(context),
        child: Icon(
          Icons.add,
          color: Colors.grey[800],
          size: 28,
        ),
      ),
    );
  }
}

class _TasksListWidget extends StatelessWidget {
  const _TasksListWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final groupsCount =
        TasksWidgetModelProvider.watch(context)?.model?.tasks.length ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView.separated(
        itemCount: groupsCount,
        itemBuilder: ((BuildContext context, int index) {
          return TasksListCardWidget(indexInLinst: index);
        }),
        separatorBuilder: ((BuildContext context, int index) {
          return const SizedBox(height: 8);
        }),
      ),
    );
  }
}

class TasksListCardWidget extends StatelessWidget {
  const TasksListCardWidget({Key? key, required this.indexInLinst})
      : super(key: key);
  final int indexInLinst;
  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.read(context)!.model;
    final task = model?.tasks[indexInLinst];
    final iconTask =
        task!.isDone ? Icons.radio_button_checked : Icons.radio_button_off;
    final staleTask = task.isDone
        ? const TextStyle(
            fontSize: 13,
            color: Colors.grey,
            decoration: TextDecoration.lineThrough,
          )
        : const TextStyle(
            fontSize: 18,
          );
    return InkWell(
      child: Container(
        padding: const EdgeInsets.only(left: 15),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(iconTask,
                        color: !task.isDone
                            ? const Color.fromARGB(255, 200, 50, 70)
                            : const Color.fromARGB(250, 70, 200, 100)),
                    const SizedBox(width: 12),
                    Container(
                      margin: const EdgeInsets.only(top: 15, bottom: 15),
                      child: Text(task.text, style: staleTask),
                    ),
                  ],
                ),
                PopupMenuButton(
                  padding: const EdgeInsets.all(0),
                  offset: const Offset(15, 0),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [Icon(Icons.delete), Text('del')],
                      ),
                      onTap: () => model?.deleteTasks(indexInLinst),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () => model?.doneToggle(indexInLinst),
    );
  }
}
