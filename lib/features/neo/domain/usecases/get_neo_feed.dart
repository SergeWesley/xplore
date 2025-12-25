import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/neo_entity.dart';
import '../repositories/neo_repository.dart';

/// Use case pour récupérer le feed des Near Earth Objects
class GetNeoFeed {
  final NeoRepository repository;

  GetNeoFeed(this.repository);

  /// Récupère les NEOs pour une plage de dates
  ///
  /// [startDate] - Date de début au format YYYY-MM-DD
  /// [endDate] - Date de fin au format YYYY-MM-DD
  Future<Either<Failure, NeoFeedEntity>> call({
    required String startDate,
    required String endDate,
  }) {
    return repository.getNeoFeed(startDate: startDate, endDate: endDate);
  }
}
