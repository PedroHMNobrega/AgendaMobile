import 'package:app_agenda/components/date_to_text.dart';
import 'package:app_agenda/database/app_database.dart';
import 'package:app_agenda/models/task.dart';
import 'package:flutter/material.dart';

class AddTaskDialog extends StatelessWidget {
  final DateTime date;
  final TextEditingController taskController = TextEditingController();
  
  AddTaskDialog(this.date);
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: Text(
          'Adicionar Tarefa ' + dateToText(date),
          textAlign: TextAlign.center,
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: TextField(
            controller: taskController,
            decoration: InputDecoration(
              labelText: 'Digite a Tarefa',
              border: OutlineInputBorder(),
            ),
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
            textColor: Colors.indigo,
          ),
          FlatButton(
            onPressed: () {
              final String taskName = taskController.text;
              if(taskName != '') {
                final Task newContact = Task(0, taskName, 0, date);
                save(newContact);
                Navigator.pop(context);
              }
            },
            child: Text('Adicionar'),
            textColor: Colors.green[600],
          ),
        ],
      ),
    );
  }
}
