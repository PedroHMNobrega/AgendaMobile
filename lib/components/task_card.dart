import 'package:app_agenda/components/Dialogs/edit_task_dialog.dart';
import 'package:app_agenda/components/Dialogs/remove_task_dialog.dart';
import 'package:app_agenda/components/my_colors.dart';
import 'package:app_agenda/database/app_database.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatefulWidget {
  final String name;
  final int id;
  Function changeState;
  bool status;
  final DateTime taskDate;

  TaskCard(this.name, this.status, this.id, this.changeState, {this.taskDate});

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  Color background;

  @override
  Widget build(BuildContext context) {
    if (widget.status)
      background = MyColors().green;
    else
      background = MyColors().blue;

    return GestureDetector(
      onDoubleTap: () {
        showDialog(
          context: context,
          builder: (contextDialog) {
            if(widget.taskDate != null)
              return EditTaskDialog(widget.name, widget.id, widget.taskDate, (widget.status) ? 1 : 0);
            else
              return RemoveTaskDialog(widget.name, widget.id);
          },
        ).then((value) {
          widget.changeState();
        });
      },
      child: Card(
        color: background,
        child: ListTile(
          //leading: Icon(
          //  Icons.edit_attributes,
          //  color: Colors.white,
          //),
          title: Text(widget.name,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                letterSpacing: 1,
              )),
          leading: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Theme(
              data: ThemeData(
                unselectedWidgetColor: Colors.white,
              ),
              child: Checkbox(
                onChanged: (bool value) {
                  setState(() {
                    widget.status = value;
                    if (value) {
                      background = MyColors().green;
                      update(widget.id, 1);
                    } else {
                      background = MyColors().blue;
                      update(widget.id, 0);
                    }
                  });
                },
                value: widget.status,
                activeColor: MyColors().green,
                materialTapTargetSize: MaterialTapTargetSize.padded,
              ),
            ),
          ),
        ),
      ),
    );
  }
}