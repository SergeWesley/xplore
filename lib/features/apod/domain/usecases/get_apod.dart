import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/apod_entity.dart';
import '../repositories/apod_repository.dart';

class GetApod {
  final ApodRepository repository;

  GetApod(this.repository);

  Future<Either<Failure, ApodEntity>> call({String? date}) {
    return repository.getApod(date: date);
  }
}
