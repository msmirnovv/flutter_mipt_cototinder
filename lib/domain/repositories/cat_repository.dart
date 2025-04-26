import '../models/cat_model.dart';

abstract class CatRepository {
  Future<CatModel> fetchRandomCat();
}
