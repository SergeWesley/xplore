import '../entities/apod_entity.dart';

abstract class FavoritesRepository {
  Future<List<ApodEntity>> getFavorites();
  Future<void> addFavorite(ApodEntity apod);
  Future<void> removeFavorite(String date);
  Future<bool> isFavorite(String date);
}
