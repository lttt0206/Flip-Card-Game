import 'package:flip_card_game/core/models/card_item.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class GameEvent {}

class GameStarted extends GameEvent {
  final Difficulty difficulty;
  GameStarted(this.difficulty);
}

class CardFlipped extends GameEvent {
  final int index;
  CardFlipped(this.index);
}

class FlipBackTimeoutElapsed extends GameEvent {}

class TimerTicked extends GameEvent {}

class GameReset extends GameEvent {}
