class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Une erreur serveur est survenue']);
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Pas de connexion internet']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Erreur de cache']);
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = 'Accès non autorisé']);
}
class NotFoundException implements Exception {
  final String message;
  NotFoundException([this.message = 'Ressource non trouvée']);
}