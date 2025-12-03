import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database.g.dart';

// --- Tables ---

class Scans extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get roomName => text()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get length => real().nullable()();
  RealColumn get width => real().nullable()();
  RealColumn get height => real().nullable()();
  RealColumn get area => real().nullable()();
  RealColumn get volume => real().nullable()();
  TextColumn get pointCloudPath => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  TextColumn get firebaseId => text().nullable()();
}

class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get scanId => integer().references(Scans, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  TextColumn get content => text()();
  TextColumn get category => text()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get positionX => real().nullable()();
  RealColumn get positionY => real().nullable()();
  RealColumn get positionZ => real().nullable()();
}

// --- Database Class ---

@DriftDatabase(tables: [Scans, Notes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'room_scanner.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

// --- Providers ---

@riverpod
AppDatabase appDatabase(AppDatabaseRef ref) {
  // Keep the database alive
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}
