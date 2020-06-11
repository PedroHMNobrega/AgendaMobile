import 'package:app_agenda/database/app_database.dart';
import 'package:app_agenda/models/task.dart';
import 'package:flutter/material.dart';

class AddGeneralTaskDialog extends StatelessWidget {
  final DateTime date;
  final String label;
  final String textLabel;
  final TextEditingController taskController = TextEditingController();

  AddGeneralTaskDialog(this.date, this.label, {this.textLabel = 'Digite a Tarefa'});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: AlertDialog(
          title: Text(
            label,
            textAlign: TextAlign.center,
          ),
          content: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                  controller: taskController,
                  decoration: InputDecoration(
                    labelText: textLabel,
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ],
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
                  final Task newContact = Task(0, taskName, 0, date, Map());
                  save(newContact);
                  Navigator.pop(context);
                }
              },
              child: Text('Adicionar'),
              textColor: Colors.green[600],
            ),
          ],
        ),
      ),
    );
  }
}

