import 'package:json_annotation/json_annotation.dart';

part 'weather_model.g.dart';

@JsonSerializable()
class WeatherModel {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed;
  final String description;
  final String icon;
  final double lat;
  final double lon;

  const WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
    required this.lat,
    required this.lon,
  });

  /// Construit un WeatherModel depuis la réponse brute OpenWeatherMap
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] as String,
      country: (json['sys'] as Map<String, dynamic>)['country'] as String,
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      description: (json['weather'] as List).first['description'] as String,
      icon: (json['weather'] as List).first['icon'] as String,
      lat: (json['coord']['lat'] as num).toDouble(),
      lon: (json['coord']['lon'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => _$WeatherModelToJson(this);

  /// URL de l'icône météo OpenWeather
  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';

  /// Température arrondie pour l'affichage
  String get tempDisplay => '${temperature.round()}°C';

  /// Ressenti arrondi pour l'affichage
  String get feelsLikeDisplay => '${feelsLike.round()}°C';
}