import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/app_responsive.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../widget/bottom_nav.dart';
import '../../../../widget/stat_card.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  void _onLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
        title: Text('Se déconnecter', style: AppTextStyles.bodySemiBold),
        content: Text(
          'Voulez-vous vraiment vous déconnecter ?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Annuler', style: AppTextStyles.bodySemiBold.copyWith(color: AppColors.textHint)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.goNamed('portal');
            },
            child: Text('Confirmer', style: AppTextStyles.buttonLabel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [

                  // Avatar hero
                  _AvatarSection(r: r),

                  // Stats
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: r.pagePadding),
                    child: Row(
                      children: const [
                        Expanded(child: StatCard(value: '5',     label: 'Signalements')),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(child: StatCard(value: '4',     label: 'Résolus')),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(child: StatCard(value: '4 500', label: 'FCFA gagnés')),
                      ],
                    ),
                  ),

                  SizedBox(height: r.spacing(small: 20, normal: 24, large: 28)),

                  // Mon compte
                  _MenuSection(
                    label: 'Mon compte',
                    padding: r.pagePadding,
                    items: [
                      _MenuItem(
                        icon:     Icons.phone_outlined,
                        iconBg:   AppColors.primaryLight,
                        iconColor:AppColors.primary,
                        label:    'Numéro de téléphone',
                        subtitle: '+221 77 ••• ••',
                        onTap:    () {},
                      ),
                      _MenuItem(
                        icon:      Icons.lock_outline_rounded,
                        iconBg:    AppColors.successLight,
                        iconColor: AppColors.success,
                        label:     'Code PIN',
                        subtitle:  'Modifier mon code',
                        onTap:     () => context.goNamed('pin'),
                      ),
                      _MenuItem(
                        icon:      Icons.notifications_outlined,
                        iconBg:    AppColors.infoLight,
                        iconColor: AppColors.info,
                        label:     'Notifications',
                        subtitle:  'Gérer mes alertes',
                        onTap:     () {},
                      ),
                    ],
                  ),

                  SizedBox(height: r.spacing(small: 14, normal: 16, large: 20)),

                  // À propos
                  _MenuSection(
                    label: 'À propos',
                    padding: r.pagePadding,
                    items: [
                      _MenuItem(
                        icon:      Icons.info_outline_rounded,
                        iconBg:    AppColors.surfaceAlt,
                        iconColor: AppColors.textSecondary,
                        label:     'À propos de l\'app',
                        subtitle:  'Version 1.0.0',
                        onTap:     () {},
                      ),
                      _MenuItem(
                        icon:      Icons.description_outlined,
                        iconBg:    AppColors.surfaceAlt,
                        iconColor: AppColors.textSecondary,
                        label:     'Conditions d\'utilisation',
                        onTap:     () {},
                      ),
                    ],
                  ),

                  SizedBox(height: r.spacing(small: 20, normal: 24, large: 28)),

                  // Déconnexion
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: r.pagePadding),
                    child: GestureDetector(
                      onTap: () => _onLogout(context),
                      child: Container(
                        width:      double.infinity,
                        padding:    const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                        decoration: BoxDecoration(
                          color:        AppColors.surface,
                          borderRadius: AppRadius.card,
                          border:       Border.all(color: const Color(0xFFF5C4C4)),
                        ),
                        child: Text(
                          'Se déconnecter',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodySemiBold.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: r.spacing(small: 20, normal: 24, large: 28)),
                ],
              ),
            ),
          ),

          // Bottom nav
          const BottomNav(currentIndex: 3),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  SECTION AVATAR
// ─────────────────────────────────────────

class _AvatarSection extends StatelessWidget {
  final AppResponsive r;
  const _AvatarSection({required this.r});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          r.pagePadding,
          r.spacing(small: 20, normal: 24, large: 28),
          r.pagePadding,
          r.spacing(small: 16, normal: 20, large: 24),
        ),
        child: Column(
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width:      72,
                  height:     72,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppColors.textOnPrimary,
                    size:  36,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right:  0,
                  child: Container(
                    width:      22,
                    height:     22,
                    decoration: BoxDecoration(
                      color:  AppColors.success,
                      shape:  BoxShape.circle,
                      border: Border.all(color: AppColors.background, width: 2),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: AppColors.textOnPrimary,
                      size:  12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // Numéro
            Text(
              '+221 77 ••• ••',
              style: AppTextStyles.bodySemiBold.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Membre depuis Janvier 2026',
              style: AppTextStyles.bodySmall,
            ),

            const SizedBox(height: AppSpacing.md),

            // Badge citoyen
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical:   AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color:        AppColors.primaryLight,
                borderRadius: AppRadius.chip,
                border:       Border.all(color: const Color(0xFFF5C4C4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('⭐', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Citoyen Actif',
                    style: AppTextStyles.badge.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),

            SizedBox(height: r.spacing(small: 16, normal: 20, large: 24) is double ? 20 : 20),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  SECTION MENU
// ─────────────────────────────────────────

class _MenuSection extends StatelessWidget {
  final String        label;
  final double        padding;
  final List<_MenuItem> items;

  const _MenuSection({
    required this.label,
    required this.padding,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTextStyles.sectionLabel,
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            decoration: BoxDecoration(
              color:        AppColors.surface,
              borderRadius: AppRadius.card,
              border:       Border.all(color: AppColors.border),
            ),
            child: Column(
              children: List.generate(items.length, (i) {
                final item    = items[i];
                final isLast  = i == items.length - 1;
                return Column(
                  children: [
                    _MenuItemTile(item: item),
                    if (!isLast)
                      const Divider(height: 1, indent: 56, color: AppColors.border),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData     icon;
  final Color        iconBg;
  final Color        iconColor;
  final String       label;
  final String?      subtitle;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    this.subtitle,
    required this.onTap,
  });
}

class _MenuItemTile extends StatelessWidget {
  final _MenuItem item;
  const _MenuItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:        item.onTap,
      borderRadius: AppRadius.card,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical:   AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width:      34,
              height:     34,
              decoration: BoxDecoration(
                color:        item.iconBg,
                borderRadius: AppRadius.input,
              ),
              child: Icon(item.icon, color: item.iconColor, size: 17),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.label, style: AppTextStyles.bodySemiBold.copyWith(fontSize: 13)),
                  if (item.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(item.subtitle!, style: AppTextStyles.bodySmall),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 18),
          ],
        ),
      ),
    );
  }
}