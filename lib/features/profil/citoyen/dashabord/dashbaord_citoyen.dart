import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/app_responsive.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Contenu scrollable
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _Header(r: r),

                  // Hero banner
                  _HeroBanner(r: r),

                  // Mes services
                  _ServicesSection(r: r),

                  // Mes signalements
                  _ReportsSection(r: r),

                  SizedBox(height: r.spacing(small: 12, normal: 16, large: 20)),
                ],
              ),
            ),
          ),

          // Bottom navigation
          const _BottomNav(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  HEADER
// ─────────────────────────────────────────

class _Header extends StatelessWidget {
  final AppResponsive r;
  const _Header({required this.r});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(r.pagePadding, 8, r.pagePadding, 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bonjour 👋', style: AppTextStyles.greeting),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width:  7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Dakar — Plateau',
                        style: AppTextStyles.bodySemiBold.copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Cloche notification
            Stack(
              children: [
                Container(
                  width:      38,
                  height:     38,
                  decoration: BoxDecoration(
                    color:        AppColors.surface,
                    shape:        BoxShape.circle,
                    border:       Border.all(color: AppColors.border),
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.textPrimary,
                    size:  20,
                  ),
                ),
                Positioned(
                  top:   6,
                  right: 6,
                  child: Container(
                    width:      8,
                    height:     8,
                    decoration: BoxDecoration(
                      color:  AppColors.primary,
                      shape:  BoxShape.circle,
                      border: Border.all(color: AppColors.background, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  HERO BANNER
// ─────────────────────────────────────────

class _HeroBanner extends StatelessWidget {
  final AppResponsive r;
  const _HeroBanner({required this.r});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(r.pagePadding, 0, r.pagePadding, r.spacing(small: 16, normal: 20, large: 24)),
      child: GestureDetector(
        onTap: () => context.goNamed('report'),
        child: Container(
          width:      double.infinity,
          padding:    EdgeInsets.all(r.spacing(small: 16, normal: 18, large: 22)),
          decoration: BoxDecoration(
            color:        AppColors.primary,
            borderRadius: AppRadius.card,
          ),
          child: Stack(
            children: [
              // Cercles décoratifs
              Positioned(top: -30, right: -25, child: _DecoCircle(size: 110, opacity: .09)),
              Positioned(top:   5, right:  18, child: _DecoCircle(size:  65, opacity: .07)),
              Positioned(top:  36, right:  55, child: _DecoCircle(size:  32, opacity: .06)),
              Positioned(bottom: -25, left: -15, child: _DecoCircle(size: 80, opacity: .06)),

              // Contenu
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ACTION PRINCIPALE',
                    style: AppTextStyles.sectionLabel.copyWith(
                      color: AppColors.textOnPrimary.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Nouveau signalement',
                    style: AppTextStyles.heroTitle.copyWith(
                      fontSize: r.heroFontSize - 4,
                      color:    AppColors.textOnPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Déclarez un incident en quelques secondes',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textOnPrimary.withOpacity(0.65),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical:   AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color:        AppColors.surface,
                      borderRadius: AppRadius.chip,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Commencer',
                          style: AppTextStyles.badge.copyWith(
                            color:    AppColors.primary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward_rounded, color: AppColors.primary, size: 14),
                      ],
                    ),
                  ),
                ],
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
//  MES SERVICES
// ─────────────────────────────────────────

class _ServicesSection extends StatelessWidget {
  final AppResponsive r;
  const _ServicesSection({required this.r});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(r.pagePadding, 0, r.pagePadding, r.spacing(small: 16, normal: 20, large: 24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mes services', style: AppTextStyles.bodySemiBold.copyWith(fontSize: 14)),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ServiceItem(
                icon:      Icons.warning_amber_rounded,
                label:     'Signaler',
                iconColor: AppColors.primary,
                bgColor:   AppColors.primaryLight,
                onTap:     () => context.goNamed('report'),
              ),
              _ServiceItem(
                icon:      Icons.manage_search_rounded,
                label:     'Suivre',
                iconColor: AppColors.info,
                bgColor:   AppColors.infoLight,
                onTap:     () => context.goNamed('tracking'),
              ),
              _ServiceItem(
                icon:      Icons.map_outlined,
                label:     'Carte',
                iconColor: AppColors.success,
                bgColor:   AppColors.successLight,
                onTap:     () {},
              ),
              _ServiceItem(
                icon:      Icons.phone_in_talk_rounded,
                label:     'Urgences',
                iconColor: AppColors.warning,
                bgColor:   AppColors.warningLight,
                onTap:     () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ServiceItem extends StatelessWidget {
  final IconData     icon;
  final String       label;
  final Color        iconColor;
  final Color        bgColor;
  final VoidCallback onTap;

  const _ServiceItem({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width:      50,
            height:     50,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color:      AppColors.textPrimary,
              fontWeight: FontWeight.w500,
              fontSize:   11,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  MES SIGNALEMENTS
// ─────────────────────────────────────────

class _ReportsSection extends StatelessWidget {
  final AppResponsive r;
  const _ReportsSection({required this.r});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Mes signalements', style: AppTextStyles.bodySemiBold.copyWith(fontSize: 14)),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding:         EdgeInsets.zero,
                  minimumSize:     Size.zero,
                  tapTargetSize:   MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Voir tout ›',
                  style: AppTextStyles.bodySmall.copyWith(
                    color:    AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Signalement 1
          _ReportCard(
            emoji:   '🚗',
            emojiBg: AppColors.primaryLight,
            title:   'Accident de la route',
            ref:     'SIG-2026-00089 · il y a 2h',
            status:  _ReportStatus.inProgress,
          ),
          const SizedBox(height: AppSpacing.sm),

          // Signalement 2
          _ReportCard(
            emoji:   '⚠️',
            emojiBg: AppColors.surfaceAlt,
            title:   'Trouble de voisinage',
            ref:     'SIG-2026-00071 · hier',
            status:  _ReportStatus.resolved,
          ),
        ],
      ),
    );
  }
}

enum _ReportStatus { inProgress, resolved }

class _ReportCard extends StatelessWidget {
  final String        emoji;
  final Color         emojiBg;
  final String        title;
  final String        ref;
  final _ReportStatus status;

  const _ReportCard({
    required this.emoji,
    required this.emojiBg,
    required this.title,
    required this.ref,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isInProgress = status == _ReportStatus.inProgress;

    return Container(
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
                      style: AppTextStyles.bodySemiBold.copyWith(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(ref, style: AppTextStyles.bodySmall.copyWith(fontSize: 9)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical:   AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color:        isInProgress ? AppColors.warningLight : AppColors.successLight,
                  borderRadius: AppRadius.chip,
                ),
                child: Text(
                  isInProgress ? 'En cours' : 'Traité',
                  style: AppTextStyles.badge.copyWith(
                    color: isInProgress ? AppColors.warning : AppColors.success,
                  ),
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
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding:      const EdgeInsets.symmetric(vertical: 8),
                    minimumSize:  Size.zero,
                    side:         const BorderSide(color: AppColors.border),
                    foregroundColor: AppColors.textSecondary,
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.input),
                  ),
                  icon:  const Icon(Icons.search_rounded, size: 13),
                  label: Text('Détails', style: AppTextStyles.badge.copyWith(color: AppColors.textSecondary)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.goNamed('tracking'),
                  style: ElevatedButton.styleFrom(
                    padding:         const EdgeInsets.symmetric(vertical: 8),
                    minimumSize:     Size.zero,
                    backgroundColor: AppColors.textPrimary,
                    foregroundColor: AppColors.textOnPrimary,
                    elevation:       0,
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.input),
                  ),
                  icon:  const Icon(Icons.remove_red_eye_outlined, size: 13),
                  label: Text('Suivre', style: AppTextStyles.badge.copyWith(color: AppColors.textOnPrimary)),
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
//  BOTTOM NAVIGATION
// ─────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  const _BottomNav();

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
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              _NavItem(
                icon:     Icons.home_rounded,
                label:    'Accueil',
                isActive: true,
                onTap:    () {},
              ),
              _NavItem(
                icon:     Icons.folder_outlined,
                label:    'Dossiers',
                isActive: false,
                onTap:    () {},
              ),
              _NavItem(
                icon:     Icons.map_outlined,
                label:    'Carte',
                isActive: false,
                onTap:    () {},
              ),
              _NavItem(
                icon:     Icons.person_outline_rounded,
                label:    'Profil',
                isActive: false,
                onTap:    () => context.goNamed('profile'),
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
  final bool         isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size:  22,
              color: isActive ? AppColors.primary : AppColors.textHint,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize:   9,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color:      isActive ? AppColors.primary : AppColors.textHint,
              ),
            ),
            if (isActive) ...[
              const SizedBox(height: 3),
              Container(
                width:  4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
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