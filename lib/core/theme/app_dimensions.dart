import 'package:flutter/material.dart';
import 'app_colors.dart';


class AppSpacing {
  AppSpacing._();

  static const double xs   =  4.0;
  static const double sm   =  8.0;
  static const double md   = 12.0;
  static const double lg   = 16.0;
  static const double xl   = 20.0;
  static const double xxl  = 24.0;
  static const double xxxl = 32.0;

  // Padding horizontal des pages
  static const double pagePadding  = 20.0;

  // Padding interne des cards
  static const double cardPadding  = 14.0;
}


// ─────────────────────────────────────────
//  BORDER RADIUS
// ─────────────────────────────────────────

class AppRadius {
  AppRadius._();

  static const double sm   =  8.0;
  static const double md   = 12.0;
  static const double lg   = 16.0;
  static const double xl   = 20.0;
  static const double pill = 99.0;

  static const BorderRadius card  = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius input = BorderRadius.all(Radius.circular(md));
  static const BorderRadius btn   = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius chip  = BorderRadius.all(Radius.circular(pill));
}


// ─────────────────────────────────────────
//  OMBRES
// ─────────────────────────────────────────

class AppShadows {
  AppShadows._();

  // Ombre douce sur les cards
  static const List<BoxShadow> card = [
    BoxShadow(
      color:       Color(0x0A2C2420),
      blurRadius:  12,
      offset:      Offset(0, 4),
    ),
  ];

  // Ombre sur le bouton principal rouge
  static const List<BoxShadow> primaryBtn = [
    BoxShadow(
      color:       Color(0x40C0392B),
      blurRadius:  16,
      offset:      Offset(0, 6),
    ),
  ];
}