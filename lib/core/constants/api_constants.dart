import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String apiKey = dotenv.env['NASA_API_KEY'] ?? 'DEMO_KEY';
  static String baseUrl = dotenv.env['BASE_URL'] ?? 'https://api.nasa.gov';

  static const String apodEndpoint = '/planetary/apod';
  static const String neoEndpoint = '/neo/rest/v1/feed';
  static const String marsRoverEndpoint = '/mars-photos/api/v1/rovers';
}
