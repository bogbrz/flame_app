import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_app/components/card.dart';
import 'package:flame_app/components/pile.dart';
import 'package:flame_app/components/waste_pile.dart';
import 'package:flame_app/klondike_game.dart';

class StockPile extends PositionComponent with TapCallbacks implements Pile {
  StockPile({super.position}) : super(size: KlondikeGame.cardSize);

  final List<Card> _cards = [];
  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = const Color(0xFF3F5B5D);
  final _circlePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 100
    ..color = const Color(0x883F5B5D);
  @override
  bool canMoveCard(Card card) => false;
  @override
  bool canAcceptCard(Card card) => false;
   @override
  void removeCard(Card card) => throw StateError('cannot remove cards from here');
  @override
  void returnCard(Card card) => throw StateError('cannot remove cards from here');
  @override
  void onTapUp(TapUpEvent event) {
    final wastePile = parent!.firstChild<WastePile>()!;

    if (_cards.isEmpty) {
      wastePile.removeAllCards().reversed.forEach((card) {
        card.flip();
        acquireCard(card);
      });
    } else {
      for (var i = 0; i < 3; i++) {
        if (_cards.isNotEmpty) {
          final card = _cards.removeLast();
          card.flip();
          wastePile.acquireCard(card);
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(KlondikeGame.cardRRect, _borderPaint);
    canvas.drawCircle(
      Offset(width / 2, height / 2),
      KlondikeGame.cardWidth * 0.3,
      _circlePaint,
    );
  }

  void acquireCard(Card card) {
    assert(!card.isFaceUp);
    card.pile = this;
    card.position = position;
    card.priority = _cards.length;
    _cards.add(card);
  }
}
