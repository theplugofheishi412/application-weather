import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // --- Base URL OpenWeatherMap ---
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  // --- cle API OpenWeatherMap ---
  //cle API
  static String get apiKey => dotenv.env['OPENWEATHER_API_KEY'] ?? '';


  // --- Paramètres par défaut ---
  static const String units = 'metric';
  static const String lang = 'fr';

  // --- Les  villes ---
  static const List<Map<String, dynamic>> cities = [
    {
      'name': 'Dakar',
      'country': 'Sénégal',
      'lat': 14.6928,
      'lon': -17.4467,
    },
    {
      'name': 'Libreville',
      'country': 'Gabon',
      'lat': 0.3901,
      'lon': 9.4544,
    },
    {
      'name': 'Amsterdam',
      'country': 'Pays-Bas',
      'lat': 52.3676,
      'lon': 4.9041,
    },
    {
      'name': 'Tokyo',
      'country': 'Japon',
      'lat': 35.6762,
      'lon': 139.6503,
    },
    {
      'name': 'Kingston',
      'country': 'Jamaïque',
      'lat': 17.9970,
      'lon': -76.7936,
    },
    {
      'name': 'Congo',
      'contry':'Brazzaville',
      'lat':-4.2677,
      'lon':15.291,
    }
  ];
}