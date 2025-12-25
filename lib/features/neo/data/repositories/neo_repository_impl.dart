import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/neo_entity.dart';
import '../../domain/repositories/neo_repository.dart';
import '../datasources/neo_remote_datasource.dart';

/// Implémentation du repository NEO
///
/// Cette classe fait le pont entre la couche domain et la couche data.
/// Elle gère la conversion des exceptions en failures pour respecter
/// le pattern Either de la clean architecture.
class NeoRepositoryImpl implements NeoRepository {
  final NeoRemoteDataSource remoteDataSource;

  NeoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, NeoFeedEntity>> getNeoFeed({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final neoFeedModel = await remoteDataSource.getNeoFeed(
        startDate: startDate,
        endDate: endDate,
      );
      return Right(neoFeedModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: $e'));
    }
  }
}
