import 'package:dio/dio.dart';
import '../models/weather_model.dart';
import '../../core/constants/api_constants.dart';

class WeatherApiService {
  late final Dio _dio;

  WeatherApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        queryParameters: {
          'appid': ApiConstants.apiKey,
          'units': ApiConstants.units,
          'lang': ApiConstants.lang,
        },
      ),
    );

    // Log des requêtes en mode debug
    _dio.interceptors.add(LogInterceptor(
      requestBody: false,
      responseBody: false,
      logPrint: (log) => print('[DIO] $log'),
    ));
  }

  /// Récupère la météo d'une ville via ses coordonnées GPS
  Future<WeatherModel> getWeatherByCoords({
    required double lat,
    required double lon,
  }) async {
    try {
      final response = await _dio.get(
        '/weather',
        queryParameters: {
          'lat': lat,
          'lon': lon,
        },
      );

      return WeatherModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Récupère la météo pour toutes les villes définies dans ApiConstants
  Future<List<WeatherModel>> getAllCitiesWeather() async {
    final List<WeatherModel> results = [];

    for (final city in ApiConstants.cities) {
      final weather = await getWeatherByCoords(
        lat: city['lat'],
        lon: city['lon'],
      );
      results.add(weather);
    }

    return results;
  }

  /// Gestion centralisée des erreurs Dio
  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Délai de connexion dépassé. Vérifie ta connexion internet.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return Exception('API invalide.');
        } else if (statusCode == 404) {
          return Exception('Ville introuvable.');
        }
        return Exception('Erreur serveur ($statusCode).');
      case DioExceptionType.connectionError:
        return Exception('Pas de connexion internet.');
      default:
        return Exception('Erreur inattendue : ${e.message}');
    }
  }
}