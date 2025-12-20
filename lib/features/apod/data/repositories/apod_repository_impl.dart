import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/apod_entity.dart';
import '../../domain/repositories/apod_repository.dart';
import '../datasources/apod_remote_datasource.dart';

/// Implémentation du repository APOD
///
/// Cette classe fait le pont entre la couche domain et la couche data.
/// Elle gère la conversion des exceptions en failures pour respecter
/// le pattern Either de la clean architecture.
class ApodRepositoryImpl implements ApodRepository {
  final ApodRemoteDataSource remoteDataSource;

  ApodRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ApodEntity>> getApod({String? date}) async {
    try {
      final apodModel = await remoteDataSource.getApod(date: date);
      return Right(apodModel);
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

  @override
  Future<Either<Failure, List<ApodEntity>>> getApodRange({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final apodModels = await remoteDataSource.getApodRange(
        startDate: startDate,
        endDate: endDate,
      );
      return Right(apodModels);
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
