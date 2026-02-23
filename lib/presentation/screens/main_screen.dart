import 'package:flutter/material.dart';
import 'dart:async';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {

  double progress = 0.0;
  bool isFinished = false;

  @override
  void initState() {
    super.initState();
    startLoading();
  }

  void startLoading() {
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        progress += 0.05;
      });

      if (progress >= 1.0) {
        timer.cancel();
        setState(() {
          isFinished = true;
        });
      }
    });
  }

  @override
  void dispose(){
    // pour eviter la fuite de memoire
    var timer;
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chargement météo")),
      body: Center(
        child: isFinished
            ? const Text("BOOM Tableau météo ici")
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(value: progress),
            const SizedBox(height: 20),
            const Text("Téléchargement des données..."),
          ],
        ),
      ),
    );
  }
}