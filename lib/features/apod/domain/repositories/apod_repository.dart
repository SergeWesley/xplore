import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/apod_entity.dart';

abstract class ApodRepository {
  Future<Either<Failure, ApodEntity>> getApod({String? date});
  Future<Either<Failure, List<ApodEntity>>> getApodRange({
    required String startDate,
    required String endDate,
  });
}
