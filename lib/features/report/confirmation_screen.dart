import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/responsive/app_responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';

class ConfirmationSheet extends StatelessWidget {
  final String refNumber;
  const ConfirmationSheet({super.key, required this.refNumber});

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive(context);

    return Container(
      decoration: const BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        r.pagePadding, 0,
        r.pagePadding,
        r.bottomSafeH + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // Handle
          Container(
            margin:     const EdgeInsets.only(top: 12, bottom: 24),
            width:      40,
            height:     4,
            decoration: BoxDecoration(
              color:        AppColors.border,
              borderRadius: AppRadius.chip,
            ),
          ),

          // Icône succès
          Container(
            width:      64,
            height:     64,
            decoration: const BoxDecoration(
              color: AppColors.successLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, color: AppColors.success, size: 34),
          ),

          const SizedBox(height: AppSpacing.lg),

          Text(
            'Signalement transmis !',
            style: AppTextStyles.cardTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Reçu par les services compétents.\nVous serez notifié à chaque étape.',
            textAlign: TextAlign.center,
            style:     AppTextStyles.onboardingBody,
          ),

          const SizedBox(height: AppSpacing.xl),

          // Référence
          Container(
            width:   double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical:   AppSpacing.lg,
            ),
            decoration: BoxDecoration(
              color:        AppColors.background,
              borderRadius: AppRadius.card,
              border:       Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Text('RÉFÉRENCE DU DOSSIER', style: AppTextStyles.sectionLabel),
                const SizedBox(height: AppSpacing.sm),
                Text(refNumber, style: AppTextStyles.refNumber),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Bouton retour accueil
          SizedBox(
            width:  double.infinity,
            height: r.primaryBtnHeight,
            child:  ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.goNamed('portal');
              },
              child: Text('Retour à l\'accueil', style: AppTextStyles.buttonLabel),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Lien suivi
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.goNamed('tracking');
            },
            child: Text(
              'Suivre ce signalement →',
              style: AppTextStyles.bodySemiBold.copyWith(color: AppColors.primary),
            ),
          ),

        ],
      ),
    );
  }
}