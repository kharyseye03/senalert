// ============================================================
//  AlertCitoyen — Confirmation de signalement
//  Fichier : lib/features/report/confirmation_screen.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/responsive/app_responsive.dart';

class ConfirmationScreen extends StatelessWidget {
  final String refNumber;
  const ConfirmationScreen({super.key, required this.refNumber});

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header rouge
          _ConfirmHeader(r: r),

          // Contenu scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: r.pagePadding),
              child: Column(
                children: [
                  SizedBox(height: r.spacing(small: 14, normal: 18, large: 22)),

                  // Titre + sous-titre
                  Text(
                    'Signalement\ntransmis !',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heroTitle.copyWith(fontSize: r.heroFontSize - 2),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Reçu par les services compétents.\nVous serez notifié à chaque étape.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.onboardingBody,
                  ),

                  SizedBox(height: r.spacing(small: 18, normal: 22, large: 28)),

                  // Numéro de référence
                  _RefCard(refNumber: refNumber),

                  SizedBox(height: r.spacing(small: 16, normal: 20, large: 24)),

                  // Timeline
                  const _TimelineCard(),

                  SizedBox(height: r.spacing(small: 24, normal: 30, large: 38)),

                  // Bouton retour accueil
                  SizedBox(
                    width:  double.infinity,
                    height: r.primaryBtnHeight,
                    child: OutlinedButton(
                      onPressed: () => context.goNamed('portal'),
                      child: Text(
                        'Retour à l\'accueil',
                        style: AppTextStyles.buttonLabel.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ),

                  // Bouton suivre ce dossier
                  const SizedBox(height: AppSpacing.md),
                  TextButton(
                    onPressed: () => context.goNamed('tracking'),
                    child: Text(
                      'Suivre ce signalement →',
                      style: AppTextStyles.bodySemiBold.copyWith(color: AppColors.primary),
                    ),
                  ),

                  SizedBox(height: r.spacing(small: 24, normal: 32, large: 40)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  HEADER
// ─────────────────────────────────────────

class _ConfirmHeader extends StatelessWidget {
  final AppResponsive r;
  const _ConfirmHeader({required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: r.spacing(small: 80, normal: 90, large: 100),
          child: Center(
            child: Container(
              width:      60,
              height:     60,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, color: AppColors.success, size: 32),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  CARTE RÉFÉRENCE
// ─────────────────────────────────────────

class _RefCard extends StatelessWidget {
  final String refNumber;
  const _RefCard({required this.refNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:      double.infinity,
      padding:    const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical:   AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: AppRadius.card,
        border:       Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            'RÉFÉRENCE DU DOSSIER',
            style: AppTextStyles.sectionLabel,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(refNumber, style: AppTextStyles.refNumber),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  TIMELINE
// ─────────────────────────────────────────

class _TimelineCard extends StatelessWidget {
  const _TimelineCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width:      double.infinity,
      padding:    const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: AppRadius.card,
        border:       Border.all(color: AppColors.border),
      ),
      child: const Column(
        children: [
          _TimelineRow(label: 'Signalement reçu',       sub: 'À l\'instant', status: _TLStatus.done),
          _TimelineRow(label: 'En cours de traitement',  sub: 'Pris en charge', status: _TLStatus.active),
          _TimelineRow(label: 'Intervention en route',   sub: 'En attente', status: _TLStatus.idle),
          _TimelineRow(label: 'Résolu',                  sub: 'En attente', status: _TLStatus.idle, isLast: true),
        ],
      ),
    );
  }
}

enum _TLStatus { done, active, idle }

class _TimelineRow extends StatelessWidget {
  final String    label;
  final String    sub;
  final _TLStatus status;
  final bool      isLast;

  const _TimelineRow({
    required this.label,
    required this.sub,
    required this.status,
    this.isLast = false,
  });

  Color get _dotColor => switch (status) {
    _TLStatus.done   => AppColors.success,
    _TLStatus.active => AppColors.primary,
    _TLStatus.idle   => AppColors.border,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dot + ligne
        Column(
          children: [
            Container(
              width:      10,
              height:     10,
              margin:     const EdgeInsets.only(top: 3),
              decoration: BoxDecoration(color: _dotColor, shape: BoxShape.circle),
            ),
            if (!isLast)
              Container(width: 1.5, height: 32, color: AppColors.border),
          ],
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodySemiBold.copyWith(
                    color: status == _TLStatus.idle ? AppColors.textHint : AppColors.textPrimary,
                    fontWeight: status == _TLStatus.idle ? FontWeight.w400 : FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(sub, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ),
      ],
    );
  }
}