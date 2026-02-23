class ApiConstants {
  // --- Base URL OpenWeatherMap ---
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  // --- cle API OpenWeatherMap ---
  //cle API

  static const String apiKey = '40cd71cb36d24d75a0bbd2350f656e54';

  // --- Paramètres par défaut ---
  static const String units = 'metric';
  static const String lang = 'fr';

  // --- Les 5 villes ---
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
  ];
}