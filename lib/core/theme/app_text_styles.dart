import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ── DM Serif Display — Titres ────────────────────

  // Héros principal (Splash, Onboarding, Portail)
  static const TextStyle heroTitle = TextStyle(
    fontFamily:    'DMSerifDisplay',
    fontSize:      32,
    fontWeight:    FontWeight.w400,
    color:         AppColors.textPrimary,
    height:        1.2,
    letterSpacing: -0.3,
  );

  // Titre écran (header rouge formulaire, confirmation)
  static const TextStyle screenTitle = TextStyle(
    fontFamily:    'DMSerifDisplay',
    fontSize:      22,
    fontWeight:    FontWeight.w400,
    color:         AppColors.textOnPrimary,
    height:        1.25,
  );

  // Titre card / section
  static const TextStyle cardTitle = TextStyle(
    fontFamily:    'DMSerifDisplay',
    fontSize:      18,
    fontWeight:    FontWeight.w400,
    color:         AppColors.textPrimary,
    height:        1.3,
  );

  // ── DM Sans — Corps ─────────────────────────────

  // Label bouton principal
  static const TextStyle buttonLabel = TextStyle(
    fontFamily:    'DMSans',
    fontSize:      15,
    fontWeight:    FontWeight.w600,
    color:         AppColors.textOnPrimary,
    letterSpacing: 0.1,
  );

  // Corps standard
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'DMSans',
    fontSize:   14,
    fontWeight: FontWeight.w400,
    color:      AppColors.textPrimary,
    height:     1.55,
  );

  // Corps semi-bold (nom card, champ rempli)
  static const TextStyle bodySemiBold = TextStyle(
    fontFamily: 'DMSans',
    fontSize:   14,
    fontWeight: FontWeight.w500,
    color:      AppColors.textPrimary,
  );

  // Texte secondaire / meta / timestamp
  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'DMSans',
    fontSize:   12,
    fontWeight: FontWeight.w400,
    color:      AppColors.textHint,
    height:     1.4,
  );

  // Label de section (ex: "TYPE D'INCIDENT")
  static const TextStyle sectionLabel = TextStyle(
    fontFamily:    'DMSans',
    fontSize:      10,
    fontWeight:    FontWeight.w500,
    color:         AppColors.textHint,
    letterSpacing: 0.9,
  );

  // Numéro de référence dossier
  static const TextStyle refNumber = TextStyle(
    fontFamily:    'DMSans',
    fontSize:      20,
    fontWeight:    FontWeight.w600,
    color:         AppColors.primary,
    letterSpacing: 1.2,
  );

  // Pill / badge statut
  static const TextStyle badge = TextStyle(
    fontFamily:    'DMSans',
    fontSize:      11,
    fontWeight:    FontWeight.w500,
    letterSpacing: 0.1,
  );

  // Texte descriptif onboarding
  static const TextStyle onboardingBody = TextStyle(
    fontFamily: 'DMSans',
    fontSize:   15,
    fontWeight: FontWeight.w400,
    color:      AppColors.textSecondary,
    height:     1.6,
  );

  // Salutation (ex: "Bonjour, Moussa 👋")
  static const TextStyle greeting = TextStyle(
    fontFamily:    'DMSans',
    fontSize:      13,
    fontWeight:    FontWeight.w400,
    color:         AppColors.textHint,
    letterSpacing: 0.2,
  );
}