import 'package:flutter/material.dart';
import 'package:oyun_accordion_solitaire/oyun_accordion_solitaire.dart';
import 'package:oyun_batak/oyun_batak.dart';
import 'package:oyun_bric_benzeri_whist/oyun_bric_benzeri_whist.dart';
import 'package:oyun_briscola/oyun_briscola.dart';
import 'package:oyun_canfield/oyun_canfield.dart';
import 'package:oyun_clock_solitaire/oyun_clock_solitaire.dart';
import 'package:oyun_forty_thieves/oyun_forty_thieves.dart';
import 'package:oyun_freecell/oyun_freecell.dart';
import 'package:oyun_golf_solitaire/oyun_golf_solitaire.dart';
import 'package:oyun_hearts/oyun_hearts.dart';
import 'package:oyun_king/oyun_king.dart';
import 'package:oyun_klondike_solitaire/oyun_klondike_solitaire.dart';
import 'package:oyun_oh_hell/oyun_oh_hell.dart';
import 'package:oyun_pyramid_solitaire/oyun_pyramid_solitaire.dart';
import 'package:oyun_scorpion_solitaire/oyun_scorpion_solitaire.dart';
import 'package:oyun_spades/oyun_spades.dart';
import 'package:oyun_spider_solitaire/oyun_spider_solitaire.dart';
import 'package:oyun_sueca/oyun_sueca.dart';
import 'package:oyun_tripeaks_solitaire/oyun_tripeaks_solitaire.dart';
import 'package:oyun_yukon_solitaire/oyun_yukon_solitaire.dart';
import 'package:studio_core/app/hub.dart';

/// Kart Oyunları: aynı ailedeki kart oyunlarını tek uygulamada toplar.
/// Her oyunun kaydı ve ilerlemesi ayrıdır.
final hubConfig = HubConfig(
  hubId: 'merkez-kart-oyunlari',
  title: const [
      'Kart Oyunları',
      'Card Games',
      'Kartenspiele',
      'Juegos de Cartas',
      'Jeux de Cartes',
      'ألعاب الورق',
      'بازی‌های کارتی',
      'משחקי קלפים',
      'تاش کے کھیل',
      'Карточные игры',
      'Карткові ігри',
      'Gry Karciane',
      'Karetní hry',
      'Jocuri de Cărți',
      'Kártyajátékok',
      'Παιχνίδια με Τράπουλα',
      'Giochi di Carte',
      'Jogos de Cartas',
      'Kaartspellen',
      'Kortspel',
      'Kortspil',
      'Kortspill',
      'Korttipelit',
      'カードゲーム',
      '카드 게임',
      '纸牌游戏',
      'ताश के खेल',
      'তাসের খেলা',
      'Permainan Kartu',
      'Permainan Kad',
      'เกมไพ่',
      'Trò Chơi Bài',
      'Mga Laro ng Baraha',
    ],
  tagline: const [
      'Sabır oyunları ve rakipli kart oyunları tek uygulamada',
      'Solitaire and card games against rivals in one app',
      'Patiencen und Kartenspiele gegen Gegner in einer App',
      'Solitarios y juegos de cartas contra rivales en una app',
      'Patiences et jeux de cartes contre des adversaires dans une app',
      'ألعاب الصبر وألعاب الورق ضد المنافسين في تطبيق واحد',
      'بازی‌های صبر و کارتی با حریف در یک برنامه',
      'סוליטר ומשחקי קלפים מול יריבים באפליקציה אחת',
      'ایک ایپ میں سولیٹیئر اور حریفوں کے ساتھ تاش',
      'Пасьянсы и карточные игры с соперниками в одном приложении',
      'Пасьянси й карткові ігри із суперниками в одному застосунку',
      'Pasjanse i gry karciane z rywalami w jednej aplikacji',
      'Solitéry a karetní hry se soupeři v jedné aplikaci',
      'Pasiențe și jocuri de cărți cu adversari într-o aplicație',
      'Pasziánszok és kártyajátékok ellenfelekkel egy alkalmazásban',
      'Πασιέντζες και παιχνίδια με αντιπάλους σε μία εφαρμογή',
      'Solitari e giochi di carte contro avversari in un\'unica app',
      'Paciências e jogos de cartas contra rivais num só app',
      'Patience en kaartspellen tegen tegenstanders in één app',
      'Patienser och kortspel mot motståndare i en app',
      'Kabaler og kortspil mod modstandere i én app',
      'Kabaler og kortspill mot motstandere i én app',
      'Pasianssit ja korttipelit vastustajia vastaan yhdessä sovelluksessa',
      'ソリティアと対戦カードゲームをひとつのアプリに',
      '솔리테어와 대전 카드 게임을 앱 하나에',
      '接龙与对战纸牌，一个应用全搞定',
      'एक ऐप में सॉलिटेयर और मुक़ाबले वाले ताश',
      'এক অ্যাপে সলিটেয়ার ও প্রতিপক্ষের সঙ্গে তাস',
      'Solitaire dan permainan kartu melawan lawan dalam satu aplikasi',
      'Solitaire dan permainan kad menentang lawan dalam satu aplikasi',
      'โซลิแทร์และเกมไพ่แข่งกับคู่แข่งในแอปเดียว',
      'Xếp bài và đánh bài với đối thủ trong một ứng dụng',
      'Solitaire at mga laro ng baraha laban sa kalaban sa iisang app',
    ],
  seedColor: const Color(0xFF2F7D5B),
  icon: Icons.style_rounded,
  games: [
    klondikeConfig,
    spiderConfig,
    freecellConfig,
    pyramidConfig,
    tripeaksConfig,
    golfConfig,
    yukonConfig,
    scorpionConfig,
    fortyConfig,
    canfieldConfig,
    accordionConfig,
    clockConfig,
    batakConfig,
    heartsConfig,
    spadesConfig,
    whistConfig,
    ohhellConfig,
    briscolaConfig,
    suecaConfig,
    kingConfig,
  ],
);

void main() => bootstrapHub(hubConfig);
