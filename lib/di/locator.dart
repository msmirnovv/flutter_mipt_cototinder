import 'package:get_it/get_it.dart';
import '../data/services/cat_api_service.dart';
import '../domain/repositories/cat_repository.dart';
import '../presentation/cubits/cat_cubit.dart';
import '../presentation/cubits/liked_cats_cubit.dart';

final sl = GetIt.instance;

void setupLocator() {
  sl.registerLazySingleton(() => CatApiService());
  sl.registerLazySingleton(() => CatRepository(sl()));
  sl.registerFactory(() => CatCubit(sl()));
  sl.registerSingleton<LikedCatsCubit>(LikedCatsCubit());
}
