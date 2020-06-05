import 'package:app_agenda/components/date_to_text.dart';
import 'package:app_agenda/models/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const String _tableName = 'tb_tasks';
const String _id = 'id';
const String _name = 'name';
const String _status = 'status';
const String _date = 'date';
const String _seg = 'seg', _ter = 'ter', _qua = 'qua', _qui = 'qui', _sex = 'sex', _sab = 'sab', _dom = 'dom';
const List<String> convertToDay = [_seg, _ter, _qua, _qui, _sex, _sab, _dom];

Future<Database> getDatabase() async {
  const String tableSql =
      'CREATE TABLE `$_tableName`('
      '$_id INTEGER PRIMARY KEY,'
      '$_name TEXT,'
      '$_status INTEGER,'
      '$_date DATE,'
      '$_seg INTEGER NULL,'
      '$_ter INTEGER NULL,'
      '$_qua INTEGER NULL,'
      '$_qui INTEGER NULL,'
      '$_sex INTEGER NULL,'
      '$_sab INTEGER NULL,'
      '$_dom INTEGER NULL)';

  final String path = join(await getDatabasesPath(), _tableName);
  return openDatabase(path, onCreate: (db, version) {
    db.execute(tableSql);
  }, version: 1);
}

Future<int> save(Task task) async {
  final Database db = await getDatabase();
  final Map<String, dynamic> taskMap = Map();

  taskMap[_name] = task.name;
  taskMap[_status] = task.status;
  taskMap[_date] = dateToText(task.date, type: 1);
  for(String dia in convertToDay) taskMap[dia] = 0;
  task.repeat.forEach((key, value) {
    taskMap[convertToDay[key]] = value;
  });
  taskMap.forEach((key, value) {print('$key: $value, ');});
  return db.insert(_tableName , taskMap);
}

Future<int> remove(int id) async {
  final Database db = await getDatabase();
  return db.delete(_tableName, where: '$_id = ?', whereArgs: [id]);
}

Future<int> update(int id, int status) async {
  final Database db = await getDatabase();
  Map<String, dynamic> taskMap = Map();
  taskMap[_status] = status;
  return db.update(_tableName, taskMap, where: '$_id = ?', whereArgs: [id]);
}

Future<List<Task>> listTask(DateTime date) async {
  final Database db = await getDatabase();
  final String weekDay = convertToDay[date.weekday-1];
  final List<Map<String, dynamic>> table = await db.query(_tableName , where: '$_date = ?', whereArgs: [dateToText(date, type: 1)]);
  //final List<Map<String, dynamic>> table = await db.query(_tableName, where: '$weekDay = 1');
  //final List<Map<String, dynamic>> table2 = await db.query(_tableName , where: '$_date = ? and $_seg = 0 and $_ter = 0 and $_qua = 0 and $_qui = 0 and $_sex = 0 and $_sab = 0 and $_dom = 0', whereArgs: [dateToText(date, type: 1)]);
  final List<Task> tasks = List();
  for(Map<String, dynamic> row in table) {
    final Task task = Task(
      row[_id],
      row[_name],
      row[_status],
      DateTime.tryParse(row[_date]),
      Map(),
    );
    tasks.add(task);
  }
  //for(Map<String, dynamic> row in table2) {
  //  print(row[_name]);
  //  final Task task = Task(
  //    row[_id],
  //    row[_name],
  //    row[_status],
  //    DateTime.tryParse(row[_date]),
  //    Map(),
  //  );
  //  tasks.add(task);
  //}
  return tasks;
}