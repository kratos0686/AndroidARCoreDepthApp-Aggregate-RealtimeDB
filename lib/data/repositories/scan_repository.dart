import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';

part 'scan_repository.g.dart';

abstract class ScanRepository {
  Future<List<Scan>> getAllScans();
  Stream<List<Scan>> watchAllScans();
  Future<int> createScan(ScansCompanion scan);
  Future<void> updateScan(Scan scan);
  Future<void> deleteScan(int id);
}

class ScanRepositoryImpl implements ScanRepository {
  final AppDatabase _db;

  ScanRepositoryImpl(this._db);

  @override
  Future<List<Scan>> getAllScans() {
    return _db.select(_db.scans).get();
  }

  @override
  Stream<List<Scan>> watchAllScans() {
    return _db.select(_db.scans).watch();
  }

  @override
  Future<int> createScan(ScansCompanion scan) {
    return _db.into(_db.scans).insert(scan);
  }

  @override
  Future<void> updateScan(Scan scan) {
    return _db.update(_db.scans).replace(scan);
  }

  @override
  Future<void> deleteScan(int id) {
    return (_db.delete(_db.scans)..where((t) => t.id.equals(id))).go();
  }
}

@riverpod
ScanRepository scanRepository(ScanRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return ScanRepositoryImpl(db);
}
