import 'package:drift/drift.dart';

class NotesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  DateTimeColumn get creationDate => dateTime()();
}
