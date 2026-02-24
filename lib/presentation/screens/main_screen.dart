import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import '../../data/models/weather_model.dart';
import '../../data/repositories/weather_repository.dart';
import '../../core/constants/api_constants.dart';
import 'city_detail_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {

  // --- Données ---
  final WeatherRepository _repository = WeatherRepository();
  final List<WeatherModel> _weatherData = [];
  bool _isFinished = false;
  bool _hasError = false;
  String _errorMessage = '';

  // --- Progression ---
  double _progress = 0.0;
  int _currentCityIndex = 0;

  // --- Messages rotatifs ---
  int _messageIndex = 0;
  Timer? _messageTimer;
  final List<String> _messages = [
    "Nous téléchargeons les données…",
    "C'est presque fini…",
    "Plus que quelques secondes avant d'avoir le résultat…",
  ];

  // --- Animations ---
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..value = 1.0;

    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _startMessages();
    _loadWeatherData();
  }

  void _startMessages() {
    _messageTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (!mounted) return;
      await _fadeController.reverse();
      if (!mounted) return;
      setState(() {
        _messageIndex = (_messageIndex + 1) % _messages.length;
      });
      _fadeController.forward();
    });
  }

  Future<void> _loadWeatherData() async {
    setState(() {
      _weatherData.clear();
      _progress = 0.0;
      _currentCityIndex = 0;
      _isFinished = false;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      for (int i = 0; i < ApiConstants.cities.length; i++) {
        final city = ApiConstants.cities[i];

        if (!mounted) return;
        setState(() => _currentCityIndex = i);

        final weather = await _repository.fetchCityWeather(
          lat: city['lat'],
          lon: city['lon'],
        );

        if (!mounted) return;
        setState(() {
          _weatherData.add(weather);
          _progress = (i + 1) / ApiConstants.cities.length;
        });

        await Future.delayed(const Duration(milliseconds: 800));
      }

      _messageTimer?.cancel();
      _shimmerController.stop();

      if (mounted) {
        setState(() => _isFinished = true);
      }
    } catch (e) {
      _messageTimer?.cancel();
      _shimmerController.stop();
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    }
  }

  void _restart() {
    _shimmerController.repeat();
    _startMessages();
    _loadWeatherData();
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _fadeController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF0F7FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Météo en direct",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _hasError ? _buildErrorWidget() : _buildMainContent(isDark),
      ),
    );
  }

  Widget _buildMainContent(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),

          // --- Animation Lottie  ---
          SizedBox(
            width: 200,
            height: 200,
            child: Lottie.asset(
              _isFinished
                  ? 'assets/lottie/Succes.json'
                  : 'assets/lottie/Foggy.json',
              fit: BoxFit.contain,
              repeat: !_isFinished,
            ),
          ),

          const SizedBox(height: 40),

          // --- Titre ---
          Text(
            _isFinished
                ? "Données validées"
                : "Chargement : ${ApiConstants.cities[_currentCityIndex]['name']}…",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF1A1A2E),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // --- Barre de progression ---
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${(_progress * 100).toInt()}%",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white60 : Colors.black45,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 18,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.08)
                              : Colors.black.withOpacity(0.08),
                        ),
                      ),
                      AnimatedFractionallySizedBox(
                        duration: const Duration(milliseconds: 500),
                        widthFactor: _progress,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF2F80ED), Color(0xFF56CCF2)],
                            ),
                          ),
                        ),
                      ),
                      if (!_isFinished)
                        AnimatedBuilder(
                          animation: _shimmerController,
                          builder: (context, _) {
                            return FractionallySizedBox(
                              widthFactor: _progress,
                              child: ShaderMask(
                                shaderCallback: (rect) {
                                  final shimmerX = _shimmerController.value;
                                  return LinearGradient(
                                    begin: Alignment(shimmerX * 2 - 1.5, 0),
                                    end: Alignment(shimmerX * 2 - 0.5, 0),
                                    colors: [
                                      Colors.transparent,
                                      Colors.white.withOpacity(0.3),
                                      Colors.transparent,
                                    ],
                                  ).createShader(rect);
                                },
                                child: Container(color: Colors.white),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // --- Message rotatif ---
          if (!_isFinished)
            FadeTransition(
              key: ValueKey(_messageIndex),
              opacity: _fadeAnimation,
              child: Text(
                _messages[_messageIndex],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

          // --- Tableau météo + bouton Recommencer ---
          if (_isFinished) ...[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.black.withOpacity(0.04),
              ),
              child: Column(
                children: _weatherData.map((weather) {
                  return _buildCityRow(weather, isDark);
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _restart,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(
                "Recommencer",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                backgroundColor: const Color(0xFF2F80ED),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 8,
                shadowColor: const Color(0xFF2F80ED).withOpacity(0.5),
              ),
            ),
          ],

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildCityRow(WeatherModel weather, bool isDark) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CityDetailScreen(
              cityName: weather.cityName,
              weather: weather,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Image.network(
              weather.iconUrl,
              width: 40,
              height: 40,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.cloud, size: 40, color: Colors.grey),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weather.cityName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    weather.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white60 : Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              weather.tempDisplay,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F80ED),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // --- Widget erreur avec Lottie ---
  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/Error 404.json',
              width: 180,
              height: 180,
              repeat: true,
            ),
            const SizedBox(height: 20),
            const Text(
              "Oups ! Une erreur est survenue",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _restart,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text("Réessayer"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F80ED),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}