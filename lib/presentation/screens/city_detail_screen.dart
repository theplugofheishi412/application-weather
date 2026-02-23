import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../data/models/weather_model.dart';

class CityDetailScreen extends StatelessWidget {
  final String cityName;
  final WeatherModel weather;

  const CityDetailScreen({
    super.key,
    required this.cityName,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final position = LatLng(weather.lat, weather.lon);

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF0F7FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          weather.cityName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Header avec température ---
            _buildHeader(weather),

            const SizedBox(height: 20),

            // --- Grille d'infos météo ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.6,
                children: [
                  _buildInfoCard(
                    icon: Icons.thermostat_rounded,
                    label: "Ressenti",
                    value: weather.feelsLikeDisplay,
                    isDark: isDark,
                  ),
                  _buildInfoCard(
                    icon: Icons.water_drop_rounded,
                    label: "Humidité",
                    value: "${weather.humidity}%",
                    isDark: isDark,
                  ),
                  _buildInfoCard(
                    icon: Icons.air_rounded,
                    label: "Vent",
                    value: "${weather.windSpeed} m/s",
                    isDark: isDark,
                  ),
                  _buildInfoCard(
                    icon: Icons.thermostat,
                    label: "Min / Max",
                    value:
                    "${weather.tempMin.round()}° / ${weather.tempMax.round()}°",
                    isDark: isDark,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- Titre carte ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "📍 Localisation",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // --- flutter_map (OpenStreetMap) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 300,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: position,
                      initialZoom: 11,
                    ),
                    children: [
                      // Tuiles OpenStreetMap
                      TileLayer(
                        urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.meteo_app',
                      ),
                      // Marqueur de la ville
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: position,
                            width: 60,
                            height: 60,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2F80ED),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    weather.tempDisplay,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.location_pin,
                                  color: Color(0xFF2F80ED),
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(WeatherModel weather) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2F80ED), Color(0xFF56CCF2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Image.network(
            weather.iconUrl,
            width: 80,
            height: 80,
            errorBuilder: (_, __, ___) =>
            const Icon(Icons.cloud, size: 80, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            weather.tempDisplay,
            style: const TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            weather.description.toUpperCase(),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            weather.country,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark
            ? Colors.white.withOpacity(0.07)
            : Colors.black.withOpacity(0.05),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2F80ED), size: 28),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}