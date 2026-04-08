// ============================================================
//  AlertCitoyen — Responsivité
//  Fichier : lib/core/responsive/app_responsive.dart
//
//  Stratégie : l'app est mobile-first.
//  On gère les différences entre petits phones (SE, A14)
//  et grands phones (Pro Max, S24 Ultra) + tablettes.
// ============================================================

import 'package:flutter/material.dart';

// ─────────────────────────────────────────
//  BREAKPOINTS
// ─────────────────────────────────────────

class AppBreakpoints {
  AppBreakpoints._();

  // Largeurs (logical pixels)
  static const double smallPhone  = 360.0; // iPhone SE, Galaxy A14
  static const double normalPhone = 390.0; // iPhone 14, Pixel 7
  static const double largePhone  = 428.0; // iPhone Pro Max, S24+
  static const double tablet      = 600.0; // tablettes

  // Hauteurs (pour gérer les écrans courts)
  static const double shortScreen = 700.0; // iPhone SE (hauteur)
  static const double tallScreen  = 844.0; // iPhone 14 (hauteur)
}


// ─────────────────────────────────────────
//  CLASSE PRINCIPALE — AppResponsive
// ─────────────────────────────────────────

class AppResponsive {
  final BuildContext _context;
  late final MediaQueryData _mq;

  AppResponsive(this._context) {
    _mq = MediaQuery.of(_context);
  }

  // ── Dimensions écran ──────────────────
  double get screenWidth   => _mq.size.width;
  double get screenHeight  => _mq.size.height;

  // ── Zones système ─────────────────────
  double get statusBarH    => _mq.padding.top;
  double get bottomSafeH  => _mq.padding.bottom;
  double get keyboardH    => _mq.viewInsets.bottom;

  // ── Type d'écran ──────────────────────
  bool get isSmallPhone  => screenWidth < AppBreakpoints.smallPhone;
  bool get isNormalPhone => screenWidth >= AppBreakpoints.smallPhone
      && screenWidth < AppBreakpoints.largePhone;
  bool get isLargePhone  => screenWidth >= AppBreakpoints.largePhone
      && screenWidth < AppBreakpoints.tablet;
  bool get isTablet      => screenWidth >= AppBreakpoints.tablet;

  // ── Hauteur d'écran ───────────────────
  bool get isShortScreen => screenHeight < AppBreakpoints.shortScreen;
  bool get isTallScreen  => screenHeight >= AppBreakpoints.tallScreen;

  // ─────────────────────────────────────
  //  HELPERS TEXTE
  //  Retourne une taille selon l'écran
  // ─────────────────────────────────────

  double fontSize({
    required double small,   // iPhone SE / petit écran
    required double normal,  // iPhone 14 / taille standard
    double? large,           // iPhone Pro Max / grand écran
  }) {
    if (isSmallPhone) return small;
    if (isLargePhone || isTablet) return large ?? normal + 2;
    return normal;
  }

  // ─────────────────────────────────────
  //  HELPERS ESPACEMENT
  // ─────────────────────────────────────

  double spacing({
    required double small,
    required double normal,
    double? large,
  }) {
    if (isSmallPhone) return small;
    if (isLargePhone || isTablet) return large ?? normal + 4;
    return normal;
  }

  // ── Padding horizontal de la page ─────
  double get pagePadding => spacing(small: 16, normal: 20, large: 24);

  // ── Padding vertical du hero ──────────
  double get heroPaddingTop => spacing(small: 16, normal: 22, large: 28);

  // ── Hauteur bouton principal ──────────
  double get primaryBtnHeight => spacing(small: 48, normal: 54, large: 58);

  // ── Taille du hero title ──────────────
  double get heroFontSize => fontSize(small: 26, normal: 32, large: 36);

  // ── Taille du screen title (header) ───
  double get screenTitleSize => fontSize(small: 18, normal: 22, large: 24);

  // ── Rayon des cards ───────────────────
  double get cardRadius => isSmallPhone ? 14.0 : 16.0;

  // ── Hauteur du header rouge ───────────
  double get headerHeight => spacing(small: 160, normal: 190, large: 210);

  // ── Taille icône type d'incident ──────
  double get incidentIconSize => isSmallPhone ? 22.0 : 26.0;
}


// ─────────────────────────────────────────
//  EXTENSION PRATIQUE SUR BUILDCONTEXT
//  Usage : context.responsive.pagePadding
// ─────────────────────────────────────────

extension ResponsiveExtension on BuildContext {
  AppResponsive get responsive => AppResponsive(this);

  // Raccourcis directs souvent utilisés
  double get screenWidth  => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  double get bottomSafe   => MediaQuery.of(this).padding.bottom;
  double get topSafe      => MediaQuery.of(this).padding.top;
  bool   get isTablet     => MediaQuery.of(this).size.width >= AppBreakpoints.tablet;
}


// ─────────────────────────────────────────
//  WIDGET HELPER — ResponsiveBuilder
//  Usage : afficher un widget différent
//  selon la taille de l'écran
// ─────────────────────────────────────────

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, AppResponsive r) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return builder(context, AppResponsive(context));
  }
}