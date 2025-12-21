import 'package:isar/isar.dart';
import '../../domain/entities/apod_entity.dart';

abstract class FavoritesLocalDataSource {
  Future<List<ApodEntity>> getFavorites();
  Future<void> addFavorite(ApodEntity apod);
  Future<void> removeFavorite(String date);
  Future<bool> isFavorite(String date);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final Isar isar;

  FavoritesLocalDataSourceImpl({required this.isar});

  @override
  Future<List<ApodEntity>> getFavorites() async {
    return await isar.apodEntitys.where().findAll();
  }

  @override
  Future<void> addFavorite(ApodEntity apod) async {
    await isar.writeTxn(() async {
      await isar.apodEntitys.put(apod);
    });
  }

  @override
  Future<void> removeFavorite(String date) async {
    await isar.writeTxn(() async {
      await isar.apodEntitys.deleteByDate(date);
    });
  }

  @override
  Future<bool> isFavorite(String date) async {
    final apod = await isar.apodEntitys.where().dateEqualTo(date).findFirst();
    return apod != null;
  }
}
