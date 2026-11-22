// Mağaza görselleri: gerçek oyun ekranlarını 33 dilde, başlıklı bir
// çerçeve içinde çizer ve ekran görüntüsü alır. Yalnızca store-shots iş
// akışında çalışır (flutter drive). Çıktıyı tool/crop_store.py kırpar.
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kart_motoru/kart_motoru.dart';
import 'package:merkez_kart_oyunlari/main.dart' as hub;
import 'package:studio_core/app/game_api.dart';
import 'package:studio_core/app/theme.dart';
import 'package:studio_core/app/widgets.dart';
import 'package:studio_core/core/game_rules.dart';
import 'package:studio_core/core/level_plan.dart';
import 'package:studio_core/core/rng.dart';
import 'package:studio_core/core/strings.dart';

import 'store_texts.dart';

class _Shot {
  final String gameId;
  final int level;
  final Map<String, Object?> Function(GeneratedLevel g) resume;
  const _Shot(this.gameId, this.level, this.resume);
}

Map<String, Object?> _none(GeneratedLevel g) => const {};

/// El alma: birkaç el oynanmış, sıra oyuncuda ve masada kart var.
Map<String, Object?> _midTrick(GeneratedLevel g) {
  final l = g.puzzle as TrickLevel;
  final s = l.start.copy();
  final r = SeededRandom(mixSeed([l.seed, 5]));
  var guard = 0;
  while (s.phase != TrickPhase.over && guard++ < 400) {
    if (s.phase == TrickPhase.bidding) {
      l.rules.applyBid(s, s.turn, l.rules.aiBid(s, s.turn, r));
      if (l.rules.biddingOver(s)) l.rules.finishBidding(s);
      continue;
    }
    if (s.winners.length >= 3 && s.turn == 0 && s.trick.isNotEmpty) break;
    l.rules.play(s, s.turn, TrickAI.quick(l.rules, s, s.turn, r));
  }
  return {'snap': s.serialize()};
}

Map<String, Object?> _midTrail(GeneratedLevel g) {
  final l = g.puzzle as TrailLevel;
  final t = TrailGame(l);
  for (final i in l.solution.take((l.size * 0.45).round())) {
    t.tap(i);
  }
  return {'snap': t.serialize(), 'secs': 74};
}

const _shots = [
  _Shot('oyun-klondike-solitaire', 37, _none),
  _Shot('oyun-batak', 420, _midTrick),
  _Shot('oyun-pisti', 88, _none),
  _Shot('oyun-tarok', 1200, _midTrick),
  _Shot('oyun-kart-yolu', 3000, _midTrail),
  _Shot('oyun-spider-solitaire', 500, _none),
];

Widget _app(String lang, Widget child) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildTheme(hub.hubConfig.seedColor, Brightness.light),
      locale: Locale(lang),
      supportedLocales: Strings.languages.map(Locale.new).toList(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: child,
    );

/// Oyun ekranı: oyunun kendi çizimi, üstte başlık çubuğu (oyun içindeki gibi).
Widget _gameScreen(GameConfig cfg, GeneratedLevel g, Map<String, Object?> resume, String lang) {
  final strings = Strings(lang);
  final ctx = PlayContext(
    spec: g.spec,
    generated: g,
    resume: resume,
    pieceColors: Palettes.skin(0),
    background: Palettes.theme(g.spec.theme),
    colorBlind: false,
    reducedMotion: true,
    leftHanded: false,
    lang: lang,
    t: strings.t,
    finish: (_) {},
    saveResume: (_) {},
    requestHint: () async => false,
    requestBooster: () async => false,
    requestContinue: () async => false,
    sfx: (_) {},
  );
  return Scaffold(
    appBar: AppBar(
      title: Text('${cfg.localized(cfg.title, lang)} · ${strings.t('level', {'n': g.spec.levelId})}',
          overflow: TextOverflow.ellipsis),
      leading: const Icon(Icons.pause_circle),
    ),
    body: ThemedBackground(colors: Palettes.theme(g.spec.theme), child: SafeArea(child: cfg.buildPlay(ctx))),
  );
}

