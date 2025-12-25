import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/neo_model.dart';

/// Interface abstraite pour le remote datasource NEO
abstract class NeoRemoteDataSource {
  /// Récupère le feed des Near Earth Objects pour une plage de dates
  ///
  /// [startDate] - Date de début au format YYYY-MM-DD
  /// [endDate] - Date de fin au format YYYY-MM-DD (max 7 jours après startDate)
  ///
  /// Throws [ServerException] en cas d'erreur serveur
  /// Throws [NetworkException] en cas de problème réseau
  Future<NeoFeedModel> getNeoFeed({
    required String startDate,
    required String endDate,
  });
}

/// Implémentation du remote datasource pour l'API NEO de la NASA
class NeoRemoteDataSourceImpl implements NeoRemoteDataSource {
  final DioClient dioClient;

  NeoRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<NeoFeedModel> getNeoFeed({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await dioClient.dio.get(
        ApiConstants.neoEndpoint,
        queryParameters: {'start_date': startDate, 'end_date': endDate},
      );

      if (response.statusCode == 200) {
        return NeoFeedModel.fromJson(response.data);
      } else {
        throw ServerException('Erreur serveur: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  /// Gère les exceptions Dio et les convertit en exceptions métier
  Never _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        throw NetworkException('Impossible de se connecter au serveur');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 404) {
          throw NotFoundException(
            'Données NEO non trouvées pour cette période',
          );
        } else if (statusCode == 401 || statusCode == 403) {
          throw UnauthorizedException('Clé API invalide ou manquante');
        } else {
          throw ServerException('Erreur serveur: $statusCode');
        }
      case DioExceptionType.cancel:
        throw ServerException('Requête annulée');
      case DioExceptionType.unknown:
      case DioExceptionType.badCertificate:
        throw NetworkException(e.message ?? 'Erreur réseau inconnue');
    }
  }
}
