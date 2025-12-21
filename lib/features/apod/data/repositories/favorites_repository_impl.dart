import '../../domain/entities/apod_entity.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_datasource.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;

  FavoritesRepositoryImpl({required this.localDataSource});

  @override
  Future<List<ApodEntity>> getFavorites() async {
    return await localDataSource.getFavorites();
  }

  @override
  Future<void> addFavorite(ApodEntity apod) async {
    await localDataSource.addFavorite(apod);
  }

  @override
  Future<void> removeFavorite(String date) async {
    await localDataSource.removeFavorite(date);
  }

  @override
  Future<bool> isFavorite(String date) async {
    return await localDataSource.isFavorite(date);
  }
}
