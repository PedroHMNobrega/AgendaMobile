import 'package:app_agenda/components/Dialogs/add_general_task_dialog.dart';
import 'package:app_agenda/components/date_to_text.dart';
import 'package:app_agenda/components/my_colors.dart';
import 'package:app_agenda/screens/bills_page.dart';
import 'package:app_agenda/screens/general_tasks_page.dart';
import 'package:app_agenda/screens/todo_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  static DateTime currentDay = DateTime.now();

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DateTime currentDay = MainPage.currentDay;
  int _currentIndex = 0;
  bool _calendarVisibility = false;
  String _addMessage;

  ///Mudar de dia
  void changeDay({@required int add}) {
    setState(() {
      currentDay =
          DateTime(currentDay.year, currentDay.month, currentDay.day + add);
    });
  }

  void refreshPage() {
    setState(() {});
  }

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

  @override
  Widget build(BuildContext context) {
    if (_currentIndex == 0) {
      _calendarVisibility = true;
      _addMessage = 'Adicionar Tarefa ' + dateToText(currentDay);
    } else if (_currentIndex == 1) {
      _calendarVisibility = false;
      _addMessage = 'Adicionar Tarefa Geral';
    } else if (_currentIndex == 2) {
      _calendarVisibility = false;
      _addMessage = 'Adicionar Conta';
    }

    return Scaffold(
      ///AppBar
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'TodoList',
            ),

            ///Calendario
            Visibility(
              visible: _calendarVisibility,
              child: GestureDetector(
                onTap: () => _selectDate(context),
                child: Icon(
                  Icons.date_range,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
      body: RenderPage(_currentIndex, currentDay, changeDay, refreshPage),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: MyColors().blue,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.date_range), title: Text('TodoList')),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), title: Text('Gerais')),
          BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on), title: Text('Contas')),
        ],
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),

      ///Botao Para Adicionar Tarefa
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (contextDialog) {
                if (_currentIndex == 0)
                  return AddGeneralTaskDialog(currentDay, _addMessage);
                else if (_currentIndex == 1)
                  return AddGeneralTaskDialog(
                      DateTime.parse('1999-01-01'), _addMessage);
                else
                  return AddGeneralTaskDialog(
                      DateTime.parse('1998-' +
                          DateTime.now().month.toString().padLeft(2, '0') +
                          '-01'),
                      _addMessage,
                      textLabel: 'Digite a Conta');
              }).then((value) => setState(() {}));
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

class RenderPage extends StatelessWidget {
  final int idx;
  final DateTime currentDay;
  final Function changeDay;
  final Function refreshPage;

  RenderPage(this.idx, this.currentDay, this.changeDay, this.refreshPage);

  @override
  Widget build(BuildContext context) {
    print(currentDay);
    if (idx == 0)
      return TodoPage(currentDay, changeDay, refreshPage);
    else if (idx == 1)
      return GeneralTasksPage();
    else
      return BillsPage();
  }
}
