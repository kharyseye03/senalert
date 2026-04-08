// ============================================================
//  AlertCitoyen — Couleurs
//  Fichier : lib/core/theme/app_colors.dart
// ============================================================

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Primaire (rouge institutionnel) ──────────────
  static const Color primary       = Color(0xFFC0392B);
  static const Color primaryLight  = Color(0xFFFEF3F2);
  static const Color primaryDark   = Color(0xFF962D22);

  // ── Succès ──────────────────────────────────────
  static const Color success       = Color(0xFF1A7A4A);
  static const Color successLight  = Color(0xFFE6F5EE);

  // ── Avertissement ───────────────────────────────
  static const Color warning       = Color(0xFFF4A261);
  static const Color warningLight  = Color(0xFFFFF4EC);

  // ── Info (bleu header) ──────────────────────────
  static const Color info          = Color(0xFF1A56A0);
  static const Color infoLight     = Color(0xFFEAF1FB);

  // ── Fonds ───────────────────────────────────────
  static const Color background    = Color(0xFFF2EDE8); // beige chaud
  static const Color surface       = Color(0xFFFDFCFB); // blanc cassé
  static const Color surfaceAlt    = Color(0xFFEDE8E2); // fond inputs

  // ── Cercles décoratifs ──────────────────────────
  static const Color deco1         = Color(0xFFEDE8E2);
  static const Color deco2         = Color(0xFFE5DED6);
  static const Color deco3         = Color(0xFFDDD6CC);

  // ── Cercles déco sur fond rouge ─────────────────
  static const Color decoOnRed1    = Color(0x1AFFFFFF); // 10%
  static const Color decoOnRed2    = Color(0x14FFFFFF); // 8%
  static const Color decoOnRed3    = Color(0x0FFFFFFF); // 6%

  // ── Textes ──────────────────────────────────────
  static const Color textPrimary   = Color(0xFF2C2420);
  static const Color textSecondary = Color(0xFF7A6E68);
  static const Color textHint      = Color(0xFFB0A89E);
  static const Color textDisabled  = Color(0xFFC8C0B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Bordures ────────────────────────────────────
  static const Color border        = Color(0xFFEAEDF2);
  static const Color borderFocus   = Color(0xFFC0392B);
}