import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
part 'app_database.g.dart';

class Cats extends Table {
  TextColumn get url => text()();
  TextColumn get breed => text()();
  TextColumn get description => text()();
  TextColumn get temperament => text()();
  TextColumn get origin => text()();
  BoolColumn get liked => boolean().withDefault(const Constant(false))();
  DateTimeColumn get likedAt => dateTime().nullable()();
  @override
  Set<Column>? get primaryKey => {url};
}

@DriftDatabase(tables: [Cats])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 1;

  Future<List<Cat>> get allCachedCats => select(cats).get();
  Future insertCat(CatsCompanion entry) =>
      into(cats).insertOnConflictUpdate(entry);
  Future updateLike(String url, bool isLiked, DateTime? at) => (update(cats)
    ..where(
      (t) => t.url.equals(url),
    )).write(CatsCompanion(liked: Value(isLiked), likedAt: Value(at)));
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'cats.sqlite'));
    return NativeDatabase(file);
  });
}
