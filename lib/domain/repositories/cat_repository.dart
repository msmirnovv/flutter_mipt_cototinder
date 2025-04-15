import '../../data/services/cat_api_service.dart';
import '../models/cat_model.dart';

class CatRepository {
  final CatApiService apiService;

  CatRepository(this.apiService);

  Future<CatModel> fetchRandomCat() => apiService.fetchRandomCat();
}
