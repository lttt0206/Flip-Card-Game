// lib/features/game/pages/game_page.dart
import 'package:flip_card_game/core/models/card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/game_repository.dart';
import '../bloc/game_bloc.dart';
import '../bloc/game_event.dart';
import '../bloc/game_state.dart';
import '../widgets/card_tile.dart';

class GamePage extends StatefulWidget {
  final Difficulty difficulty;
  const GamePage({super.key, required this.difficulty});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late int _rows;
  late int _cols;

  @override
  void initState() {
    super.initState();
    final rAndC = _gridForDifficulty(widget.difficulty);
    _rows = rAndC.$1;
    _cols = rAndC.$2;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameBloc(GameRepository())..add(GameStarted(widget.difficulty)),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Game - ${_titleFor(widget.difficulty)}"),
          actions: [
            IconButton(
              tooltip: 'Reset',
              icon: const Icon(Icons.refresh),
              onPressed: () {
                // Recreate bloc state for a fresh shuffle
                context.read<GameBloc>().add(GameStarted(widget.difficulty));
              },
            ),
          ],
        ),
        body: Column(
          children: [
            _HudBar(),
            const Divider(height: 1),
            Expanded(child: _Board(cols: _cols)),
          ],
        ),
      ),
    );
  }

  (int, int) _gridForDifficulty(Difficulty d) {
    switch (d) {
      case Difficulty.easy2x2:
        return (2, 2);
      case Difficulty.normal3x4:
        return (3, 4);
      case Difficulty.hard4x4:
        return (4, 4);
      // case Difficulty.insane5x6:
      //   return (5, 6);
    }
  }

  String _titleFor(Difficulty d) {
    switch (d) {
      case Difficulty.easy2x2:
        return "Easy (2×2)";
      case Difficulty.normal3x4:
        return "Normal (3×4)";
      case Difficulty.hard4x4:
        return "Hard (4×4)";
      // case Difficulty.insane5x6:
      //   return "Insane (5×6)";
    }
  }
}

class _HudBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: BlocConsumer<GameBloc, GameState>(
        listenWhen: (prev, curr) => curr is GameWon,
        listener: (context, state) {
          if (state is GameWon) {
            final m = state.elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
            final s = state.elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) => AlertDialog(
                title: const Text('🎉 You Win!'),
                content: Text('Time: $m:$s\nMoves: ${state.moves}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      context.read<GameBloc>().add(GameReset());
                      // Start a new round with the same difficulty
                      // (Read it from the route's widget if needed; here we grab via ancestor)
                      // Safer: pop to previous and re-enter, but we restart locally:
                      // Use a small post-frame to re-start:
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        // We don't know difficulty here; so trigger Home re-navigation?
                        // Easier: replace won state to initial and let user press refresh / back.
                      });
                    },
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          int moves = 0;
          String time = "00:00";
          if (state is GameInProgress) {
            moves = state.moves;
            final m = state.elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
            final s = state.elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
            time = "$m:$s";
          } else if (state is GameWon) {
            moves = state.moves;
            final m = state.elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
            final s = state.elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
            time = "$m:$s";
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("⏱ Time: $time", style: textTheme.bodyLarge),
              Text("🃏 Moves: $moves", style: textTheme.bodyLarge),
            ],
          );
        },
      ),
    );
  }
}

class _Board extends StatelessWidget {
  final int cols;
  const _Board({required this.cols});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state is GameInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        late final List deck;
        late final Set<int> matched;
        late final Set<int> flipped;
        bool locked = false;

        if (state is GameInProgress) {
          deck = state.deck;
          matched = state.matchedIndices;
          flipped = state.flippedIndices;
          locked = state.isLocked;
        } else if (state is GameWon) {
          deck = state.deck;
          matched = <int>{...List.generate(deck.length, (i) => i)};
          flipped = matched;
        } else {
          return const SizedBox.shrink();
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemCount: deck.length,
          itemBuilder: (context, index) {
            final face = deck[index].face; // CardItem.face
            final revealed = flipped.contains(index) || matched.contains(index);

            return CardTile(
              index: index,
              face: face,
              revealed: revealed,
              onTap: (!locked && !revealed)
                  ? () => context.read<GameBloc>().add(CardFlipped(index))
                  : null,
            );
          },
        );
      },
    );
  }
}
