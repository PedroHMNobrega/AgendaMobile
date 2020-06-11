import 'package:app_agenda/components/my_colors.dart';
import 'package:app_agenda/database/app_database.dart';
import 'package:app_agenda/models/task.dart';
import 'package:flutter/material.dart';

class AddTaskDialog extends StatelessWidget {
  final DateTime date;
  final String label;
  final TextEditingController taskController = TextEditingController();
  Map<int, int> repeat = Map();
  
  AddTaskDialog(this.date, this.label);
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: AlertDialog(
          title: Text(
            label,
            textAlign: TextAlign.center,
          ),
          content: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 22),
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
              Text(
                'Repetir',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RepeatLetter('S', 0, repeat),
                    RepeatLetter('T', 1, repeat),
                    RepeatLetter('Q', 2, repeat),
                    RepeatLetter('Q', 3, repeat),
                    RepeatLetter('S', 4, repeat),
                    RepeatLetter('S', 5, repeat),
                    RepeatLetter('D', 6, repeat),
                  ],
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
                  final Task newContact = Task(0, taskName, 0, date, repeat);
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

class RepeatLetter extends StatefulWidget {
  final String label;
  final int value;
  Map<int, int> repeat;
  RepeatLetter(this.label, this.value, this.repeat);

  @override
  _RepeatLetterState createState() => _RepeatLetterState();
}

class _RepeatLetterState extends State<RepeatLetter> {
  bool active = false;
  Color color;

  @override
  Widget build(BuildContext context) {
    if(active) color = MyColors().green;
    else color = MyColors().fontColor;
    return GestureDetector(
      child: Text(
        widget.label,
        style: TextStyle(
          color: color,
          fontSize: 26
        ),
      ),
      onTap: () {
        setState(() {
          if(active) {
            active = false;
            widget.repeat[widget.value] = 0;
          } else {
            active = true;
            widget.repeat[widget.value] = 1;
          }
        });
      },
    );
  }
}

