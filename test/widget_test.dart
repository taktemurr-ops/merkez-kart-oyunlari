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
      'oyun-batak',
      'oyun-hearts',
      'oyun-spades',
      'oyun-bric-benzeri-whist',
      'oyun-oh-hell',
      'oyun-briscola',
      'oyun-sueca',
      'oyun-king',
      'oyun-pisti',
      'oyun-scopa',
      'oyun-toplam-al',
      'oyun-renk-esle-kart-oyunu',
      'oyun-savas',
      'oyun-baskan',
      'oyun-papaz-kacti',
      'oyun-balik-tut',
      'oyun-blof',
      'oyun-31',
      'oyun-kart-hafiza',
      'oyun-euchre',
      'oyun-belot',
      'oyun-klaverjas',
      'oyun-jass',
      'oyun-pinokl',
      'oyun-skat',
      'oyun-koyun-basi',
      'oyun-kontrat-bric',
      'oyun-bezik',
      'oyun-gin-remi',
      'oyun-kart-remi',
      'oyun-konken',
      'oyun-asamali-remi',
      'oyun-kanasta',
      'oyun-el-ve-ayak',
      'oyun-cribbage',
      'oyun-durak',
      'oyun-snap',
      'oyun-hiz',
      'oyun-nertz',
      'oyun-kemps',
    ]);
    expect(all.length, ids.length + 105);
    expect(all.toSet().length, all.length);
    expect(ids.toSet().length, ids.length);
    for (final g in hubConfig.allGames) {
      expect(g.rules.gameId, g.gameId, reason: 'kayıt öneki oyun kimliğiyle aynı olmalı');
    }
  });
}
