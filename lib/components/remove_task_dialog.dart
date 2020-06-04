import 'package:app_agenda/database/app_database.dart';
import 'package:flutter/material.dart';

class RemoveTaskDialog extends StatelessWidget {
  final String name;
  final int id;
  RemoveTaskDialog(this.name, this.id);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: Text('Remover Tarefa'),
        content: Text('Tem certeza que quer remover "'+name+'"?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          FlatButton(
            onPressed: () {
              remove(id);
              Navigator.pop(context);
            },
            child: Text('Remover'),
          )
        ],
      ),
    );
  }
}
