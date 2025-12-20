import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/apod_model.dart';

/// Interface abstraite pour le remote datasource APOD
abstract class ApodRemoteDataSource {
  /// Récupère l'APOD du jour ou d'une date spécifique
  ///
  /// [date] - Format: YYYY-MM-DD (optionnel, si null retourne l'APOD du jour)
  ///
  /// Throws [ServerException] en cas d'erreur serveur
  /// Throws [NetworkException] en cas de problème réseau
  Future<ApodModel> getApod({String? date});

  /// Récupère une liste d'APODs pour une plage de dates
  ///
  /// [startDate] - Date de début au format YYYY-MM-DD
  /// [endDate] - Date de fin au format YYYY-MM-DD
  ///
  /// Throws [ServerException] en cas d'erreur serveur
  /// Throws [NetworkException] en cas de problème réseau
  Future<List<ApodModel>> getApodRange({
    required String startDate,
    required String endDate,
  });
}

/// Implémentation du remote datasource pour l'API APOD de la NASA
class ApodRemoteDataSourceImpl implements ApodRemoteDataSource {
  final DioClient dioClient;

  ApodRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<ApodModel> getApod({String? date}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (date != null) {
        queryParams['date'] = date;
      }

      final response = await dioClient.dio.get(
        ApiConstants.apodEndpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return ApodModel.fromJson(response.data);
      } else {
        throw ServerException('Erreur serveur: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<List<ApodModel>> getApodRange({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await dioClient.dio.get(
        ApiConstants.apodEndpoint,
        queryParameters: {'start_date': startDate, 'end_date': endDate},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList
            .map((json) => ApodModel.fromJson(json as Map<String, dynamic>))
            .toList();
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
          throw NotFoundException('APOD non trouvé pour cette date');
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
