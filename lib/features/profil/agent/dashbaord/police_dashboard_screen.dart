import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/responsive/app_responsive.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../model/signalement_police.dart';

const _policeBlue       = Color(0xFF1A56A0);
const _policeBlueLLight = Color(0xFFEAF1FB);

class PoliceDashboardScreen extends StatefulWidget {
  const PoliceDashboardScreen({super.key});

  @override
  State<PoliceDashboardScreen> createState() => _PoliceDashboardScreenState();
}

class _PoliceDashboardScreenState extends State<PoliceDashboardScreen> {

  List<SignalementPolice> get _aTraiter => kSignalementsPolice
      .where((s) => s.statut == StatutPolice.aTraiter || s.statut == StatutPolice.enCours)
      .toList();

  List<SignalementPolice> get _traites => kSignalementsPolice
      .where((s) => s.statut == StatutPolice.valide || s.statut == StatutPolice.rejete)
      .toList();

  void _onValider(SignalementPolice s) {
    // TODO : appel API pour valider
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:         Text('${s.ref} validé — récompense déclenchée !'),
        backgroundColor: AppColors.success,
        behavior:        SnackBarBehavior.floating,
        shape:           RoundedRectangleBorder(borderRadius: AppRadius.card),
      ),
    );
  }

  void _onRejeter(SignalementPolice s) {
    // TODO : appel API pour rejeter
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape:           RoundedRectangleBorder(borderRadius: AppRadius.card),
        title:           Text('Rejeter ce signalement ?', style: AppTextStyles.bodySemiBold),
        content:         Text(
          'Le citoyen sera notifié du rejet. Cette action est irréversible.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child:     Text('Annuler', style: AppTextStyles.bodySemiBold.copyWith(color: AppColors.textHint)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style:     ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child:     Text('Confirmer', style: AppTextStyles.buttonLabel),
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
          // Header bleu
          _PoliceHeader(r: r),

          // Contenu scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: r.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: r.spacing(small: 14, normal: 16, large: 20)),

                  // Résumé activité
                  _ActivityCard(),

                  SizedBox(height: r.spacing(small: 16, normal: 20, large: 24)),

                  // Priorité haute
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Priorité haute', style: AppTextStyles.bodySemiBold.copyWith(fontSize: 14)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
                        decoration: BoxDecoration(
                          color:        AppColors.primaryLight,
                          borderRadius: AppRadius.chip,
                        ),
                        child: Text(
                          '${_aTraiter.length} urgents',
                          style: AppTextStyles.badge.copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  ..._aTraiter.map((s) => _PoliceSignalementCard(
                    signalement: s,
                    onValider:   () => _onValider(s),
                    onRejeter:   () => _onRejeter(s),
                  )),

                  SizedBox(height: r.spacing(small: 16, normal: 20, large: 24)),

                  // Traités récemment
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Traités récemment', style: AppTextStyles.bodySemiBold.copyWith(fontSize: 14)),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding:       EdgeInsets.zero,
                          minimumSize:   Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Voir tout ›',
                          style: AppTextStyles.bodySmall.copyWith(
                            color:      _policeBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  ..._traites.map((s) => _DoneItem(signalement: s)),

                  SizedBox(height: r.spacing(small: 20, normal: 24, large: 28)),
                ],
              ),
            ),
          ),

          // Bottom nav policier
          const _PoliceBottomNav(currentIndex: 0),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  HEADER BLEU
// ─────────────────────────────────────────

class _PoliceHeader extends StatelessWidget {
  final AppResponsive r;
  const _PoliceHeader({required this.r});

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
              // Cercles décoratifs
              Positioned(top: -35, right: -25, child: _DecoCircle(size: 120, opacity: .08)),
              Positioned(top:   8, right:  18, child: _DecoCircle(size:  70, opacity: .06)),
              Positioned(top:  40, right:  55, child: _DecoCircle(size:  36, opacity: .05)),

