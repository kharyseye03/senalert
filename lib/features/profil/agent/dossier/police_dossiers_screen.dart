import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/app_responsive.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../model/signalement_police.dart';

const _policeBlue = Color(0xFF1A56A0);

class PoliceDossiersScreen extends StatefulWidget {
  const PoliceDossiersScreen({super.key});

  @override
  State<PoliceDossiersScreen> createState() => _PoliceDossiersScreenState();
}

class _PoliceDossiersScreenState extends State<PoliceDossiersScreen> {
  final _searchController = TextEditingController();
  StatutPolice? _selectedFilter;
  String        _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SignalementPolice> get _filtered {
    return kSignalementsPolice.where((s) {
      final matchStatut = _selectedFilter == null || s.statut == _selectedFilter;
      final matchSearch = _searchQuery.isEmpty ||
          s.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.ref.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.zone.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchStatut && matchSearch;
    }).toList();
  }

  void _onTraiter(SignalementPolice s) {
    showModalBottomSheet(
      context:            context,
      isScrollControlled: true,
      backgroundColor:    Colors.transparent,
      builder:            (_) => _TraiterSheet(signalement: s),
    );
  }

  void _onDetails(SignalementPolice s) {
    showModalBottomSheet(
      context:            context,
      isScrollControlled: true,
      backgroundColor:    Colors.transparent,
      builder:            (_) => _DetailsSheet(signalement: s),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r       = AppResponsive(context);
    final results = _filtered;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [

          // Header
          _DossiersHeader(r: r, count: kSignalementsPolice.length),

          // Recherche
          Padding(
            padding: EdgeInsets.fromLTRB(r.pagePadding, 0, r.pagePadding, AppSpacing.sm),
            child: _SearchField(
              controller: _searchController,
              onChanged:  (v) => setState(() => _searchQuery = v),
            ),
          ),

          // Filtres
          _FilterChips(
            selected: _selectedFilter,
            onSelect: (f) => setState(() => _selectedFilter = f),
            padding:  r.pagePadding,
          ),

          const SizedBox(height: AppSpacing.sm),

          // Liste
          Expanded(
            child: results.isEmpty
                ? const _EmptyState()
                : ListView.builder(
              padding: EdgeInsets.fromLTRB(
                r.pagePadding, AppSpacing.sm,
                r.pagePadding, AppSpacing.lg,
              ),
              itemCount:   results.length,
              itemBuilder: (_, i) => _PoliceDossierCard(
                signalement: results[i],
                onDetails:   () => _onDetails(results[i]),
                onTraiter:   () => _onTraiter(results[i]),
              ),
            ),
          ),

          // Bottom nav
          const _PoliceBottomNav(currentIndex: 1),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  HEADER
// ─────────────────────────────────────────

class _DossiersHeader extends StatelessWidget {
  final AppResponsive r;
  final int           count;
  const _DossiersHeader({required this.r, required this.count});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(r.pagePadding, AppSpacing.md, r.pagePadding, AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mes dossiers', style: AppTextStyles.bodySemiBold.copyWith(fontSize: 18)),
            const SizedBox(height: 3),
            Text(
              '$count signalement${count > 1 ? "s" : ""} au total',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  RECHERCHE
// ─────────────────────────────────────────

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>  onChanged;
  const _SearchField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged:  onChanged,
      style:      AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        hintText:   'Rechercher par référence ou zone...',
        hintStyle:  AppTextStyles.bodyMedium.copyWith(color: AppColors.textDisabled),
        filled:     true,
        fillColor:  AppColors.surface,
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textHint, size: 20),
        border: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide:   const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide:   const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide:   const BorderSide(color: _policeBlue, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical:   AppSpacing.md,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  FILTRES
// ─────────────────────────────────────────

class _FilterChips extends StatelessWidget {
  final StatutPolice?               selected;
  final ValueChanged<StatutPolice?> onSelect;
  final double                      padding;
  const _FilterChips({required this.selected, required this.onSelect, required this.padding});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding:         EdgeInsets.symmetric(horizontal: padding),
        children: [
          _Chip(label: 'Tous',      isActive: selected == null,                      onTap: () => onSelect(null)),
          _Chip(label: 'À traiter', isActive: selected == StatutPolice.aTraiter,     onTap: () => onSelect(StatutPolice.aTraiter)),
          _Chip(label: 'En cours',  isActive: selected == StatutPolice.enCours,      onTap: () => onSelect(StatutPolice.enCours)),
          _Chip(label: 'Validé',    isActive: selected == StatutPolice.valide,       onTap: () => onSelect(StatutPolice.valide)),
          _Chip(label: 'Rejeté',    isActive: selected == StatutPolice.rejete,       onTap: () => onSelect(StatutPolice.rejete)),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String       label;
  final bool         isActive;
  final VoidCallback onTap;
  const _Chip({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration:   const Duration(milliseconds: 180),
        margin:     const EdgeInsets.only(right: AppSpacing.sm),
        padding:    const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color:        isActive ? _policeBlue : AppColors.surface,
          borderRadius: AppRadius.chip,
          border:       Border.all(color: isActive ? _policeBlue : AppColors.border),
        ),
        child: Text(
          label,
          style: AppTextStyles.badge.copyWith(
            color:    isActive ? AppColors.textOnPrimary : AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  CARD DOSSIER POLICIER
// ─────────────────────────────────────────

class _PoliceDossierCard extends StatelessWidget {
  final SignalementPolice signalement;
  final VoidCallback      onDetails;
  final VoidCallback      onTraiter;
  const _PoliceDossierCard({
    required this.signalement,
    required this.onDetails,
    required this.onTraiter,
  });

  @override
  Widget build(BuildContext context) {
    final s          = signalement;
    final isTraite   = s.statut == StatutPolice.valide || s.statut == StatutPolice.rejete;

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
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onDetails,
                  style: OutlinedButton.styleFrom(
                    padding:         const EdgeInsets.symmetric(vertical: 8),
                    minimumSize:     Size.zero,
                    side:            const BorderSide(color: AppColors.border),
                    foregroundColor: AppColors.textSecondary,
                    shape:           RoundedRectangleBorder(borderRadius: AppRadius.input),
                  ),
                  child: Text(
                    'Détails',
                    style: AppTextStyles.badge.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ElevatedButton(
                  onPressed: isTraite ? null : onTraiter,
                  style: ElevatedButton.styleFrom(
                    padding:         const EdgeInsets.symmetric(vertical: 8),
                    minimumSize:     Size.zero,
                    backgroundColor: isTraite ? AppColors.success : _policeBlue,
                    foregroundColor: AppColors.textOnPrimary,
                    elevation:       0,
                    shape:           RoundedRectangleBorder(borderRadius: AppRadius.input),
                  ),
                  child: Text(
                    isTraite ? '✓ ${s.statut.label}' : '✓ Traiter',
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
//  BOTTOMSHEET — Détails
// ─────────────────────────────────────────

class _DetailsSheet extends StatelessWidget {
  final SignalementPolice signalement;
  const _DetailsSheet({required this.signalement});

  @override
  Widget build(BuildContext context) {
    final s = signalement;
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
            child: Row(
              children: [
                Text(s.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.title, style: AppTextStyles.cardTitle),
                      Text(s.ref,   style: AppTextStyles.bodySmall),
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
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: AppSpacing.lg),
          _DetailRow(icon: Icons.access_time_rounded,    label: 'Reçu il y a',   value: s.time),
          _DetailRow(icon: Icons.location_on_rounded,    label: 'Zone',          value: s.zone),
          _DetailRow(icon: Icons.flag_rounded,            label: 'Priorité',      value: s.priorite.label),
          _DetailRow(icon: Icons.format_list_numbered,   label: 'Avancement',    value: 'Étape ${s.etape}/${s.totalEtapes}'),
          _DetailRow(icon: Icons.person_outline_rounded, label: 'Déclarant',     value: 'Anonyme'),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String   label;
  final String   value;
  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.md),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textHint),
          const SizedBox(width: AppSpacing.md),
          SizedBox(
            width: 80,
            child: Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint)),
          ),
          Expanded(
            child: Text(value, style: AppTextStyles.bodySemiBold.copyWith(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  BOTTOMSHEET — Traiter
// ─────────────────────────────────────────

class _TraiterSheet extends StatelessWidget {
  final SignalementPolice signalement;
  const _TraiterSheet({required this.signalement});

  @override
  Widget build(BuildContext context) {
    final s = signalement;
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
            child: Text('Traiter ce dossier', style: AppTextStyles.cardTitle),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text(s.ref, style: AppTextStyles.bodySmall),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Bouton Valider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: SizedBox(
              width:  double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:         Text('${s.ref} validé — récompense déclenchée !'),
                      backgroundColor: AppColors.success,
                      behavior:        SnackBarBehavior.floating,
                      shape:           RoundedRectangleBorder(borderRadius: AppRadius.card),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _policeBlue,
                  foregroundColor: AppColors.textOnPrimary,
                  elevation:       0,
                  shape:           RoundedRectangleBorder(borderRadius: AppRadius.input),
                ),
                icon:  const Icon(Icons.check_circle_outline_rounded, size: 18),
                label: Text('Valider — déclencher la récompense', style: AppTextStyles.buttonLabel),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Bouton Rejeter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: SizedBox(
              width:  double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:         Text('${s.ref} rejeté.'),
                      backgroundColor: AppColors.primary,
                      behavior:        SnackBarBehavior.floating,
                      shape:           RoundedRectangleBorder(borderRadius: AppRadius.card),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side:            const BorderSide(color: AppColors.border),
                  foregroundColor: AppColors.primary,
                  shape:           RoundedRectangleBorder(borderRadius: AppRadius.input),
                ),
                icon:  const Icon(Icons.cancel_outlined, size: 18),
                label: Text(
                  'Rejeter ce signalement',
                  style: AppTextStyles.buttonLabel.copyWith(color: AppColors.primary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  ÉTAT VIDE
// ─────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width:      60,
            height:     60,
            decoration: BoxDecoration(
              color:        const Color(0xFFEAF1FB),
              borderRadius: AppRadius.input,
            ),
            child: const Icon(Icons.folder_open_outlined, color: _policeBlue, size: 30),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Aucun dossier trouvé', style: AppTextStyles.bodySemiBold),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Essayez un autre filtre ou terme de recherche.',
            style:     AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
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
              _NavItem(icon: Icons.home_rounded,           label: 'Accueil',  index: 0, current: currentIndex, onTap: () => context.goNamed('police_dashboard')),
              _NavItem(icon: Icons.folder_outlined,         label: 'Dossiers', index: 1, current: currentIndex, onTap: () {}),
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
  const _NavItem({required this.icon, required this.label, required this.index, required this.current, required this.onTap});

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