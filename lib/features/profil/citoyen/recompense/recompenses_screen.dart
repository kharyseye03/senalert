import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/responsive/app_responsive.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class RecompensesScreen extends StatefulWidget {
  const RecompensesScreen({super.key});

  @override
  State<RecompensesScreen> createState() => _RecompensesScreenState();
}

class _RecompensesScreenState extends State<RecompensesScreen> {
  bool _soldeVisible = true;

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          r.pagePadding,
          MediaQuery.of(context).padding.top + AppSpacing.md,
          r.pagePadding,
          r.spacing(small: 28, normal: 36, large: 44),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Header simple sans fond rouge
            Row(
              children: [
                InkWell(
                  onTap: () {
                    if (context.canPop()) context.pop();
                    else context.goNamed('dashboard');
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mes récompenses', style: AppTextStyles.bodySemiBold),
                    Text('Vos gains citoyen', style: AppTextStyles.bodySmall),
                  ],
                ),
              ],
            ),

            SizedBox(height: r.spacing(small: 20, normal: 24, large: 28)),

            _SoldeCard(
              r:         r,
              isVisible: _soldeVisible,
              onToggle:  () => setState(() => _soldeVisible = !_soldeVisible),
            ),

            SizedBox(height: r.spacing(small: 20, normal: 24, large: 28)),

            _StatsRow(r: r),

            SizedBox(height: r.spacing(small: 20, normal: 24, large: 28)),

            Text(
              'Historique des récompenses',
              style: AppTextStyles.bodySemiBold.copyWith(fontSize: 14),
            ),
            const SizedBox(height: AppSpacing.md),

            const _RecompenseItem(
              title:     'Accident de la route validé',
              ref:       'SIG-2026-00089',
              amount:    '+1 500 FCFA',
              date:      'il y a 2h',
              isPending: false,
            ),
            const _RecompenseItem(
              title:     'Trouble de voisinage validé',
              ref:       'SIG-2026-00071',
              amount:    '+1 000 FCFA',
              date:      'hier',
              isPending: false,
            ),
            const _RecompenseItem(
              title:     'Incendie — Marché validé',
              ref:       'SIG-2026-00054',
              amount:    '+2 000 FCFA',
              date:      'il y a 3j',
              isPending: false,
            ),
            const _RecompenseItem(
              title:     'Voirie — Rue Moussé',
              ref:       'SIG-2026-00038',
              amount:    'En attente',
              date:      'il y a 5j',
              isPending: true,
            ),
          ],
        ),
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
    return SizedBox(
      width: double.infinity,
      child: ColoredBox(
        color: AppColors.primary,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(r.pagePadding, 12, r.pagePadding, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    if (context.canPop()) context.pop();
                    else context.goNamed('dashboard');
                  },
                  borderRadius: AppRadius.input,
                  child: Container(
                    width:      34,
                    height:     34,
                    decoration: BoxDecoration(
                      color:        Colors.white.withOpacity(0.18),
                      borderRadius: AppRadius.input,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textOnPrimary,
                      size:  16,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Mes récompenses',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textOnPrimary.withOpacity(0.65),
                  ),
                ),
                const SizedBox(height: 4),
                Text('Vos gains citoyen', style: AppTextStyles.screenTitle),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  CARTE SOLDE
// ─────────────────────────────────────────

class _SoldeCard extends StatelessWidget {
  final AppResponsive r;
  final bool          isVisible;
  final VoidCallback  onToggle;
  const _SoldeCard({required this.r, required this.isVisible, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:   double.infinity,
      padding: EdgeInsets.all(r.spacing(small: 18, normal: 22, large: 26)),
      decoration: BoxDecoration(
        color:        AppColors.primary,
        borderRadius: AppRadius.card,
      ),
      child: Stack(
        children: [
          // Cercles décoratifs
          Positioned(top: -20, right: -20, child: _DecoCircle(size: 100, opacity: .09)),
          Positioned(top:   5, right:  18, child: _DecoCircle(size:  58, opacity: .07)),
          Positioned(top:  32, right:  52, child: _DecoCircle(size:  30, opacity: .06)),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Solde disponible',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textOnPrimary.withOpacity(0.65),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    isVisible ? '4 500 FCFA' : '• • • • •',
                    style: AppTextStyles.heroTitle.copyWith(
                      fontSize: 32,
                      color:    AppColors.textOnPrimary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  GestureDetector(
                    onTap: onToggle,
                    child: Icon(
                      isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: AppColors.textOnPrimary.withOpacity(0.7),
                      size:  20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '3 signalements validés',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textOnPrimary.withOpacity(0.55),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Boutons retrait
              Row(
                children: [
                  Expanded(
                    child: _RetirementBtn(
                      label: 'Wave',
                      imagePath: 'assets/images/wave.png',
                      onTap: () {}),

                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _RetirementBtn(
                      label: 'Orange Money',
                      imagePath: 'assets/images/om.png',
                      onTap: () {}),

                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RetirementBtn extends StatelessWidget {
  final String       label;
  final String       imagePath;
  final VoidCallback onTap;

  const _RetirementBtn({
    required this.label,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical:   AppSpacing.md,
          horizontal: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color:        Colors.white.withOpacity(0.18),
          borderRadius: AppRadius.input,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: 20, height: 20, fit: BoxFit.contain),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: AppTextStyles.badge.copyWith(
                color:    AppColors.textOnPrimary,
                fontSize: 11,
              ),
            ),
          ],
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
//  STATS ROW
// ─────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final AppResponsive r;
  const _StatsRow({required this.r});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(value: '4 500', label: 'Total gagné\n(FCFA)'),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _StatCard(value: '3', label: 'Signalements\nvalidés'),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _StatCard(value: '1', label: 'En attente\nde validation'),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:    const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: AppRadius.card,
        border:       Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.cardTitle.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(fontSize: 9),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  ITEM RÉCOMPENSE
// ─────────────────────────────────────────

class _RecompenseItem extends StatelessWidget {
  final String title;
  final String ref;
  final String amount;
  final String date;
  final bool   isPending;

  const _RecompenseItem({
    required this.title,
    required this.ref,
    required this.amount,
    required this.date,
    required this.isPending,
  });

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
      child: Row(
        children: [
          // Icône
          Container(
            width:      40,
            height:     40,
            decoration: BoxDecoration(
              color:        isPending ? AppColors.warningLight : AppColors.successLight,
              borderRadius: AppRadius.input,
            ),
            child: Icon(
              isPending
                  ? Icons.hourglass_empty_rounded
                  : Icons.check_circle_outline_rounded,
              color: isPending ? AppColors.warning : AppColors.success,
              size:  20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Infos
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
                Text(
                  '$ref · $date',
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 9),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Montant
          Text(
            amount,
            style: AppTextStyles.bodySemiBold.copyWith(
              color:    isPending ? AppColors.warning : AppColors.success,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}