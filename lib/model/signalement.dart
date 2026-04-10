// ============================================================
//  AlertCitoyen — Modèle Signalement
//  Fichier : lib/core/models/signalement.dart
// ============================================================

import 'package:flutter/material.dart';

// ─────────────────────────────────────────
//  ENUM STATUT
// ─────────────────────────────────────────

enum SignalementStatus { inProgress, resolved, pending }

extension SignalementStatusX on SignalementStatus {
  String get label => switch (this) {
    SignalementStatus.inProgress => 'En cours',
    SignalementStatus.resolved   => 'Traité',
    SignalementStatus.pending    => 'En attente',
  };

  Color get bgColor => switch (this) {
    SignalementStatus.inProgress => const Color(0xFFFFF4EC),
    SignalementStatus.resolved   => const Color(0xFFEAFAF3),
    SignalementStatus.pending    => const Color(0xFFFEF3F2),
  };

  Color get textColor => switch (this) {
    SignalementStatus.inProgress => const Color(0xFFE8832A),
    SignalementStatus.resolved   => const Color(0xFF1A7A4A),
    SignalementStatus.pending    => const Color(0xFFC0392B),
  };
}

// ─────────────────────────────────────────
//  MODÈLE
// ─────────────────────────────────────────

class Signalement {
  final String            emoji;
  final Color             emojiBg;
  final String            title;
  final String            ref;
  final String            time;
  final SignalementStatus status;

  const Signalement({
    required this.emoji,
    required this.emojiBg,
    required this.title,
    required this.ref,
    required this.time,
    required this.status,
  });
}

// ─────────────────────────────────────────
//  DONNÉES STATIQUES DE DÉMONSTRATION
// ─────────────────────────────────────────

const kSignalements = [
  Signalement(
    emoji:   '🚗',
    emojiBg: Color(0xFFFEF3F2),
    title:   'Accident de la route',
    ref:     'SIG-2026-00089',
    time:    'il y a 2h',
    status:  SignalementStatus.inProgress,
  ),
  Signalement(
    emoji:   '⚠️',
    emojiBg: Color(0xFFF2EDE8),
    title:   'Trouble de voisinage',
    ref:     'SIG-2026-00071',
    time:    'hier',
    status:  SignalementStatus.resolved,
  ),
  Signalement(
    emoji:   '🔥',
    emojiBg: Color(0xFFFEF3F2),
    title:   'Incendie — Marché Sandaga',
    ref:     'SIG-2026-00054',
    time:    'il y a 3j',
    status:  SignalementStatus.resolved,
  ),
  Signalement(
    emoji:   '🏥',
    emojiBg: Color(0xFFEAF1FB),
    title:   'Urgence médicale',
    ref:     'SIG-2026-00038',
    time:    'il y a 5j',
    status:  SignalementStatus.pending,
  ),
  Signalement(
    emoji:   '🔧',
    emojiBg: Color(0xFFF2EDE8),
    title:   'Voirie — Rue Moussé',
    ref:     'SIG-2026-00021',
    time:    'il y a 8j',
    status:  SignalementStatus.resolved,
  ),
];