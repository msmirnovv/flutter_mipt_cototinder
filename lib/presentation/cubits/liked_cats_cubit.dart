import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/cat_model.dart';

class LikedCat {
  final CatModel cat;
  final DateTime likedAt;

  LikedCat({required this.cat, required this.likedAt});
}

class LikedCatsCubit extends Cubit<List<LikedCat>> {
  LikedCatsCubit() : super([]);

  void likeCat(CatModel cat) {
    emit([...state, LikedCat(cat: cat, likedAt: DateTime.now())]);
  }

  void removeCat(LikedCat likedCat) {
    emit(state.where((c) => c != likedCat).toList());
  }

  void filterByBreed(String? breed) {
    if (breed == null || breed.isEmpty) return;
    emit(state.where((c) => c.cat.breed == breed).toList());
  }
}
