import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Timer _timer;
  int _timeLeft = 10;
  int _score = 0;
  int _level = 1;
  Color targetColor = Colors.red;
  List<Color> colors = [];
  int targetCount = 3;

  // ✅ Color Names Map
  Map<Color, String> colorNames = {
    Colors.red: "Red",
    Colors.blue: "Blue",
    Colors.green: "Green",
    Colors.yellow: "Yellow",
    Colors.orange: "Orange",
    Colors.purple: "Purple",
  };

  @override
  void initState() {
    super.initState();
    _startTimer();
    _generateColors();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _gameOver("Time's up! You lost! ⏳");
      }
    });
  }

  void _generateColors() {
    Random random = Random();
    colors.clear();
    for (int i = 0; i < 9; i++) {
      if (i < targetCount) {
        colors.add(targetColor);
      } else {
        colors.add(Color.fromARGB(255, random.nextInt(256), random.nextInt(256), random.nextInt(256)));
      }
    }
    colors.shuffle();
  }

  void _checkColor(int index) {
    if (colors[index] == targetColor) {
      setState(() {
        colors[index] = Colors.grey;
        targetCount--;
        _score += 10;  // ✅ Score Increase
      });

      if (targetCount == 0) {
        _levelUp();  // ✅ Move to Next Level
      }
    } else {
      _gameOver("Wrong Color! You Lost! ❌");
    }
  }

  void _levelUp() {
    setState(() {
      _level++;
      _timeLeft = 10;  // Reset Timer
      targetCount += 2;  // Increase Target Colors
      targetColor = colorNames.keys.elementAt(Random().nextInt(colorNames.length));  // Random Target Color
      _generateColors();
    });
  }

  void _gameOver(String message) {
    _timer.cancel();
    _showMessage(message);
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  String getColorName(Color color) {
    return colorNames[color] ?? "Unknown";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 40),
            const SizedBox(width: 10),
            const Text(
              "Color Tap Game 🎨",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Time Left: $_timeLeft sec",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          const SizedBox(height: 10),
          Text(
            "Score: $_score  |  Level: $_level",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          const SizedBox(height: 20),
          Text(
            "Tap all '${getColorName(targetColor)}' colors!",
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: colors.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _checkColor(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors[index],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
