import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_app/components/card.dart';
import 'package:flame_app/components/foundation_pile.dart';
import 'package:flame_app/components/stock_pile.dart';
import 'package:flame_app/components/tableau_pile.dart';
import 'package:flame_app/components/waste_pile.dart';
import 'package:flame_app/klondike_game.dart';


class KlondikeWorld extends World with HasGameReference<KlondikeGame> {
   final cardGap = KlondikeGame.cardGap;
  final topGap = KlondikeGame.topGap;
  final cardSpaceWidth = KlondikeGame.cardSpaceWidth;
  final cardSpaceHeight = KlondikeGame.cardSpaceHeight;

  final stock = StockPile(position: Vector2(0.0, 0.0));
  final waste = WastePile(position: Vector2(0.0, 0.0));
  final List<FoundationPile> foundations = [];
  final List<TableauPile> tableauPiles = [];
  final List<Card> cards = [];
  late Vector2 playAreaSize;
   @override
  Future<void> onLoad() async {
    await Flame.images.load("klondike-sprites.png");

    final stock = StockPile(position: Vector2(cardGap, cardGap));

    final waste =
        WastePile(position: Vector2(cardWidth + 2 * cardGap, cardGap));
    final foundations = List.generate(
        4,
        (i) => FoundationPile(
              i,
              position:
                  Vector2((i + 3) * (cardWidth + cardGap) + cardGap, cardGap),
            ));
    final piles = List.generate(
      7,
      (i) => TableauPile(
        position: Vector2(
          cardGap + i * (cardWidth + cardGap),
          cardHeight + 2 * cardGap,
        ),
      ),
    );
    world.add(stock);
    world.add(waste);
    world.addAll(foundations);
    world.addAll(piles);
    camera.viewfinder.visibleGameSize =
        Vector2(cardWidth * 7 + cardGap * 8, 4 * cardHeight + 3 * cardGap);
    camera.viewfinder.position = Vector2(cardWidth * 3.5 + cardGap * 4, 0);
    camera.viewfinder.anchor = Anchor.topCenter;

    final cards = [
      for (var rank = 1; rank <= 13; rank++)
        for (var suit = 0; suit < 4; suit++) Card(rank, suit)
    ];
    cards.shuffle();
    world.addAll(cards);

    int cardToDeal = cards.length - 1;
    for (var i = 0; i < 7; i++) {
      for (var j = i; j < 7; j++) {
        piles[j].acquireCard(cards[cardToDeal--]);
      }
      piles[i].flipTopCard();
    }
    for (int n = 0; n <= cardToDeal; n++) {
      stock.acquireCard(cards[n]);
    }
  }
}