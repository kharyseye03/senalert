import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/app_responsive.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../model/signalement.dart';
import '../../../../widget/nav_item.dart';
import '../../../../widget/service_item.dart';
import '../../../../widget/signalement_card.dart';

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
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
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
              ServiceItem(
                icon:      Icons.warning_amber_rounded,
                label:     'Signaler',
                iconColor: AppColors.primary,
                bgColor:   AppColors.primaryLight,
                onTap:     () => context.goNamed('report'),
              ),
              ServiceItem(
                icon:      Icons.manage_search_rounded,
                label:     'Suivre',
                iconColor: AppColors.info,
                bgColor:   AppColors.infoLight,
                onTap:     () => context.goNamed('tracking'),
              ),
              ServiceItem(
                icon:      Icons.card_giftcard_rounded,
                label:     'Récompenses',
                iconColor: AppColors.success,
                bgColor:   AppColors.successLight,
                onTap: () => context.goNamed('recompenses'),
              ),
              ServiceItem(
                icon:      Icons.phone_in_talk_rounded,
                label:     'Urgences',
                iconColor: AppColors.warning,
                bgColor:   AppColors.warningLight,
                onTap:     () => showModalBottomSheet(
                  context:            context,
                  isScrollControlled: true,
                  backgroundColor:    Colors.transparent,
                  builder:            (_) => const _UrgencesSheet(),
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
                onPressed: () => showModalBottomSheet(
                  context:            context,
                  isScrollControlled: true,
                  backgroundColor:    Colors.transparent,
                  builder:            (_) => const _HistoriqueSheet(),
                ),
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
          const SignalementCard(
            emoji:   '🚗',
            emojiBg: AppColors.primaryLight,
            title:   'Accident de la route',
            ref:     'SIG-2026-00089',
            time:    'il y a 2h',
            status:  SignalementStatus.inProgress,
          ),
          const SignalementCard(
            emoji:   '⚠️',
            emojiBg: AppColors.surfaceAlt,
            title:   'Trouble de voisinage',
            ref:     'SIG-2026-00071',
            time:    'hier',
            status:  SignalementStatus.resolved,
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
              NavItem(
                icon:     Icons.home_rounded,
                label:    'Accueil',
                isActive: true,
                onTap:    () {},
              ),
              NavItem(
                icon:     Icons.folder_outlined,
                label:    'Dossiers',
                isActive: false,
                onTap:    () => context.goNamed('dossiers'),
              ),
              NavItem(
                icon:     Icons.map_outlined,
                label:    'Carte',
                isActive: false,
                onTap:    () {},
              ),
              NavItem(
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




// ─────────────────────────────────────────
//  BOTTOMSHEET — Numéros d'urgence
// ─────────────────────────────────────────

class _UrgencesSheet extends StatelessWidget {
  const _UrgencesSheet();

  static const _services = [
    _UrgService(emoji: '🚔', name: 'Police Nationale', desc: 'Crimes, délits, sécurité publique', number: '17',  bg: AppColors.primaryLight),
    _UrgService(emoji: '🚒', name: 'Pompiers',         desc: 'Incendies, secours d\'urgence',     number: '18',  bg: Color(0xFFFFF4EC)),
    _UrgService(emoji: '🚑', name: 'SAMU',             desc: 'Urgences médicales',                number: '15',  bg: AppColors.successLight),
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
          ..._services.map((s) => _UrgServiceTile(service: s)),
        ],
      ),
    );
  }
}

class _UrgService {
  final String emoji;
  final String name;
  final String desc;
  final String number;
  final Color  bg;
  const _UrgService({required this.emoji, required this.name, required this.desc, required this.number, required this.bg});
}

class _UrgServiceTile extends StatelessWidget {
  final _UrgService service;
  const _UrgServiceTile({required this.service});

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
          Container(
            width:      34,
            height:     34,
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: AppRadius.input),
            child: const Icon(Icons.phone_rounded, color: AppColors.textOnPrimary, size: 17),
          ),
        ],
      ),
    );
  }
}


// ─────────────────────────────────────────
//  BOTTOMSHEET — Historique signalements
// ─────────────────────────────────────────

class _HistoriqueSheet extends StatelessWidget {
  const _HistoriqueSheet();

  static const _historique = [
    _HistoItem(emoji: '🚗', title: 'Accident de la route',   ref: 'SIG-2026-00089', time: 'il y a 2h',   status: SignalementStatus.inProgress),
    _HistoItem(emoji: '⚠️', title: 'Trouble de voisinage',   ref: 'SIG-2026-00071', time: 'hier',         status: SignalementStatus.resolved),
    _HistoItem(emoji: '🔥', title: 'Incendie — Marché',      ref: 'SIG-2026-00054', time: 'il y a 3j',   status: SignalementStatus.resolved),
    _HistoItem(emoji: '🏥', title: 'Urgence médicale',       ref: 'SIG-2026-00038', time: 'il y a 5j',   status: SignalementStatus.resolved),
    _HistoItem(emoji: '🔧', title: 'Voirie — Rue Moussé',    ref: 'SIG-2026-00021', time: 'il y a 8j',   status: SignalementStatus.resolved),
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
          // Handle
          Center(
            child: Container(
              margin:     const EdgeInsets.only(top: AppSpacing.md),
              width:      38,
              height:     4,
              decoration: BoxDecoration(color: AppColors.border, borderRadius: AppRadius.chip),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Titre + compteur
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Row(
              children: [
                Text('Mes signalements', style: AppTextStyles.cardTitle),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
                  decoration: BoxDecoration(
                    color:        AppColors.primaryLight,
                    borderRadius: AppRadius.chip,
                  ),
                  child: Text(
                    '${_historique.length}',
                    style: AppTextStyles.badge.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Liste
          ..._historique.map((item) => _HistoTile(item: item)),
        ],
      ),
    );
  }
}

class _HistoItem {
  final String        emoji;
  final String        title;
  final String        ref;
  final String        time;
  final SignalementStatus status;
  const _HistoItem({
    required this.emoji,
    required this.title,
    required this.ref,
    required this.time,
    required this.status,
  });
}

class _HistoTile extends StatelessWidget {
  final _HistoItem item;
  const _HistoTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final isInProgress = item.status == SignalementStatus.inProgress
    ;

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
          // Emoji
          Container(
            width:      38,
            height:     38,
            decoration: BoxDecoration(
              color:        isInProgress ? AppColors.primaryLight : AppColors.surfaceAlt,
              borderRadius: AppRadius.input,
            ),
            child: Center(child: Text(item.emoji, style: const TextStyle(fontSize: 16))),
          ),
          const SizedBox(width: AppSpacing.md),

          // Infos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.bodySemiBold.copyWith(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.ref} · ${item.time}',
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 9),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Pill statut
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
            decoration: BoxDecoration(
              color:        isInProgress ? AppColors.warningLight : AppColors.successLight,
              borderRadius: AppRadius.chip,
            ),
            child: Text(
              isInProgress ? 'En cours' : 'Traité',
              style: AppTextStyles.badge.copyWith(
                fontSize: 9,
                color: isInProgress ? AppColors.warning : AppColors.success,
              ),
            ),
          ),
        ],
      ),
    );

  }


}