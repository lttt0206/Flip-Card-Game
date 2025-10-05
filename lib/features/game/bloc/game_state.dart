import 'package:flutter/foundation.dart';
import '../../../core/models/card_item.dart';

@immutable
abstract class GameState {
  const GameState();
}

class GameInitial extends GameState {
  const GameInitial();
}

class GameInProgress extends GameState {
  final List<CardItem> deck;
  final Set<int> flippedIndices;   // currently face-up but not yet matched (size 0..2)
  final Set<int> matchedIndices;   // permanently matched indices
  final int moves;                 // counts when a pair is attempted (flip #2)
  final Duration elapsed;          // timer since game start
  final bool isLocked;             // lock taps during flip-back animation

  const GameInProgress({
    required this.deck,
    required this.flippedIndices,
    required this.matchedIndices,
    required this.moves,
    required this.elapsed,
    required this.isLocked,
  });

  GameInProgress copyWith({
    List<CardItem>? deck,
    Set<int>? flippedIndices,
    Set<int>? matchedIndices,
    int? moves,
    Duration? elapsed,
    bool? isLocked,
  }) {
    return GameInProgress(
      deck: deck ?? this.deck,
      flippedIndices: flippedIndices ?? this.flippedIndices,
      matchedIndices: matchedIndices ?? this.matchedIndices,
      moves: moves ?? this.moves,
      elapsed: elapsed ?? this.elapsed,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}

class GameWon extends GameState {
  final List<CardItem> deck;
  final int moves;
  final Duration elapsed;

  const GameWon({
    required this.deck,
    required this.moves,
    required this.elapsed,
  });
}
