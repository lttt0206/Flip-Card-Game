// lib/core/models/card_item.dart
class CardItem {
  final String id;
  final String face;
  final bool revealed;

  const CardItem({
    required this.id,
    required this.face,
    this.revealed = false,
  });

  CardItem copyWith({bool? revealed}) =>
      CardItem(id: id, face: face, revealed: revealed ?? this.revealed);
}

// lib/core/models/difficulty.dart
enum Difficulty { easy2x2, normal3x4, hard4x4, insane5x6 }
