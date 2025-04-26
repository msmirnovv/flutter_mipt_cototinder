import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import '../services/cat_api_service.dart';
import '../local/app_database.dart';
import '../../domain/models/cat_model.dart';
import '../../domain/repositories/cat_repository.dart';

class CatRepositoryImpl implements CatRepository {
  final CatApiService api;
  final AppDatabase db;
  final Connectivity connectivity;

  CatRepositoryImpl(this.api, this.db, this.connectivity);

  @override
  Future<CatModel> fetchRandomCat() async {
    final status = await connectivity.checkConnectivity();
    if (!status.contains(ConnectivityResult.none)) {
      final cat = await api.fetchRandomCat();
      await db.insertCat(
        CatsCompanion(
          url: Value(cat.url),
          breed: Value(cat.breed),
          description: Value(cat.description),
          temperament: Value(cat.temperament),
          origin: Value(cat.origin),
        ),
      );
      return cat;
    } else {
      final cached = await db.allCachedCats;
      if (cached.isEmpty) throw Exception('Нет сохранённых котиков');
      cached.shuffle();
      final row = cached.first;
      return CatModel(
        url: row.url,
        breed: row.breed,
        description: row.description,
        temperament: row.temperament,
        origin: row.origin,
      );
    }
  }
}
