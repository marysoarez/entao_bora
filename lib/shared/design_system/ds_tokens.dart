import 'package:flutter/material.dart';

class DsColors {
  DsColors._();

  static const primary = Color(0xFF1F1F1F);
  static const accent = Color(0xFFD64545);
  static const success = Color(0xFF2E7D32);
  static const warning = Color(0xFFFFC107);

  static const adminBackground = Color(0xFFF7F6F3);
  static const adminSurface = Colors.white;
  static const adminText = Color(0xFF222222);
  static const adminTextMuted = Color(0xFF6B6B6B);
  static const adminDivider = Color(0xFFE5E5E5);

  static const publicBackground = Colors.black;
  static const publicSurface = Color(0xFF161616);
  static const publicSheet = Color(0xFF111111);
  static const publicText = Colors.white;
  static const publicTextMuted = Colors.white70;
  static const publicTextSubtle = Colors.white54;
  static const publicOverlay = Colors.black54;
}

class DsSpacing {
  DsSpacing._();

  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 20.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const section = 36.0;
}

class DsRadius {
  DsRadius._();

  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 14.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const pill = 100.0;
}

class DsSizes {
  DsSizes._();

  static const iconButton = 42.0;
  static const listImage = 112.0;
  static const menuImage = 86.0;
  static const heroHeight = 320.0;
  static const eventHeroHeight = 360.0;
  static const maxContentWidth = 1200.0;
  static const maxFormWidth = 1100.0;
}

class DsTextStyles {
  DsTextStyles._();

  static const publicTitle = TextStyle(
    color: DsColors.publicText,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const publicBody = TextStyle(
    color: DsColors.publicTextMuted,
    height: 1.5,
  );

  static const publicPrice = TextStyle(
    color: DsColors.warning,
    fontWeight: FontWeight.w800,
  );
}
