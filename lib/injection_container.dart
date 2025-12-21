import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

import 'core/network/dio_client.dart';

import 'features/apod/data/datasources/apod_remote_datasource.dart';
import 'features/apod/data/datasources/favorites_local_datasource.dart';
import 'features/apod/data/repositories/apod_repository_impl.dart';
import 'features/apod/data/repositories/favorites_repository_impl.dart';
import 'features/apod/domain/repositories/apod_repository.dart';
import 'features/apod/domain/repositories/favorites_repository.dart';
import 'features/apod/domain/usecases/add_favorite.dart';
import 'features/apod/domain/usecases/get_apod.dart';
import 'features/apod/domain/usecases/get_apod_range.dart';
import 'features/apod/domain/usecases/get_favorites.dart';
import 'features/apod/domain/usecases/is_favorite.dart';
import 'features/apod/domain/usecases/remove_favorite.dart';
import 'features/apod/presentation/cubit/apod_cubit.dart';
import 'features/apod/presentation/cubit/favorites_cubit.dart';

final getIt = GetIt.instance;

Future<void> initDependencies(Isar isar) async {
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  getIt.registerLazySingleton<ApodRemoteDataSource>(
    () => ApodRemoteDataSourceImpl(dioClient: getIt()),
  );

  getIt.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(isar: isar),
  );

  getIt.registerLazySingleton<ApodRepository>(
    () => ApodRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(localDataSource: getIt()),
  );

  getIt.registerLazySingleton(() => GetApod(getIt()));
  getIt.registerLazySingleton(() => GetApodRange(getIt()));
  getIt.registerLazySingleton(() => AddFavorite(getIt()));
  getIt.registerLazySingleton(() => RemoveFavorite(getIt()));
  getIt.registerLazySingleton(() => GetFavorites(getIt()));
  getIt.registerLazySingleton(() => IsFavorite(getIt()));

  getIt.registerFactory(
    () => ApodCubit(getApod: getIt(), getApodRange: getIt()),
  );

  getIt.registerLazySingleton(
    () => FavoritesCubit(
      addFavorite: getIt(),
      removeFavorite: getIt(),
      getFavorites: getIt(),
      isFavorite: getIt(),
    ),
  );
}
