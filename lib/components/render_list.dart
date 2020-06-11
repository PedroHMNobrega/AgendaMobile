import 'package:app_agenda/components/task_card.dart';
import 'package:app_agenda/models/task.dart';
import 'package:flutter/material.dart';
import 'my_colors.dart';

class RenderList extends StatefulWidget {
  final List<Task> taskList;
  final Function refresh;
  final String emptyMessage;
  final bool showEditDialog;
  RenderList(this.taskList, this.refresh, {this.emptyMessage = 'Nenhuma Tarefa', this.showEditDialog = false});

  @override
  _RenderListState createState() => _RenderListState();
}

class _RenderListState extends State<RenderList> {
  @override
  Widget build(BuildContext context) {
    final List<Task> tasks = widget.taskList;
    if (tasks.length == 0) {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 38.0, bottom: 8),
            child: Icon(
              Icons.calendar_today,
              size: 60,
              color: MyColors().fontColor,
            ),
          ),
          Text(
            widget.emptyMessage,
            style: TextStyle(
              fontSize: 30,
              color: MyColors().fontColor,
            ),
          ),
        ],
      );
    }
    return Expanded(
      child: SizedBox(
        height: 200,
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, idx) {
            final Task task = tasks[idx];
            bool status = task.status == 1 ? true : false;
            if(widget.showEditDialog)
              return TaskCard(task.name, status, task.id, widget.refresh, taskDate: task.date);
            else
              return TaskCard(task.name, status, task.id, widget.refresh);
          },
        ),
      ),
    );
  }
}