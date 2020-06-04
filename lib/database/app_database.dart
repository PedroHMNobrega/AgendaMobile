import 'package:app_agenda/components/date_to_text.dart';
import 'package:app_agenda/models/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const String _tableName = 'tb_tasks';

Future<Database> getDatabase() async {
  const String tableSql =
      'CREATE TABLE `$_tableName`('
      'id INTEGER PRIMARY KEY,'
      'name TEXT,'
      'status INTEGER,'
      'date DATE)';

  final String path = join(await getDatabasesPath(), _tableName);
  return openDatabase(path, onCreate: (db, version) {
    db.execute(tableSql);
  }, version: 1);
}

Future<int> save(Task task) async {
  final Database db = await getDatabase();
  final Map<String, dynamic> taskMap = Map();
  taskMap['name'] = task.name;
  taskMap['status'] = task.status;
  taskMap['date'] = dateToText(task.date, type: 1);
  return db.insert(_tableName , taskMap);
}

Future<List<Task>> listTask(DateTime date) async {
  final Database db = await getDatabase();
  final List<Map<String, dynamic>> table = await db.query(_tableName , where: 'date = ?', whereArgs: [dateToText(date, type: 1)]);
  final List<Task> tasks = List();
  for(Map<String, dynamic> row in table) {
    final Task task = Task(
      row['id'],
      row['name'],
      row['status'],
      DateTime.tryParse(row['date'])
    );
    tasks.add(task);
  }
  return tasks;
}

Future<int> remove(int id) async {
  final Database db = await getDatabase();
  return db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
}

Future<int> update(int id, int status) async {
  final Database db = await getDatabase();
  Map<String, dynamic> taskMap = Map();
  taskMap['status'] = status;
  return db.update(_tableName, taskMap, where: 'id = ?', whereArgs: [id]);
}