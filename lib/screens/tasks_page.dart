import 'package:app_agenda/components/Dialogs/add_general_task_dialog.dart';
import 'package:app_agenda/components/Dialogs/add_task_dialog.dart';
import 'package:app_agenda/components/date_to_text.dart';
import 'package:app_agenda/components/my_colors.dart';
import 'package:app_agenda/components/progress.dart';
import 'package:app_agenda/components/render_list.dart';
import 'package:app_agenda/database/app_database.dart';
import 'package:app_agenda/models/task.dart';
import 'package:app_agenda/screens/general_tasks_page.dart';
import 'package:flutter/material.dart';

class TasksPage extends StatefulWidget {
  static DateTime currentDay = DateTime.now();

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
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

  ///Select Date Dialog;
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

  void refreshTasks() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String today;
    if(DateTime.now().year == currentDay.year && DateTime.now().month == currentDay.month && DateTime.now().day == currentDay.day)
      today = 'Hoje';
    else
      today = weekDays[currentDay.weekday - 1];

    String dateText = today + ' ' + dateToText(currentDay);
    return Scaffold(
      ///AppBar
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'TodoList',
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Icon(
                    Icons.date_range,
                    size: 30,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GeneralTasks(),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 28.0),
                    child: Icon(
                      Icons.arrow_forward,
                      size: 24,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      body: Column(children: <Widget>[
        ///Titulo Dia Atual
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
                  color: MyColors().fontColor,
                ),
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      dateText,
                      style: TextStyle(
                        fontSize: 24,
                        color: MyColors().fontColor,
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
                  color: MyColors().fontColor,
                ),
              )
            ],
          ),
        ),
        ///Lista de Tarefas
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
                  return RenderList(snapshot.data, refreshTasks);
                  break;
              }
              return Text('Unknown error');
            }),
      ]),
      ///Botao Para Adicionar Tarefa
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (contextDialog) => AddGeneralTaskDialog(currentDay, 'Adicionar Tarefa ' + dateToText(currentDay)),
          ).then((value) => setState(() {}));
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
