import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../data/services/cat_api_service.dart';
import '../data/local/app_database.dart';
import '../data/repositories/cat_repository_impl.dart';
import '../domain/repositories/cat_repository.dart';
import '../presentation/cubits/cat_cubit.dart';
import '../presentation/cubits/connectivity_cubit.dart';
import '../presentation/cubits/liked_cats_cubit.dart';

final sl = GetIt.instance;

void setupLocator() {
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => AppDatabase());
  sl.registerLazySingleton(() => CatApiService());
  sl.registerLazySingleton<CatRepository>(
    () => CatRepositoryImpl(sl(), sl(), sl()),
  );
  sl.registerFactory(() => CatCubit(sl()));
  sl.registerFactory(() => ConnectivityCubit(sl()));
  sl.registerFactory(() => LikedCatsCubit(sl()));
}
