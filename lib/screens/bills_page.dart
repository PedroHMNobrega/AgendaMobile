import 'package:app_agenda/components/my_colors.dart';
import 'package:app_agenda/components/render_list.dart';
import 'package:app_agenda/database/app_database.dart';
import 'package:app_agenda/models/task.dart';
import 'package:flutter/material.dart';

class BillsPage extends StatefulWidget {

  @override
  _BillsPageState createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  final DateTime defaultTime = DateTime.parse('1998-'+ DateTime.now().month.toString().padLeft(2, '0') +'-01');

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
                'Contas',
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
          future: listBills(defaultTime),
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
                return RenderList(snapshot.data, refreshTasks, emptyMessage: 'Nenhuma Conta',);
                break;
            }
            return Text('Unknown error');
          }),
      ],
    );
  }
}

