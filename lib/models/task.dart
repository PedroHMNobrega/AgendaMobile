class Task {
  final int id;
  final String name;
  final int status;
  final DateTime date;
  final Map<int, int> repeat;

  Task(this.id, this.name, this.status, this.date, this.repeat);
}