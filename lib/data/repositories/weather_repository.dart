import '../models/weather_model.dart';
import '../services/weather_api_service.dart';

class WeatherRepository {
  final WeatherApiService _apiService;

  WeatherRepository({WeatherApiService? apiService})
      : _apiService = apiService ?? WeatherApiService();

  /// Récupère la météo de toutes les villes
  /// Retourne une liste de WeatherModel ou lance une exception
  Future<List<WeatherModel>> fetchAllCitiesWeather() async {
    try {
      final results = await _apiService.getAllCitiesWeather();
      return results;
    } catch (e) {
      throw Exception('Impossible de récupérer les données météo : $e');
    }
  }

  /// Récupère la météo d'une seule ville via ses coordonnées
  Future<WeatherModel> fetchCityWeather({
    required double lat,
    required double lon,
  }) async {
    try {
      return await _apiService.getWeatherByCoords(lat: lat, lon: lon);
    } catch (e) {
      throw Exception("Impossible de récupérer la météo de cette ville : $e");
    }
  }
}