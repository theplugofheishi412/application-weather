import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'main_screen.dart';
import '../../main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = MyApp.of(context);
    final isDark = appState?.isDark ?? false;

    return Scaffold(
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
          // ✨ Dégradé animé en fond
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? const [Color(0xFF0D1B2A), Color(0xFF1A2E4A), Color(0xFF0D1B2A)]
                      : const [Color(0xFF4FC3F7), Color(0xFF2F80ED), Color(0xFF1565C0)],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // ☁️ Nuages décoratifs en fond (cercles flous)
          Positioned(
            top: -60,
            left: -80,
            child: _buildBlob(220, const Color(0xFF56CCF2).withOpacity(0.3)),
          ),
          Positioned(
            top: 100,
            right: -60,
            child: _buildBlob(180, const Color(0xFF2F80ED).withOpacity(0.2)),
          ),
          Positioned(
            bottom: 80,
            left: -40,
            child: _buildBlob(160, const Color(0xFF56CCF2).withOpacity(0.15)),
          ),
          Positioned(
            bottom: -40,
            right: -30,
            child: _buildBlob(200, const Color(0xFF4A90E2).withOpacity(0.2)),
          ),

          // Overlay sombre en mode dark
          if (isDark)
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),

          //  Contenu principal
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animation Lottie
                Lottie.asset(
                  'assets/lottie/Foggy.json',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 10),

                // Titre
                const Text(
                  "Météo en temps réel",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 12),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: const Text(
                    "Découvrez la météo en direct\npour 5 villes du monde ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                      height: 1.6,
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Bouton
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2F80ED),
                    elevation: 12,
                    shadowColor: Colors.black.withOpacity(0.3),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MainScreen()),
                    );
                  },
                  //icon: const Icon(Icons.rocket_launch_rounded),
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

  Widget _buildBlob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}