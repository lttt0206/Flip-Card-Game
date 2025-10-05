// lib/data/repositories/game_repository.dart
import 'dart:math';

import 'package:flip_card_game/core/models/card_item.dart';

class GameRepository {
  final Random _random = Random();

  /// Generate a new shuffled deck based on difficulty
  List<CardItem> generateDeck(Difficulty difficulty) {
    final pairCount = _pairCountForDifficulty(difficulty);

    // Example faces: emojis
    final faces = ['🐶','🐱','🐭','🦊','🐻','🐼','🐸','🐵','🐧','🐤','🦄','🐙'];

    // Take as many as needed
    final selectedFaces = faces.sublist(0, pairCount);

    // Duplicate + shuffle
    final cards = <CardItem>[
      for (var face in selectedFaces) ...[
        CardItem(id: face + "_1", face: face),
        CardItem(id: face + "_2", face: face),
      ]
    ];

    cards.shuffle(_random);
    return cards;
  }

  int _pairCountForDifficulty(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy2x2: return 2;   // 2 pairs
      case Difficulty.normal3x4: return 6; // 6 pairs
      case Difficulty.hard4x4: return 8;   // 8 pairs
      case Difficulty.insane5x6: return 15; // 15 pairs
    }
  }
}
