// lib/features/menu/home_page.dart
import 'package:flip_card_game/core/models/card_item.dart';
import 'package:flutter/material.dart';
import '../game/pages/game_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _startGame(BuildContext context, Difficulty difficulty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GamePage(difficulty: difficulty),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flip-Card Game"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Choose Difficulty",
                style: textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Buttons for each difficulty
              ElevatedButton(
                onPressed: () => _startGame(context, Difficulty.easy2x2),
                child: const Text("Easy (2x2)"),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () => _startGame(context, Difficulty.normal3x4),
                child: const Text("Normal (3x4)"),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () => _startGame(context, Difficulty.hard4x4),
                child: const Text("Hard (4x4)"),
              ),
              const SizedBox(height: 16),

              // ElevatedButton(
              //   onPressed: () => _startGame(context, Difficulty.insane5x6),
              //   child: const Text("Insane (5x6)"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
