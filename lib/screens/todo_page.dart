import 'package:app_agenda/components/date_to_text.dart';
import 'package:app_agenda/components/my_colors.dart';
import 'package:app_agenda/components/render_list.dart';
import 'package:app_agenda/database/app_database.dart';
import 'package:app_agenda/models/task.dart';
import 'package:flutter/material.dart';

class TodoPage extends StatelessWidget {
  final DateTime currentDay;
  final Function changeDay;
  final Function refreshPage;
  TodoPage(this.currentDay, this.changeDay, this.refreshPage);

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

  @override
  Widget build(BuildContext context) {
    ///Definindo data atual
    String today;
    if(DateTime.now().year == currentDay.year && DateTime.now().month == currentDay.month && DateTime.now().day == currentDay.day)
      today = 'Hoje';
    else
      today = weekDays[currentDay.weekday - 1];
    String dateText = today + ' ' + dateToText(currentDay);

    return Column(children: <Widget>[
      Padding(
        padding:
        const EdgeInsets.only(top: 32, bottom: 26, right: 2, left: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ///Voltar um dia
            GestureDetector(
              onTap: () {
                changeDay(add: -1);
              },
              child: Icon(
                Icons.chevron_left,
                size: 40,
                color: MyColors().fontColor,
              ),
            ),
            ///Dia Atual
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
            ///Adiantar um dia
            GestureDetector(
              onTap: () {
                changeDay(add: 1);
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
              return Text('');
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              return RenderList(snapshot.data, refreshPage, showEditDialog: true);
              break;
          }
          return Text('Unknown error');
        }),
    ]);
  }
}
