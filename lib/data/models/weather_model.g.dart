// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherModel _$WeatherModelFromJson(Map<String, dynamic> json) => WeatherModel(
      cityName: json['cityName'] as String,
      country: json['country'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      feelsLike: (json['feelsLike'] as num).toDouble(),
      tempMin: (json['tempMin'] as num).toDouble(),
      tempMax: (json['tempMax'] as num).toDouble(),
      humidity: (json['humidity'] as num).toInt(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      description: json['description'] as String,
      icon: json['icon'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );

Map<String, dynamic> _$WeatherModelToJson(WeatherModel instance) =>
    <String, dynamic>{
      'cityName': instance.cityName,
      'country': instance.country,
      'temperature': instance.temperature,
      'feelsLike': instance.feelsLike,
      'tempMin': instance.tempMin,
      'tempMax': instance.tempMax,
      'humidity': instance.humidity,
      'windSpeed': instance.windSpeed,
      'description': instance.description,
      'icon': instance.icon,
      'lat': instance.lat,
      'lon': instance.lon,
    };
