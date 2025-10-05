import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/card_item.dart';
import '../../../data/repositories/game_repository.dart';
import 'game_event.dart';
import 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameRepository _repo;
  Timer? _timer;

  GameBloc(this._repo) : super(const GameInitial()) {
    on<GameStarted>(_onStarted);
    on<CardFlipped>(_onCardFlipped);
    on<FlipBackTimeoutElapsed>(_onFlipBackTimeout);
    on<TimerTicked>(_onTimerTicked);
    on<GameReset>(_onReset);
  }

  // --- Event handlers ---

  void _onStarted(GameStarted event, Emitter<GameState> emit) {
    _cancelTimer();

    final deck = _repo.generateDeck(event.difficulty);
    emit(GameInProgress(
      deck: deck,
      flippedIndices: <int>{},
      matchedIndices: <int>{},
      moves: 0,
      elapsed: Duration.zero,
      isLocked: false,
    ));

    _timer = Timer.periodic(const Duration(seconds: 1), (_) => add(TimerTicked()));
  }

  void _onCardFlipped(CardFlipped event, Emitter<GameState> emit) {
    final s = state;
    if (s is! GameInProgress) return;

    // ignore taps while locked
    if (s.isLocked) return;

    // ignore if already matched or already flipped
    if (s.matchedIndices.contains(event.index) || s.flippedIndices.contains(event.index)) {
      return;
    }

    // flip first or second card
    final newFlipped = Set<int>.from(s.flippedIndices)..add(event.index);

    // First card: just reveal it
    if (newFlipped.length == 1) {
      emit(s.copyWith(flippedIndices: newFlipped));
      return;
    }

    // Second card: increase moves and check match
    if (newFlipped.length == 2) {
      final indices = newFlipped.toList(growable: false);
      final a = indices[0];
      final b = indices[1];

      final List<CardItem> deck = s.deck;
      final bool isMatch = deck[a].face == deck[b].face; // match by face key

      final int nextMoves = s.moves + 1;

      if (isMatch) {
        final newMatched = Set<int>.from(s.matchedIndices)..addAll([a, b]);
        // Clear flipped because they are now matched
        final nextState = s.copyWith(
          flippedIndices: <int>{},
          matchedIndices: newMatched,
          moves: nextMoves,
        );

        // Check win
        if (newMatched.length == deck.length) {
          _cancelTimer();
          emit(GameWon(deck: deck, moves: nextMoves, elapsed: s.elapsed));
        } else {
          emit(nextState);
        }
      } else {
        // Mismatch: lock input and schedule flip back
        emit(s.copyWith(
          flippedIndices: newFlipped,
          moves: nextMoves,
          isLocked: true,
        ));

        // Delay before flipping back (UI can run flip animation during this)
        Future.delayed(const Duration(milliseconds: 800), () {
          // Only add if we haven't left the InProgress state
          if (state is GameInProgress) {
            add(FlipBackTimeoutElapsed());
          }
        });
      }
    }

    // If somehow more than 2 (shouldn't happen), ignore extra taps until resolved
  }

  void _onFlipBackTimeout(FlipBackTimeoutElapsed event, Emitter<GameState> emit) {
    final s = state;
    if (s is! GameInProgress) return;
    // Flip both back and unlock
    emit(s.copyWith(flippedIndices: <int>{}, isLocked: false));
  }

  void _onTimerTicked(TimerTicked event, Emitter<GameState> emit) {
    final s = state;
    if (s is! GameInProgress) return;
    emit(s.copyWith(elapsed: s.elapsed + const Duration(seconds: 1)));
  }

  void _onReset(GameReset event, Emitter<GameState> emit) {
    _cancelTimer();
    emit(const GameInitial());
  }

  // --- Helpers ---
  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<void> close() {
    _cancelTimer();
    return super.close();
  }
}
