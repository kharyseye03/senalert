import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_dimensions.dart';
import '../core/theme/app_text_styles.dart';
import '../model/signalement.dart';

class SignalementCard extends StatelessWidget {
  final String            emoji;
  final Color             emojiBg;
  final String            title;
  final String            ref;
  final String            time;
  final SignalementStatus status;

  const SignalementCard({
    super.key,
    required this.emoji,
    required this.emojiBg,
    required this.title,
    required this.ref,
    required this.time,
    required this.status,
  });

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context:            context,
      isScrollControlled: true,
      backgroundColor:    Colors.transparent,
      builder:            (_) => _DetailsSheet(
        emoji:  emoji,
        title:  title,
        ref:    ref,
        time:   time,
        status: status,
      ),
    );
  }

  void _showSuivi(BuildContext context) {
    showModalBottomSheet(
      context:            context,
      isScrollControlled: true,
      backgroundColor:    Colors.transparent,
      builder:            (_) => _SuiviSheet(
        title:  title,
        ref:    ref,
        status: status,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:     const EdgeInsets.only(bottom: AppSpacing.sm),
      padding:    const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: AppRadius.card,
        border:       Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // En-tête
          Row(
            children: [
              Container(
                width:      38,
                height:     38,
                decoration: BoxDecoration(
                  color:        emojiBg,
                  borderRadius: AppRadius.input,
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 17)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:    AppTextStyles.bodySemiBold.copyWith(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$ref · $time',
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 9),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical:   AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color:        status.bgColor,
                  borderRadius: AppRadius.chip,
                ),
                child: Text(
                  status.label,
                  style: AppTextStyles.badge.copyWith(color: status.textColor),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Boutons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showDetails(context),
                  style: OutlinedButton.styleFrom(
                    padding:         const EdgeInsets.symmetric(vertical: 8),
                    minimumSize:     Size.zero,
                    side:            const BorderSide(color: AppColors.border),
                    foregroundColor: AppColors.textSecondary,
                    shape:           RoundedRectangleBorder(borderRadius: AppRadius.input),
                  ),
                  icon:  const Icon(Icons.info_outline_rounded, size: 13),
                  label: Text(
                    'Détails',
                    style: AppTextStyles.badge.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showSuivi(context),
                  style: ElevatedButton.styleFrom(
                    padding:         const EdgeInsets.symmetric(vertical: 8),
                    minimumSize:     Size.zero,
                    backgroundColor: AppColors.textPrimary,
                    foregroundColor: AppColors.textOnPrimary,
                    elevation:       0,
                    shape:           RoundedRectangleBorder(borderRadius: AppRadius.input),
                  ),
                  icon:  const Icon(Icons.remove_red_eye_outlined, size: 13),
                  label: Text(
                    'Suivre',
                    style: AppTextStyles.badge.copyWith(color: AppColors.textOnPrimary),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  BOTTOMSHEET — Détails
// ─────────────────────────────────────────

class _DetailsSheet extends StatelessWidget {
  final String            emoji;
  final String            title;
  final String            ref;
  final String            time;
  final SignalementStatus status;

  const _DetailsSheet({
    required this.emoji,
    required this.title,
    required this.ref,
    required this.time,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              margin:     const EdgeInsets.only(top: AppSpacing.md),
              width:      38,
              height:     4,
              decoration: BoxDecoration(
                color:        AppColors.border,
                borderRadius: AppRadius.chip,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Titre
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.cardTitle),
                      const SizedBox(height: 3),
                      Text(ref, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical:   AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color:        status.bgColor,
                    borderRadius: AppRadius.chip,
                  ),
                  child: Text(
                    status.label,
                    style: AppTextStyles.badge.copyWith(color: status.textColor),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: AppSpacing.lg),

          // Infos
          _DetailRow(
            icon:  Icons.access_time_rounded,
            label: 'Date',
            value: time,
          ),
          const _DetailRow(
            icon:  Icons.location_on_rounded,
            label: 'Localisation',
            value: 'Plateau, Dakar',
          ),
          const _DetailRow(
            icon:  Icons.person_outline_rounded,
            label: 'Déclarant',
            value: 'Anonyme',
          ),
          const _DetailRow(
            icon:  Icons.description_outlined,
            label: 'Description',
            value: 'Aucune description fournie.',
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String   label;
  final String   value;
  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.textHint),
          const SizedBox(width: AppSpacing.md),
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
            ),
          ),
          Expanded(
            child: Text(value, style: AppTextStyles.bodySemiBold.copyWith(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  BOTTOMSHEET — Suivi
// ─────────────────────────────────────────

class _SuiviSheet extends StatelessWidget {
  final String            title;
  final String            ref;
  final SignalementStatus status;

  const _SuiviSheet({
    required this.title,
    required this.ref,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              margin:     const EdgeInsets.only(top: AppSpacing.md),
              width:      38,
              height:     4,
              decoration: BoxDecoration(
                color:        AppColors.border,
                borderRadius: AppRadius.chip,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Titre + référence
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Suivi du dossier', style: AppTextStyles.cardTitle),
                const SizedBox(height: 3),
                Text(ref, style: AppTextStyles.bodySmall),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Carte résultat
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Container(
              padding:    const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color:        AppColors.background,
                borderRadius: AppRadius.card,
                border:       Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // En-tête dossier
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: AppTextStyles.bodySemiBold.copyWith(fontSize: 13)),
                            const SizedBox(height: 3),
                            Text(ref, style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical:   AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color:        status.bgColor,
                          borderRadius: AppRadius.chip,
                        ),
                        child: Text(
                          status.label,
                          style: AppTextStyles.badge.copyWith(color: status.textColor),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.lg),
                  Container(height: 1, color: AppColors.border),
                  const SizedBox(height: AppSpacing.lg),

                  // Timeline
                  _TLRow(label: 'Signalement reçu',      sub: '14h32', tlStatus: _TLStatus.done),
                  _TLRow(label: 'En cours de traitement', sub: '14h38', tlStatus: _TLStatus.active),
                  _TLRow(label: 'Intervention en route',  sub: 'En attente', tlStatus: _TLStatus.idle),
                  _TLRow(label: 'Résolu',                 sub: 'En attente', tlStatus: _TLStatus.idle, isLast: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _TLStatus { done, active, idle }

class _TLRow extends StatelessWidget {
  final String    label;
  final String    sub;
  final _TLStatus tlStatus;
  final bool      isLast;

  const _TLRow({
    required this.label,
    required this.sub,
    required this.tlStatus,
    this.isLast = false,
  });

  Color get _dotColor => switch (tlStatus) {
    _TLStatus.done   => AppColors.success,
    _TLStatus.active => AppColors.primary,
    _TLStatus.idle   => AppColors.border,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width:      10,
              height:     10,
              margin:     const EdgeInsets.only(top: 3),
              decoration: BoxDecoration(color: _dotColor, shape: BoxShape.circle),
            ),
            if (!isLast)
              Container(width: 1.5, height: 30, color: AppColors.border),
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
                    fontSize:   12,
                    color:      tlStatus == _TLStatus.idle ? AppColors.textHint : AppColors.textPrimary,
                    fontWeight: tlStatus == _TLStatus.idle ? FontWeight.w400 : FontWeight.w500,
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