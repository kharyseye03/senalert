import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/app_responsive.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../widget/stat_card.dart';

const _policeBlue      = Color(0xFF1A56A0);
const _policeBlueLLight = Color(0xFFEAF1FB);

class PoliceProfilScreen extends StatelessWidget {
  const PoliceProfilScreen({super.key});

  void _onLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape:           RoundedRectangleBorder(borderRadius: AppRadius.card),
        title:           Text('Se déconnecter', style: AppTextStyles.bodySemiBold),
        content:         Text(
          'Voulez-vous vraiment vous déconnecter ?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Annuler',
              style: AppTextStyles.bodySemiBold.copyWith(color: AppColors.textHint),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.goNamed('portal');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _policeBlue,
              foregroundColor: AppColors.textOnPrimary,
              elevation:       0,
            ),
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

                  // Header bleu avec avatar
                  _ProfilHeader(r: r),
                  const SizedBox(height: AppSpacing.lg),

                  // Stats flottantes
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      r.pagePadding, 0, r.pagePadding, AppSpacing.lg,
                    ),
                    child: Row(
                      children: const [
                        Expanded(child: StatCard(value: '47', label: 'Traités',  valueColor: _policeBlue)),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(child: StatCard(value: '42', label: 'Validés',  valueColor: _policeBlue)),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(child: StatCard(value: '5',  label: 'Rejetés',  valueColor: _policeBlue)),
                      ],
                    ),
                  ),

                  // Mon compte
                  _MenuSection(
                    label:   'Mon compte',
                    padding: r.pagePadding,
                    items: [
                      _MenuItem(
                        icon:      Icons.person_outline_rounded,
                        iconBg:    _policeBlueLLight,
                        iconColor: _policeBlue,
                        label:     'Informations agent',
                        subtitle:  'Nom, matricule, unité',
                        onTap:     () {},
                      ),
                      _MenuItem(
                        icon:      Icons.lock_outline_rounded,
                        iconBg:    AppColors.successLight,
                        iconColor: AppColors.success,
                        label:     'Mot de passe',
                        subtitle:  'Modifier mon mot de passe',
                        onTap:     () {},
                      ),
                      _MenuItem(
                        icon:      Icons.notifications_outlined,
                        iconBg:    AppColors.primaryLight,
                        iconColor: AppColors.primary,
                        label:     'Notifications',
                        subtitle:  'Gérer mes alertes',
                        onTap:     () {},
                      ),
                    ],
                  ),

                  SizedBox(height: r.spacing(small: 14, normal: 16, large: 20)),

                  // À propos
                  _MenuSection(
                    label:   'À propos',
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
                    ],
                  ),

                  SizedBox(height: r.spacing(small: 20, normal: 24, large: 28)),

                  // Déconnexion
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: r.pagePadding),
                    child: GestureDetector(
                      onTap: () => _onLogout(context),
                      child: Container(
                        width:   double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                        decoration: BoxDecoration(
                          color:        AppColors.surface,
                          borderRadius: AppRadius.card,
                          border:       Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          'Se déconnecter',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodySemiBold.copyWith(color: _policeBlue),
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
          const _PoliceBottomNav(currentIndex: 2),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  HEADER BLEU AVEC AVATAR
// ─────────────────────────────────────────

class _ProfilHeader extends StatelessWidget {
  final AppResponsive r;
  const _ProfilHeader({required this.r});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ColoredBox(
        color: _policeBlue,
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // Cercles déco
              Positioned(top: -35, right: -25, child: _DecoCircle(size: 120, opacity: .08)),
              Positioned(top:   8, right:  18, child: _DecoCircle(size:  70, opacity: .06)),
              Positioned(top:  40, right:  55, child: _DecoCircle(size:  36, opacity: .05)),

              Padding(
                padding: EdgeInsets.fromLTRB(
                  r.pagePadding,
                  r.spacing(small: 16, normal: 20, large: 24),
                  r.pagePadding,
                  r.spacing(small: 24, normal: 28, large: 32),
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar
                      Container(
                        width:      68,
                        height:     68,
                        decoration: BoxDecoration(
                          color:  Colors.white.withOpacity(0.2),
                          shape:  BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 2.5,
                          ),
                        ),
                        child: const Center(
                          child: Text('👮', style: TextStyle(fontSize: 30)),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // Nom
                      Text(
                        'Agent Diallo',
                        style: AppTextStyles.screenTitle,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Matricule : SN-2024-0042',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // Badge commissariat
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical:   AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color:        Colors.white.withOpacity(0.15),
                          borderRadius: AppRadius.chip,
                        ),
                        child: Text(
                          '🛡️ Commissariat du Plateau',
                          style: AppTextStyles.badge.copyWith(
                            color: AppColors.textOnPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DecoCircle extends StatelessWidget {
  final double size;
  final double opacity;
  const _DecoCircle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:      size,
      height:     size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}

// ─────────────────────────────────────────
//  SECTION MENU
// ─────────────────────────────────────────

class _MenuSection extends StatelessWidget {
  final String          label;
  final double          padding;
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
          Text(label.toUpperCase(), style: AppTextStyles.sectionLabel),
          const SizedBox(height: AppSpacing.sm),
          Container(
            decoration: BoxDecoration(
              color:        AppColors.surface,
              borderRadius: AppRadius.card,
              border:       Border.all(color: AppColors.border),
            ),
            child: Column(
              children: List.generate(items.length, (i) {
                final isLast = i == items.length - 1;
                return Column(
                  children: [
                    _MenuItemTile(item: items[i]),
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
                  Text(
                    item.label,
                    style: AppTextStyles.bodySemiBold.copyWith(fontSize: 13),
                  ),
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

// ─────────────────────────────────────────
//  BOTTOM NAV POLICIER
// ─────────────────────────────────────────

class _PoliceBottomNav extends StatelessWidget {
  final int currentIndex;
  const _PoliceBottomNav({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color:  AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            children: [
              _NavItem(
                icon:    Icons.home_rounded,
                label:   'Accueil',
                index:   0,
                current: currentIndex,
                onTap:   () => context.goNamed('police_dashboard'),
              ),
              _NavItem(
                icon:    Icons.folder_outlined,
                label:   'Dossiers',
                index:   1,
                current: currentIndex,
                onTap:   () => context.goNamed('police_dossiers'),
              ),
              _NavItem(
                icon:    Icons.person_outline_rounded,
                label:   'Profil',
                index:   2,
                current: currentIndex,
                onTap:   () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData     icon;
  final String       label;
  final int          index;
  final int          current;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == current;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: isActive ? _policeBlue : AppColors.textHint),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize:   9,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color:      isActive ? _policeBlue : AppColors.textHint,
              ),
            ),
            if (isActive) ...[
              const SizedBox(height: 3),
              Container(
                width:  4,
                height: 4,
                decoration: const BoxDecoration(
                  color: _policeBlue,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}