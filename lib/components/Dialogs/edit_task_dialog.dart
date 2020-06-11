import 'package:app_agenda/components/my_colors.dart';
import 'package:app_agenda/database/app_database.dart';
import 'package:flutter/material.dart';

class EditTaskDialog extends StatefulWidget {
  final String name;
  final int id;
  final DateTime date;
  final int status;

  EditTaskDialog(this.name, this.id, this.date, this.status);

  @override
  _EditTaskDialogState createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: widget.date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != widget.date) {
      setState(() {
        update(widget.id, widget.status, date: picked);
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 80.0),
        child: AlertDialog(
          title: Text(widget.name),
          content: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  child: Text('Mudar data'),
                  onPressed: () => _selectDate(context),
                  color: MyColors().blue,
                ),
                FlatButton(
                  onPressed: () {
                    remove(widget.id);
                    Navigator.pop(context);
                  },
                  child: Text('Remover'),
                  color: Colors.red[800],
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Concluir',
                style: TextStyle(
                  color: MyColors().green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
