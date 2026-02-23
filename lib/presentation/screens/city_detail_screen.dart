import 'package:flutter/material.dart';

class CityDetailScreen extends StatelessWidget {
  final String cityName;

  const CityDetailScreen({super.key, required this.cityName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(cityName)),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            "Détails météo pour $cityName",
            style: const TextStyle(fontSize: 22),
          ),
          const SizedBox(height: 20),
          const Expanded(
            child: Center(
              child: Text("Google Maps ici ️"),
            ),
          ),
        ],
      ),
    );
  }
}