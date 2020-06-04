import 'package:app_agenda/components/add_task_dialog.dart';
import 'package:app_agenda/components/date_to_text.dart';
import 'package:app_agenda/components/progress.dart';
import 'package:app_agenda/components/remove_task_dialog.dart';
import 'package:app_agenda/database/app_database.dart';
import 'package:app_agenda/models/task.dart';
import 'package:flutter/material.dart';

class TasksPage extends StatefulWidget {
  static DateTime currentDay = DateTime.now();

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final Color fontColor = Color.fromRGBO(68, 68, 68, 1);

  ///Lista de Tarefas;
  DateTime currentDay = TasksPage.currentDay;

  ///Dias da Semana:
  final List<String> weekDays = [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sábado',
    'Domingo'
  ];

  ///Mudar a data de acordo com a escolha do usuario;
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: currentDay,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != currentDay) {
      setState(() {
        currentDay = picked;
      });
    }
  }

  void changeState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String dateText =
        weekDays[currentDay.weekday - 1] + ' ' + dateToText(currentDay);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'TodoList',
            ),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Icon(
                Icons.date_range,
                size: 30,
              ),
            ),
          ],
        ),
      ),
      body: Column(children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(top: 32, bottom: 26, right: 2, left: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentDay = DateTime(
                        currentDay.year, currentDay.month, currentDay.day - 1);
                  });
                },
                child: Icon(
                  Icons.chevron_left,
                  size: 40,
                  color: fontColor,
                ),
              ),
              Row(
                children: <Widget>[
                  //Icon(
                  //  Icons.check_circle,
                  //  size: 18,
                  //  color: Color.fromRGBO(68, 68, 68, 1),
                  //),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      dateText,
                      style: TextStyle(
                        fontSize: 24,
                        color: fontColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentDay = DateTime(
                        currentDay.year, currentDay.month, currentDay.day + 1);
                  });
                },
                child: Icon(
                  Icons.chevron_right,
                  size: 40,
                  color: fontColor,
                ),
              )
            ],
          ),
        ),
        FutureBuilder<List<Task>>(
            future: listTask(currentDay),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  break;
                case ConnectionState.waiting:
                  return Progress();
                  break;
                case ConnectionState.active:
                  break;
                case ConnectionState.done:
                  final List<Task> tasks = snapshot.data;
                  if (tasks.length == 0) {
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 38.0, bottom: 8),
                          child: Icon(
                            Icons.calendar_today,
                            size: 60,
                            color: fontColor,
                          ),
                        ),
                        Text('Nenhuma Tarefa',
                            style: TextStyle(
                              fontSize: 30,
                              color: fontColor,
                            )),
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
                          return taskCard(
                              task.name, status, task.id, changeState);
                        },
                      ),
                    ),
                  );
                  break;
              }
              return Text('Unknown error');
            }),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (contextDialog) => AddTaskDialog(currentDay),
          ).then((value) => setState(() {}));
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

class taskCard extends StatefulWidget {
  final String name;
  final int id;
  Function changeState;
  bool status;

  taskCard(this.name, this.status, this.id, this.changeState);

  @override
  _taskCardState createState() => _taskCardState();
}

class _taskCardState extends State<taskCard> {
  static Color green = Colors.green[600];
  static Color blue = Colors.blue[900];
  Color background;

  @override
  Widget build(BuildContext context) {
    if (widget.status)
      background = green;
    else
      background = blue;

    return GestureDetector(
      onDoubleTap: () {
        showDialog(
          context: context,
          builder: (contextDialog) => RemoveTaskDialog(widget.name, widget.id),
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
                      background = green;
                      update(widget.id, 1);
                    } else {
                      background = blue;
                      update(widget.id, 0);
                    }
                  });
                },
                value: widget.status,
                activeColor: green,
                materialTapTargetSize: MaterialTapTargetSize.padded,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
