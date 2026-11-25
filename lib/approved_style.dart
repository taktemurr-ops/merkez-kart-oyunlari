import 'package:flutter/material.dart';
import 'package:studio_core/app/approved_hub.dart';

/// Onaylı tasarım (Oyun Merkezleri · Tasarım Örnekleri).
const approvedStyle = ApprovedHubStyle(
  background: [Color(0xFF7A1424), Color(0xFF4A0E1C), Color(0xFF240814)],
  accent: Color(0xFFF5B82E),
  card: Color(0xFF8E1A2C),
  play: Color(0xFFF5A524),
  number: Color(0xFFFFC93C),
  heroAsset: 'assets/approved/hero.png',
  blocks: [ApprovedBlock.search, ApprovedBlock.featured, ApprovedBlock.categories],
  featuredKey: 'featured',
  featured: ['oyun-klondike-solitaire', 'oyun-batak', 'oyun-pisti'],
  tileArt: {
    'oyun-klondike-solitaire': 'assets/approved/tile_solitaire.png',
    'oyun-batak': 'assets/approved/tile_spade.png',
  },
);
