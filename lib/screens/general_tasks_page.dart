import 'package:app_agenda/components/my_colors.dart';
import 'package:app_agenda/components/render_list.dart';
import 'package:app_agenda/database/app_database.dart';
import 'package:app_agenda/models/task.dart';
import 'package:flutter/material.dart';

class GeneralTasksPage extends StatefulWidget {
  
  @override
  _GeneralTasksPageState createState() => _GeneralTasksPageState();
}

class _GeneralTasksPageState extends State<GeneralTasksPage> {
  final DateTime currentDay = DateTime.parse('1999-01-01');

  void refreshTasks() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 32, bottom: 26),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Tarefas Gerais',
                style: TextStyle(
                  fontSize: 24,
                  color: MyColors().fontColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
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
                return Text('');
                break;
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                return RenderList(snapshot.data, refreshTasks);
                break;
            }
            return Text('Unknown error');
          }),
      ],
    );
  }
}