/// Mağaza görseli: [box] mantıksal boyutunda, üstte başlık, ortada telefon
/// ya da tablet çerçevesinde oyun ekranı.
Widget _storeFrame({required Size box, required Size device, required String caption, required Widget screen, required bool rtl}) {
  final colors = Palettes.theme(3);
  return Directionality(
    textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
    child: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: box.width,
        height: box.height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [hub.hubConfig.seedColor, colors.last, colors.first],
            ),
          ),
          child: Column(children: [
            SizedBox(
              height: box.height * 0.16,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: box.width * 0.06),
                  child: Text(
                    caption,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: math.min(box.width, box.height) * 0.072,
                      height: 1.15,
                      shadows: const [Shadow(blurRadius: 8, color: Colors.black38)],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(box.width * 0.07, 0, box.width * 0.07, box.height * 0.035),
                child: FittedBox(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111318),
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: const [BoxShadow(blurRadius: 30, color: Colors.black45, offset: Offset(0, 10))],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: SizedBox(
                        width: device.width,
                        height: device.height,
                        child: MediaQuery(
                          data: MediaQueryData(size: device, devicePixelRatio: 2.5, padding: EdgeInsets.zero),
                          child: screen,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    ),
  );
}

class _FanPainter extends CustomPainter {
  const _FanPainter();

  @override
  void paint(Canvas c, Size size) {
    const style = CardStyle(backA: Color(0xFF2F7D5B), backB: Color(0xFF8FD3B6));
    final cards = [makeCard(1, kSpades), makeCard(13, kHearts), makeCard(12, kDiamonds), makeCard(11, kClubs), kTarotTrump + 21];
    final w = size.height * 0.5;
    for (var i = 0; i < cards.length; i++) {
      c.save();
      c.translate(size.width / 2, size.height * 0.92);
      c.rotate((i - 2) * 0.24);
      paintCard(c, Rect.fromLTWH(-w / 2, -w * 1.4 - size.height * 0.12, w, w * 1.4), cards[i], faceUp: true, style: style);
      c.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Öne çıkan görsel (512×250 mantıksal = 1024×500 piksel, oran 2).
Widget _feature(String lang) {
  final rtl = Strings(lang).rtl;
  final colors = Palettes.theme(3);
  return Directionality(
    textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
    child: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: 512,
        height: 250,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [hub.hubConfig.seedColor, colors.first]),
          ),
          child: Row(children: [
            const SizedBox(width: 210, height: 250, child: CustomPaint(painter: _FanPainter())),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 22),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(Strings.pick(hub.hubConfig.title, lang),
                      maxLines: 1,
                      style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Text(Strings.pick(hub.hubConfig.tagline, lang),
                      maxLines: 3,
                      style: const TextStyle(color: Color(0xEEFFFFFF), fontSize: 17, fontWeight: FontWeight.w600, height: 1.2)),
                ]),
              ),
            ),
          ]),
        ),
      ),
    ),
  );
}

/// Görüntü, ekran boyutundan bağımsız olarak [RepaintBoundary] ile çizilir;
/// böylece telefon ve tablet görselleri tek bir öykünücüde üretilir.
final _shotKey = GlobalKey();

Widget _offscreen(Size size, Widget child) => OverflowBox(
      alignment: Alignment.topLeft,
      minWidth: 0,
      minHeight: 0,
      maxWidth: double.infinity,
      maxHeight: double.infinity,
      child: RepaintBoundary(key: _shotKey, child: SizedBox(width: size.width, height: size.height, child: child)),
    );

/// Görseli uygulamanın geçici klasörüne yazar; iş akışı adb ile çeker.
Future<void> _capture(WidgetTester tester, double pixelRatio, String name) async {
  final boundary = _shotKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    final f = File('${Directory.systemTemp.path}/shots/$name.png');
    f.createSync(recursive: true);
    f.writeAsBytesSync(data!.buffer.asUint8List());
  });
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('mağaza görselleri', (tester) async {
    await tester.pumpAndSettle();
    // Telefon 1080×1920 (9:16), tablet 1920×1080 (16:9), öne çıkan 1024×500.
    const phoneBox = Size(360, 640), tabletBox = Size(1280, 720);
    const only = String.fromEnvironment('LANGS');
    final langs = only.isEmpty ? Strings.languages : only.split(',');
    final games = {for (final g in hub.hubConfig.allGames) g.gameId: g};
    final built = <String, GeneratedLevel>{};
    var count = 0;
    for (final lang in langs) {
      final li = Strings.languages.indexOf(lang);
      for (final tablet in [false, true]) {
        final box = tablet ? tabletBox : phoneBox;
        final device = tablet ? const Size(1000, 620) : const Size(400, 800);
        for (var k = 0; k < _shots.length; k++) {
          final shot = _shots[k];
          final cfg = games[shot.gameId]!;
          final g = built.putIfAbsent(shot.gameId,
              () => cfg.rules.build(LevelPlanner(gameId: cfg.gameId, optionalMechanics: cfg.rules.optionalMechanics).spec(shot.level)));
          await tester.pumpWidget(_app(
            lang,
            _offscreen(
              box,
              _storeFrame(
                box: box,
                device: device,
                caption: storeCaptions[k][li],
                rtl: Strings(lang).rtl,
                screen: _gameScreen(cfg, g, shot.resume(g), lang),
              ),
            ),
          ));
          for (var i = 0; i < 8; i++) {
            await tester.pump(const Duration(milliseconds: 150));
          }
          await _capture(tester, tablet ? 1.5 : 3, '${tablet ? 'tablet' : 'phone'}_${lang}_${k + 1}');
          count++;
        }
      }
      await tester.pumpWidget(_app(lang, _offscreen(const Size(512, 250), _feature(lang))));
      await tester.pump(const Duration(milliseconds: 300));
      await _capture(tester, 2, 'feature_$lang');
      count++;
      // Bir sonraki dil için oyun ekranlarını temizle (zamanlayıcılar dursun).
      await tester.pumpWidget(const SizedBox());
    }
    binding.reportData = {'count': count};
  }, timeout: const Timeout(Duration(minutes: 30)));
}