              Padding(
                padding: EdgeInsets.fromLTRB(r.pagePadding, 12, r.pagePadding, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nom + badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Espace Policier 🛡️',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Agent Diallo',
                              style: AppTextStyles.screenTitle,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'SN-2024-0042 · Commissariat Plateau',
                              style: AppTextStyles.bodySmall.copyWith(
                                color:    Colors.white.withOpacity(0.5),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical:   AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color:        Colors.white.withOpacity(0.15),
                            borderRadius: AppRadius.chip,
                          ),
                          child: Text(
                            'En service',
                            style: AppTextStyles.badge.copyWith(
                              color: AppColors.textOnPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Stats
                    Row(
                      children: [
                        Expanded(child: _HeaderStat(value: '12', label: 'Reçus')),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(child: _HeaderStat(value: '5',  label: 'À traiter')),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(child: _HeaderStat(value: '7',  label: 'Traités')),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final String value;
  final String label;
  const _HeaderStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color:        Colors.white.withOpacity(0.12),
        borderRadius: AppRadius.input,
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.cardTitle.copyWith(
              color:    AppColors.textOnPrimary,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color:    Colors.white.withOpacity(0.6),
              fontSize: 9,
            ),
          ),
        ],
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
//  RÉSUMÉ ACTIVITÉ
// ─────────────────────────────────────────

class _ActivityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:    const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: AppRadius.card,
        border:       Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 Activité du jour',
            style: AppTextStyles.bodySemiBold.copyWith(fontSize: 13),
          ),
          const SizedBox(height: AppSpacing.md),
          _ActivityRow(
            icon:     Icons.check_circle_outline_rounded,
            iconBg:   _policeBlueLLight,
            iconColor:_policeBlue,
            label:    'Signalements validés',
            value:    '5',
          ),
          const SizedBox(height: AppSpacing.sm),
          _ActivityRow(
            icon:     Icons.cancel_outlined,
            iconBg:   AppColors.primaryLight,
            iconColor:AppColors.primary,
            label:    'Signalements rejetés',
            value:    '2',
          ),
          const SizedBox(height: AppSpacing.sm),
          _ActivityRow(
            icon:     Icons.card_giftcard_rounded,
            iconBg:   AppColors.successLight,
            iconColor:AppColors.success,
            label:    'Récompenses déclenchées',
            value:    '5',
          ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final IconData icon;
  final Color    iconBg;
  final Color    iconColor;
  final String   label;
  final String   value;

  const _ActivityRow({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width:      30,
          height:     30,
          decoration: BoxDecoration(color: iconBg, borderRadius: AppRadius.input),
          child:      Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(label, style: AppTextStyles.bodyMedium.copyWith(fontSize: 12)),
        ),
        Text(
          value,
          style: AppTextStyles.cardTitle.copyWith(
            color:    _policeBlue,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
//  CARD SIGNALEMENT POLICIER
// ─────────────────────────────────────────

class _PoliceSignalementCard extends StatelessWidget {
  final SignalementPolice signalement;
  final VoidCallback      onValider;
  final VoidCallback      onRejeter;

  const _PoliceSignalementCard({
    required this.signalement,
    required this.onValider,
    required this.onRejeter,
  });

  @override
  Widget build(BuildContext context) {
    final s = signalement;
    final progress = s.etape / s.totalEtapes;

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
                decoration: BoxDecoration(color: s.emojiBg, borderRadius: AppRadius.input),
                child:      Center(child: Text(s.emoji, style: const TextStyle(fontSize: 17))),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.title,
                      style:    AppTextStyles.bodySemiBold.copyWith(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${s.ref} · ${s.time} · ${s.zone}',
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 9),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
                decoration: BoxDecoration(
                  color:        s.priorite.bgColor,
                  borderRadius: AppRadius.chip,
                ),
                child: Text(
                  s.priorite.label,
                  style: AppTextStyles.badge.copyWith(color: s.priorite.textColor),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          // Barre de progression
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: AppRadius.chip,
                  child: LinearProgressIndicator(
                    value:            progress,
                    backgroundColor:  AppColors.background,
                    color:            _policeBlue,
                    minHeight:        3,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Étape ${s.etape}/${s.totalEtapes}',
                style: AppTextStyles.bodySmall.copyWith(fontSize: 9),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Boutons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onRejeter,
                  style: OutlinedButton.styleFrom(
                    padding:         const EdgeInsets.symmetric(vertical: 8),
                    minimumSize:     Size.zero,
                    side:            const BorderSide(color: AppColors.border),
                    foregroundColor: AppColors.primary,
                    shape:           RoundedRectangleBorder(borderRadius: AppRadius.input),
                  ),
                  child: Text(
                    'Rejeter',
                    style: AppTextStyles.badge.copyWith(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ElevatedButton(
                  onPressed: onValider,
                  style: ElevatedButton.styleFrom(
                    padding:         const EdgeInsets.symmetric(vertical: 8),
                    minimumSize:     Size.zero,
                    backgroundColor: _policeBlue,
                    foregroundColor: AppColors.textOnPrimary,
                    elevation:       0,
                    shape:           RoundedRectangleBorder(borderRadius: AppRadius.input),
                  ),
                  child: Text(
                    '✓ Valider',
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
//  ITEM TRAITÉ
// ─────────────────────────────────────────

class _DoneItem extends StatelessWidget {
  final SignalementPolice signalement;
  const _DoneItem({required this.signalement});

  @override
  Widget build(BuildContext context) {
    final s = signalement;
    return Container(
      margin:     const EdgeInsets.only(bottom: AppSpacing.sm),
      padding:    const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: AppRadius.card,
        border:       Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width:      34,
            height:     34,
            decoration: BoxDecoration(color: s.emojiBg, borderRadius: AppRadius.input),
            child:      Center(child: Text(s.emoji, style: const TextStyle(fontSize: 15))),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.title,
                  style:    AppTextStyles.bodySemiBold.copyWith(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${s.ref} · il y a ${s.time}',
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 9),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
            decoration: BoxDecoration(
              color:        s.statut.bgColor,
              borderRadius: AppRadius.chip,
            ),
            child: Text(
              s.statut.label,
              style: AppTextStyles.badge.copyWith(color: s.statut.textColor),
            ),
          ),
        ],
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
                icon: Icons.home_rounded,
                label: 'Accueil',
                index: 0, current: currentIndex,
                onTap: () {}),
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
                onTap:   () => context.goNamed('police_profil'),
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
                decoration: const BoxDecoration(color: _policeBlue, shape: BoxShape.circle),
              ),
            ],
          ],
        ),
      ),
    );
  }
}