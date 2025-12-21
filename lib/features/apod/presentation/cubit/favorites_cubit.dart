import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/apod_entity.dart';
import '../../domain/usecases/add_favorite.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/is_favorite.dart';
import '../../domain/usecases/remove_favorite.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final AddFavorite addFavorite;
  final RemoveFavorite removeFavorite;
  final GetFavorites getFavorites;
  final IsFavorite isFavorite;

  final Set<String> _favoriteDates = {};

  FavoritesCubit({
    required this.addFavorite,
    required this.removeFavorite,
    required this.getFavorites,
    required this.isFavorite,
  }) : super(const FavoritesInitial());

  Future<void> loadFavorites() async {
    emit(const FavoritesLoading());
    try {
      final favorites = await getFavorites();
      _favoriteDates.clear();
      _favoriteDates.addAll(favorites.map((f) => f.date));
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> toggleFavorite(ApodEntity apod) async {
    try {
      if (_favoriteDates.contains(apod.date)) {
        await removeFavorite(apod.date);
        _favoriteDates.remove(apod.date);
      } else {
        await addFavorite(apod);
        _favoriteDates.add(apod.date);
      }
      final favorites = await getFavorites();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  bool isFavoriteSync(String date) {
    return _favoriteDates.contains(date);
  }

  Future<void> checkIfFavorite(String date) async {
    final result = await isFavorite(date);
    if (result && !_favoriteDates.contains(date)) {
      _favoriteDates.add(date);
    } else if (!result && _favoriteDates.contains(date)) {
      _favoriteDates.remove(date);
    }
  }
}
