import 'package:app_agenda/components/Dialogs/add_general_task_dialog.dart';
import 'package:app_agenda/components/Dialogs/add_task_dialog.dart';
import 'package:app_agenda/components/my_colors.dart';
import 'package:app_agenda/components/progress.dart';
import 'package:app_agenda/components/render_list.dart';
import 'package:app_agenda/database/app_database.dart';
import 'package:app_agenda/models/task.dart';
import 'package:flutter/material.dart';

class GeneralTasks extends StatefulWidget {

  @override
  _GeneralTasksState createState() => _GeneralTasksState();
}

class _GeneralTasksState extends State<GeneralTasks> {
  final DateTime defaultTime = DateTime.parse('1999-01-01');

  void refreshTasks() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///AppBar
      appBar: AppBar(
        title: Text('TodoList'),
      ),
      body: Column(children: <Widget>[
        ///Titulo
        Padding(
          padding:
          const EdgeInsets.only(top: 32, bottom: 26, right: 2, left: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Tarefas Gerais",
                style: TextStyle(
                  fontSize: 24,
                  color: MyColors().fontColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        ///Lista de Tarefas
        FutureBuilder<List<Task>>(
            future: listTask(defaultTime),
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
      ///Adicionar Tarefa Botao
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (contextDialog) => AddGeneralTaskDialog(defaultTime, 'Adicionar Tarefa Geral'),
          ).then((value) => setState(() {}));
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

