import 'package:get_it/get_it.dart';

import 'core/network/dio_client.dart';

import 'features/apod/data/datasources/apod_remote_datasource.dart';
import 'features/apod/data/repositories/apod_repository_impl.dart';
import 'features/apod/domain/repositories/apod_repository.dart';
import 'features/apod/domain/usecases/get_apod.dart';
import 'features/apod/domain/usecases/get_apod_range.dart';
import 'features/apod/presentation/cubit/apod_cubit.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  getIt.registerLazySingleton<ApodRemoteDataSource>(
    () => ApodRemoteDataSourceImpl(dioClient: getIt()),
  );

  getIt.registerLazySingleton<ApodRepository>(
    () => ApodRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton(() => GetApod(getIt()));
  getIt.registerLazySingleton(() => GetApodRange(getIt()));

  getIt.registerFactory(
    () => ApodCubit(getApod: getIt(), getApodRange: getIt()),
  );
}
