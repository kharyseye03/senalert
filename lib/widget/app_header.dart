import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_dimensions.dart';
import '../core/theme/app_text_styles.dart';

class AppHeader extends StatelessWidget {
  final String       title;
  final String?      subtitle;
  final String       fallbackRoute;
  final Widget?      action; // widget optionnel à droite (ex: bouton ?)

  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.fallbackRoute = 'dashboard',
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
          children: [
            // Bouton retour
            InkWell(
              onTap: () {
                if (context.canPop()) context.pop();
                else context.goNamed(fallbackRoute);
              },
              borderRadius: AppRadius.input,
              child: Container(
                width:      34,
                height:     34,
                decoration: BoxDecoration(
                  color:        AppColors.surface,
                  borderRadius: AppRadius.input,
                  border:       Border.all(color: AppColors.border),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textPrimary,
                  size:  16,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // Titre + sous-titre
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodySemiBold),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!, style: AppTextStyles.bodySmall),
                  ],
                ],
              ),
            ),

            // Action optionnelle à droite
            if (action != null) action!,
          ],
        ),
    );
  }
}