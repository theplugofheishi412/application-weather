import 'package:flutter/material.dart';
import 'main_screen.dart';
import '../../main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = MyApp.of(context);
    final isDark = appState?.isDark ?? false;

    return Scaffold(
      // Bouton toggle dark/light en haut à droite
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () => appState?.toggleTheme(),
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                  key: ValueKey(isDark),
                  color: Colors.white,
                  size: 28,
                ),
              ),
              tooltip: isDark ? 'Mode clair' : 'Mode sombre',
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Image de fond
          Positioned.fill(
            child: Image.asset(
              "assets/img/backgroundexamen.jpg",
              fit: BoxFit.cover,
            ),
          ),

          // Overlay sombre adapté au thème
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(isDark ? 0.65 : 0.45),
            ),
          ),

          // Contenu
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icône animée
                const Icon(
                  Icons.cloud,
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),

                // Message d'accueil
                const Text(
                  "Bienvenue dans ton\nexpérience météo 🌤",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),

                const Text(
                  "Découvrez la météo en temps réel\npour 5 villes du monde",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 48),

                // Bouton lancer
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: const Color(0xFF2F80ED),
                    foregroundColor: Colors.white,
                    elevation: 10,
                    shadowColor: const Color(0xFF2F80ED).withOpacity(0.5),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.rocket_launch_rounded),
                  label: const Text(
                    "Lancer l'expérience",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}