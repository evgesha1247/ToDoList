import 'package:flutter/material.dart';
import 'package:my_flutter_app/ui/widget/groups/groups_widget_model.dart';
import 'package:provider/provider.dart';

class GroupsWidget extends StatefulWidget {
  const GroupsWidget({Key? key}) : super(key: key);

  @override
  State<GroupsWidget> createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<GroupsWidget> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GroupWidgetModel(),
      child: const GroupsWidgetBody(),
    );
  }

  @override
  void dispose() async {
    await GroupWidgetModel().dispose();
    super.deactivate();
  }
}

class GroupsWidgetBody extends StatelessWidget {
  const GroupsWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GroupWidgetModel model = context.read<GroupWidgetModel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'GROUP',
          style: TextStyle(
            color: Color(0xff212121),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          InkWell(
            onTap: () => model.editorToggle(),
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'editor',
                style: TextStyle(color: Color(0xff212121)),
              ),
            ),
          )
        ],
      ),
      body: const _GroupListWidget(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'добавить группу',
        backgroundColor: Colors.transparent,
        hoverColor: Colors.grey[300],
        splashColor: Colors.grey,
        elevation: 0,
        hoverElevation: 0,
        focusElevation: 0,
        disabledElevation: 0,
        highlightElevation: 0,
        child: Icon(
          Icons.create_new_folder_outlined,
          color: Colors.grey[800],
          size: 28,
        ),
        onPressed: () => model.showForm(context),
      ),
    );
  }
}

class _GroupListWidget extends StatelessWidget {
  const _GroupListWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final groupsCount = context.watch<GroupWidgetModel>().groups.length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView.separated(
        itemCount: groupsCount,
        itemBuilder: ((BuildContext context, int index) {
          return GroupListCardWidget(indexInLinst: index);
        }),
        separatorBuilder: ((BuildContext context, int index) {
          return const SizedBox(height: 8);
        }),
      ),
    );
  }
}

class GroupListCardWidget extends StatelessWidget {
  const GroupListCardWidget({Key? key, required this.indexInLinst})
      : super(key: key);
  final int indexInLinst;
  @override
  Widget build(BuildContext context) {
    GroupWidgetModel model = context.read<GroupWidgetModel>();
    final group = model.groups[indexInLinst];
    return InkWell(
      child: Container(
        height: 50,
        padding: const EdgeInsets.only(left: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.folder_open_outlined),
                const SizedBox(width: 15),
                Text(
                  group.name,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(right: 20),
                child: !model.isEditor
                    ? InkWell(
                        onTap: () => model.deleteGroup(indexInLinst),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                      )
                    // ? PopupMenuButton(
                    //     padding: const EdgeInsets.all(0),
                    //     offset: const Offset(15, 0),
                    //     itemBuilder: (context) => [
                    //       PopupMenuItem(
                    //         height: 30,
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: const [Icon(Icons.delete), Text('del')],
                    //         ),
                    //         onTap: () => model.deleteGroup(indexInLinst),
                    //       ),
                    //     ],
                    //   )
                    : const Icon(Icons.chevron_right))
          ],
        ),
      ),
      onTap: () => model.showTasks(context, indexInLinst),
    );
  }
}
