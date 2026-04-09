import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/responsive/app_responsive.dart';
import '../../widget/deco_circles.dart';

class PortalScreen extends StatelessWidget {
  const PortalScreen({super.key});

  void _showUrgences(BuildContext context) {
    showModalBottomSheet(
      context:            context,
      isScrollControlled: true,
      backgroundColor:    Colors.transparent,
      builder:            (_) => const _UrgencesSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const DecoCirclesTop(),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: r.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: r.spacing(small: 20, normal: 28, large: 36)),
                  _Header(r: r),
                  SizedBox(height: r.spacing(small: 24, normal: 30, large: 38)),
                  _MainButton(r: r),
                  const SizedBox(height: AppSpacing.md),
                  _SecondaryGrid(r: r),
                  SizedBox(height: r.spacing(small: 20, normal: 26, large: 32)),
                  const _SectionLabel(label: 'Statistiques'),
                  const SizedBox(height: AppSpacing.md),
                  const _StatsBar(),
                  SizedBox(height: r.spacing(small: 20, normal: 26, large: 32)),
                  const _SectionLabel(label: 'Urgences'),
                  const SizedBox(height: AppSpacing.md),
                  _UrgenceButton(onTap: () => _showUrgences(context)),
                  SizedBox(height: r.spacing(small: 28, normal: 36, large: 44)),
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

class _Header extends StatelessWidget {
  final AppResponsive r;
  const _Header({required this.r});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bonjour 👋', style: AppTextStyles.greeting),
              const SizedBox(height: AppSpacing.xs),
              Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text:  'Signalez un\n',
                    style: AppTextStyles.heroTitle.copyWith(fontSize: r.heroFontSize),
                  ),
                  TextSpan(
                    text:  'incident.',
                    style: AppTextStyles.heroTitle.copyWith(
                      fontSize: r.heroFontSize,
                      color:    AppColors.primary,
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
        Container(
          width:      46,
          height:     46,
          decoration: const BoxDecoration(
            color:        AppColors.primary,
            borderRadius: BorderRadius.all(Radius.circular(13)),
          ),
          child: const Icon(Icons.shield_rounded, color: AppColors.textOnPrimary, size: 24),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
//  BOUTON PRINCIPAL
// ─────────────────────────────────────────

class _MainButton extends StatelessWidget {
  final AppResponsive r;
  const _MainButton({required this.r});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.goNamed('report'),
      child: Container(
        padding:    EdgeInsets.all(r.spacing(small: 16, normal: 18, large: 22)),
        decoration: BoxDecoration(
          color:        AppColors.primary,
          borderRadius: AppRadius.card,
          boxShadow:    AppShadows.primaryBtn,
        ),
        child: Row(
          children: [
            Container(
              width:      48,
              height:     48,
              decoration: BoxDecoration(
                color:        AppColors.decoOnRed1,
                borderRadius: AppRadius.input,
              ),
              child: const Icon(Icons.warning_amber_rounded, color: AppColors.textOnPrimary, size: 26),
            ),
            SizedBox(width: r.spacing(small: 12, normal: 14, large: 16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Faire un signalement',
                    style: AppTextStyles.buttonLabel.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Sans compte requis',
                    style: AppTextStyles.bodySmall.copyWith(
                      color:    AppColors.textOnPrimary.withOpacity(0.65),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textOnPrimary, size: 15),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  GRILLE SECONDAIRE
// ─────────────────────────────────────────

class _SecondaryGrid extends StatelessWidget {
  final AppResponsive r;
  const _SecondaryGrid({required this.r});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            icon:      Icons.manage_search_rounded,
            label:     'Suivre une alerte',
            sub:       'Via référence',
            iconBg:    AppColors.infoLight,
            iconColor: AppColors.info,
            onTap:     () => context.goNamed('tracking'),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _ActionCard(
            icon:      Icons.person_outline_rounded,
            label:     'Mon espace',
            sub:       'Connexion',
            iconBg:    AppColors.successLight,
            iconColor: AppColors.success,
            onTap:     () => context.goNamed('login'),
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData     icon;
  final String       label;
  final String       sub;
  final Color        iconBg;
  final Color        iconColor;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.sub,
    required this.iconBg,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:    const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color:        AppColors.surface,
          borderRadius: AppRadius.card,
          border:       Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width:      40,
              height:     40,
              decoration: BoxDecoration(color: iconBg, borderRadius: AppRadius.input),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(label, style: AppTextStyles.bodySemiBold.copyWith(height: 1.35)),
            const SizedBox(height: 2),
            Text(sub, style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  STATS
// ─────────────────────────────────────────

class _StatsBar extends StatelessWidget {
  const _StatsBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:    const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: AppRadius.card,
        border:       Border.all(color: AppColors.border),
      ),
      child: const Row(
        children: [
          _StatItem(value: '247',    label: 'Signalements'),
          _Divider(),
          _StatItem(value: '89%',    label: 'Résolus'),
          _Divider(),
          _StatItem(value: '12 min', label: 'Réponse moy.'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: AppTextStyles.cardTitle.copyWith(color: AppColors.primary)),
          const SizedBox(height: 3),
          Text(label, style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: AppColors.border);
  }
}

// ─────────────────────────────────────────
//  BOUTON URGENCES
// ─────────────────────────────────────────

class _UrgenceButton extends StatelessWidget {
  final VoidCallback onTap;
  const _UrgenceButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:    const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color:        AppColors.primaryLight,
          borderRadius: AppRadius.card,
          border:       Border.all(color: const Color(0xFFF5C4C4)),
        ),
        child: Row(
          children: [
            Container(
              width:      40,
              height:     40,
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: AppRadius.input),
              child: const Icon(Icons.phone_in_talk_rounded, color: AppColors.textOnPrimary, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Numéros d\'urgence',
                    style: AppTextStyles.bodySemiBold.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Police · Pompiers · Santé',
                    style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFFD88080)),
                  ),
                ],
              ),
            ),
            Container(
              padding:    const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: AppRadius.input),
              child: Text('Appeler', style: AppTextStyles.badge.copyWith(color: AppColors.textOnPrimary)),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  SECTION LABEL
// ─────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label.toUpperCase(), style: AppTextStyles.sectionLabel);
  }
}

// ─────────────────────────────────────────
//  BOTTOMSHEET — 3 services uniquement
// ─────────────────────────────────────────

class _UrgencesSheet extends StatelessWidget {
  const _UrgencesSheet();

  static const _services = [
    _Service(emoji: '🚔', name: 'Police Nationale', desc: 'Crimes, délits, sécurité publique', number: '17',  bg: AppColors.primaryLight),
    _Service(emoji: '🚒', name: 'Pompiers',          desc: 'Incendies, secours d\'urgence',     number: '18',  bg: Color(0xFFFFF4EC)),
    _Service(emoji: '🚑', name: 'SAMU',              desc: 'Urgences médicales',                number: '15',  bg: AppColors.successLight),
  ];

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
          Center(
            child: Container(
              margin:     const EdgeInsets.only(top: AppSpacing.md),
              width:      38,
              height:     4,
              decoration: BoxDecoration(color: AppColors.border, borderRadius: AppRadius.chip),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text('Numéros d\'urgence', style: AppTextStyles.cardTitle),
          ),
          const SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text('Sénégal — Disponibles 24h/24', style: AppTextStyles.bodySmall),
          ),
          const SizedBox(height: AppSpacing.lg),
          ..._services.map((s) => _ServiceTile(service: s)),
        ],
      ),
    );
  }
}

class _Service {
  final String emoji;
  final String name;
  final String desc;
  final String number;
  final Color  bg;
  const _Service({required this.emoji, required this.name, required this.desc, required this.number, required this.bg});
}

class _ServiceTile extends StatelessWidget {
  final _Service service;
  const _ServiceTile({required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:     const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xs),
      padding:    const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color:        AppColors.background,
        borderRadius: AppRadius.card,
        border:       Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width:      42,
            height:     42,
            decoration: BoxDecoration(color: service.bg, borderRadius: AppRadius.input),
            child: Center(child: Text(service.emoji, style: const TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.name, style: AppTextStyles.bodySemiBold),
                const SizedBox(height: 2),
                Text(service.desc, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(service.number, style: AppTextStyles.cardTitle.copyWith(color: AppColors.primary)),
          const SizedBox(width: AppSpacing.sm),
          GestureDetector(
            // Pour appel réel : launchUrl(Uri.parse('tel:${service.number}'));
            child: Container(
              width:      34,
              height:     34,
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: AppRadius.input),
              child: const Icon(Icons.phone_rounded, color: AppColors.textOnPrimary, size: 17),
            ),
          ),
        ],
      ),
    );
  }
}