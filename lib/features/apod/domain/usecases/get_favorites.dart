import '../entities/apod_entity.dart';
import '../repositories/favorites_repository.dart';

class GetFavorites {
  final FavoritesRepository repository;

  GetFavorites(this.repository);

  Future<List<ApodEntity>> call() {
    return repository.getFavorites();
  }
}
