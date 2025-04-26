import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/cat_model.dart';
import '../../data/local/app_database.dart';

class LikedCat {
  final CatModel cat;
  final DateTime likedAt;
  LikedCat({required this.cat, required this.likedAt});
}

class LikedCatsCubit extends Cubit<List<LikedCat>> {
  final AppDatabase db;

  LikedCatsCubit(this.db) : super([]) {
    _load();
  }

  Future<void> _load() async {
    final rows = await db.allCachedCats;
    final liked =
        rows
            .where((row) => row.liked)
            .map(
              (row) => LikedCat(
                cat: CatModel(
                  url: row.url,
                  breed: row.breed,
                  description: row.description,
                  temperament: row.temperament,
                  origin: row.origin,
                ),
                likedAt: row.likedAt!,
              ),
            )
            .toList();
    emit(liked);
  }

  Future<void> likeCat(CatModel cat) async {
    final now = DateTime.now();
    await db.updateLike(cat.url, true, now);
    await _load();
  }

  Future<void> removeCat(LikedCat likedCat) async {
    await db.updateLike(likedCat.cat.url, false, null);
    await _load();
  }
}
