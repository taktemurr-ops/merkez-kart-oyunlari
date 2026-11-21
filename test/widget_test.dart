import 'package:flutter_test/flutter_test.dart';
import 'package:merkez_kart_oyunlari/main.dart';

void main() {
  test('merkezde oyunlar benzersiz kimlikle yer alıyor', () {
    final ids = hubConfig.games.map((g) => g.gameId).toList();
    final all = hubConfig.allGames.map((g) => g.gameId).toList();
    expect(ids, [
      'oyun-klondike-solitaire',
      'oyun-spider-solitaire',
      'oyun-freecell',
      'oyun-pyramid-solitaire',
      'oyun-tripeaks-solitaire',
      'oyun-golf-solitaire',
      'oyun-yukon-solitaire',
      'oyun-scorpion-solitaire',
      'oyun-forty-thieves',
      'oyun-canfield',
      'oyun-accordion-solitaire',
      'oyun-clock-solitaire',
    ]);
    expect(all.length, ids.length);
    expect(all.toSet().length, all.length);
    expect(ids.toSet().length, ids.length);
    for (final g in hubConfig.allGames) {
      expect(g.rules.gameId, g.gameId, reason: 'kayıt öneki oyun kimliğiyle aynı olmalı');
    }
  });
}
