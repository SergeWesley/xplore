import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/neo_entity.dart';

/// Repository abstrait pour les Near Earth Objects
abstract class NeoRepository {
  /// Récupère les NEOs pour une plage de dates
  ///
  /// [startDate] - Date de début au format YYYY-MM-DD
  /// [endDate] - Date de fin au format YYYY-MM-DD (max 7 jours après startDate)
  ///
  /// Retourne un [Either] avec un [Failure] en cas d'erreur
  /// ou un [NeoFeedEntity] contenant les données
  Future<Either<Failure, NeoFeedEntity>> getNeoFeed({
    required String startDate,
    required String endDate,
  });
}
