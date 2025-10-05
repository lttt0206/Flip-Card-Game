// lib/features/game/widgets/card_tile.dart (props only; animation up to you)
import 'package:flutter/material.dart';

class CardTile extends StatelessWidget {
  final int index;
  final String face;         // e.g., emoji
  final bool revealed;
  final VoidCallback? onTap;

  const CardTile({
    super.key,
    required this.index,
    required this.face,
    required this.revealed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) =>
                RotationYTransition(turns: anim, child: child), // optional custom
            child: Text(
              revealed ? face : "?",
              key: ValueKey(revealed),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      ),
    );
  }
}

// OPTIONAL: simple rotation (replace with your own or keep default)
class RotationYTransition extends StatelessWidget {
  final Animation<double> turns;
  final Widget child;
  const RotationYTransition({super.key, required this.turns, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: turns,
      builder: (context, _) {
        final angle = turns.value * 3.141592653589793; // 0..pi
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          alignment: Alignment.center,
          child: child,
        );
      },
    );
  }
}
