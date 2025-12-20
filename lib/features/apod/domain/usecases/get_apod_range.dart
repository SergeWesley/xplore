import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/apod_entity.dart';
import '../repositories/apod_repository.dart';

class GetApodRange {
  final ApodRepository repository;

  GetApodRange(this.repository);

  Future<Either<Failure, List<ApodEntity>>> call({
    required String startDate,
    required String endDate,
  }) {
    return repository.getApodRange(startDate: startDate, endDate: endDate);
  }
}
