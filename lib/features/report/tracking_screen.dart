import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/responsive/app_responsive.dart';
import '../../widget/deco_circles.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final _refController = TextEditingController();
  bool  _hasResult     = false;
  bool  _notFound      = false;
  bool _isLoading  = false;

  void _onSearch() async {
    final ref = _refController.text.trim();
    if (ref.isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasResult = false;
      _notFound  = false;
    });

    // Simulation loading 1.5s — remplace par appel API
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _isLoading = false;
      _notFound  = ref.toLowerCase() == 'test404';
      _hasResult = !_notFound;
    });
  }


  @override
  void dispose() {
    _refController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final r = AppResponsive(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _TrackingHeader(r: r),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: r.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: r.spacing(small: 16, normal: 20, large: 24)),
                  _SearchBox(
                    controller: _refController,
                    onSearch:   _onSearch,
                    isLoading:  _isLoading,
                  ),
                  SizedBox(height: r.spacing(small: 16, normal: 20, large: 24)),
                  if (_hasResult) ...[
                    const _SectionLabel(label: 'Résultat'),
                    const SizedBox(height: AppSpacing.md),
                    const _ResultCard(),
                  ],
                  if (_notFound) const _NotFoundCard(),
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
//  HEADER ROUGE
// ─────────────────────────────────────────

class _TrackingHeader extends StatelessWidget {
  final AppResponsive r;
  const _TrackingHeader({required this.r});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ColoredBox(
        color: AppColors.primary,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(r.pagePadding, 12, r.pagePadding, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.goNamed('portal');
                    }
                  },
                  borderRadius: AppRadius.input,
                  child: Container(
                    width:      32,
                    height:     32,
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
                  'Suivi de dossier',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textOnPrimary.withOpacity(0.65),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Où en est votre dossier ?',
                  style: AppTextStyles.screenTitle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  CHAMP RECHERCHE
// ─────────────────────────────────────────

class _SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final bool isLoading;

  const _SearchBox({
    required this.controller,
    required this.onSearch,
    required this.isLoading,
  });

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
          Text('NUMÉRO DE RÉFÉRENCE', style: AppTextStyles.sectionLabel),
          const SizedBox(height: AppSpacing.md),

          // Input
          Container(
            decoration: BoxDecoration(
              color:        AppColors.background,
              borderRadius: AppRadius.input,
              border:       Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const SizedBox(width: AppSpacing.md),
                const Icon(Icons.search_rounded, color: AppColors.textHint, size: 18),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: TextField(
                    controller:   controller,
                    style:        AppTextStyles.bodyMedium,
                    textCapitalization: TextCapitalization.characters,
                    decoration:   InputDecoration(
                      hintText:       '#DK-2024-XXXX',
                      hintStyle:      AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textDisabled,
                      ),
                      border: InputBorder.none,
                      enabledBorder:  InputBorder.none,
                      focusedBorder:  InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    ),
                    onSubmitted: (_) => onSearch(),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Bouton rechercher
          SizedBox(
            width:  double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: isLoading ? null : onSearch,
              child: isLoading
                  ? const SizedBox(
                width:  20,
                height: 20,
                child:  CircularProgressIndicator(
                  strokeWidth: 2,
                  color:       AppColors.textOnPrimary,
                ),
              )
                  : Text('Rechercher', style: AppTextStyles.buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  CARTE RÉSULTAT
// ─────────────────────────────────────────

class _ResultCard extends StatelessWidget {
  const _ResultCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:    const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: AppRadius.card,
        border:       Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête résultat
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Incendie — Marché Sandaga', style: AppTextStyles.bodySemiBold),
                    const SizedBox(height: 3),
                    Text('#DK-2024-0847 · il y a 45 min', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              Container(
                padding:    const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color:        AppColors.warningLight,
                  borderRadius: AppRadius.chip,
                ),
                child: Text(
                  'En cours',
                  style: AppTextStyles.badge.copyWith(color: AppColors.warning),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),
          Container(height: 1, color: AppColors.border),
          const SizedBox(height: AppSpacing.lg),

          // Timeline
          const _TimelineRow(label: 'Signalement reçu',      sub: '14h32', status: _TLStatus.done),
          const _TimelineRow(label: 'En cours de traitement', sub: '14h38', status: _TLStatus.active),
          const _TimelineRow(label: 'Intervention en route',  sub: 'En attente', status: _TLStatus.idle),
          const _TimelineRow(label: 'Résolu',                 sub: 'En attente', status: _TLStatus.idle, isLast: true),

          const SizedBox(height: AppSpacing.lg),
          Container(height: 1, color: AppColors.border),
          const SizedBox(height: AppSpacing.lg),

          // Agent assigné
          const _AgentCard(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  TIMELINE
// ─────────────────────────────────────────

enum _TLStatus { done, active, idle }

class _TimelineRow extends StatelessWidget {
  final String    label;
  final String    sub;
  final _TLStatus status;
  final bool      isLast;

  const _TimelineRow({
    required this.label,
    required this.sub,
    required this.status,
    this.isLast = false,
  });

  Color get _dotColor => switch (status) {
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
                    color:      status == _TLStatus.idle ? AppColors.textHint : AppColors.textPrimary,
                    fontWeight: status == _TLStatus.idle ? FontWeight.w400 : FontWeight.w500,
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

// ─────────────────────────────────────────
//  AGENT ASSIGNÉ
// ─────────────────────────────────────────

class _AgentCard extends StatelessWidget {
  const _AgentCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:    const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color:        AppColors.background,
        borderRadius: AppRadius.input,
        border:       Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width:      40,
            height:     40,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'A',
                style: AppTextStyles.bodySemiBold.copyWith(color: AppColors.textOnPrimary),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Agent Diallo', style: AppTextStyles.bodySemiBold),
                const SizedBox(height: 2),
                Text('Commissariat du Plateau', style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          // Bouton appel
          Container(
            width:      36,
            height:     36,
            decoration: BoxDecoration(
              color:        AppColors.primary,
              borderRadius: AppRadius.input,
            ),
            child: const Icon(Icons.phone_rounded, color: AppColors.textOnPrimary, size: 18),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  NON TROUVÉ
// ─────────────────────────────────────────

class _NotFoundCard extends StatelessWidget {
  const _NotFoundCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width:      double.infinity,
      padding:    const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: AppRadius.card,
        border:       Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width:      56,
            height:     56,
            decoration: BoxDecoration(
              color:        AppColors.primaryLight,
              borderRadius: AppRadius.input,
            ),
            child: const Icon(Icons.search_off_rounded, color: AppColors.primary, size: 28),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Dossier introuvable', style: AppTextStyles.bodySemiBold),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Vérifiez le numéro de référence et réessayez.',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  LABEL DE SECTION
// ─────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.bodySemiBold.copyWith(fontSize: 15),
    );
  }
}