import '../entities/apod_entity.dart';
import '../repositories/favorites_repository.dart';

class AddFavorite {
  final FavoritesRepository repository;

  AddFavorite(this.repository);

  Future<void> call(ApodEntity apod) {
    return repository.addFavorite(apod);
  }
}
