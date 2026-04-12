// ============================================================
//  AlertCitoyen — Modèle SignalementPolice
//  Fichier : lib/core/models/signalement_police.dart
// ============================================================

import 'package:flutter/material.dart';

enum PrioritePolice { urgent, normal }
enum StatutPolice   { aTraiter, enCours, valide, rejete }

extension PrioritePoliceX on PrioritePolice {
  String get label => switch (this) {
    PrioritePolice.urgent => '🚨 Urgent',
    PrioritePolice.normal => 'En cours',
  };

  Color get bgColor => switch (this) {
    PrioritePolice.urgent => const Color(0xFFFEF3F2),
    PrioritePolice.normal => const Color(0xFFFFF4EC),
  };

  Color get textColor => switch (this) {
    PrioritePolice.urgent => const Color(0xFFC0392B),
    PrioritePolice.normal => const Color(0xFFE8832A),
  };
}

extension StatutPoliceX on StatutPolice {
  String get label => switch (this) {
    StatutPolice.aTraiter => 'À traiter',
    StatutPolice.enCours  => 'En cours',
    StatutPolice.valide   => 'Validé ✓',
    StatutPolice.rejete   => 'Rejeté',
  };

  Color get bgColor => switch (this) {
    StatutPolice.aTraiter => const Color(0xFFFFF4EC),
    StatutPolice.enCours  => const Color(0xFFEAF1FB),
    StatutPolice.valide   => const Color(0xFFE6F5EE),
    StatutPolice.rejete   => const Color(0xFFFEF3F2),
  };

  Color get textColor => switch (this) {
    StatutPolice.aTraiter => const Color(0xFFE8832A),
    StatutPolice.enCours  => const Color(0xFF1A56A0),
    StatutPolice.valide   => const Color(0xFF1A7A4A),
    StatutPolice.rejete   => const Color(0xFFC0392B),
  };
}

class SignalementPolice {
  final String         emoji;
  final Color          emojiBg;
  final String         title;
  final String         ref;
  final String         time;
  final String         zone;
  final PrioritePolice priorite;
  final StatutPolice   statut;
  final int            etape;      // étape actuelle
  final int            totalEtapes;

  const SignalementPolice({
    required this.emoji,
    required this.emojiBg,
    required this.title,
    required this.ref,
    required this.time,
    required this.zone,
    required this.priorite,
    required this.statut,
    this.etape       = 1,
    this.totalEtapes = 4,
  });
}

// ─────────────────────────────────────────
//  DONNÉES STATIQUES
// ─────────────────────────────────────────

final kSignalementsPolice = [
  const SignalementPolice(
    emoji:    '🔥',
    emojiBg:  Color(0xFFFEF3F2),
    title:    'Incendie — Marché Sandaga',
    ref:      'SIG-2026-00089',
    time:     '12 min',
    zone:     'Plateau',
    priorite: PrioritePolice.urgent,
    statut:   StatutPolice.aTraiter,
    etape:    1,
  ),
  const SignalementPolice(
    emoji:    '🚗',
    emojiBg:  Color(0xFFF2EDE8),
    title:    'Accident de la route',
    ref:      'SIG-2026-00071',
    time:     '45 min',
    zone:     'Médina',
    priorite: PrioritePolice.normal,
    statut:   StatutPolice.enCours,
    etape:    2,
  ),
  const SignalementPolice(
    emoji:    '⚠️',
    emojiBg:  Color(0xFFEAF1FB),
    title:    'Trouble de voisinage',
    ref:      'SIG-2026-00054',
    time:     '2h',
    zone:     'Fann',
    priorite: PrioritePolice.normal,
    statut:   StatutPolice.valide,
    etape:    4,
  ),
  const SignalementPolice(
    emoji:    '🏥',
    emojiBg:  Color(0xFFE6F5EE),
    title:    'Urgence médicale',
    ref:      'SIG-2026-00038',
    time:     '3h',
    zone:     'Plateau',
    priorite: PrioritePolice.urgent,
    statut:   StatutPolice.valide,
    etape:    4,
  ),
];