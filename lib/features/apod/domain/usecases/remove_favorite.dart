import '../repositories/favorites_repository.dart';

class RemoveFavorite {
  final FavoritesRepository repository;

  RemoveFavorite(this.repository);

  Future<void> call(String date) {
    return repository.removeFavorite(date);
  }
}
