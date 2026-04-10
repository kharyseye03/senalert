import 'package:flutter/material.dart';

import '../../../../core/responsive/app_responsive.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../model/signalement.dart';
import '../../../../widget/bottom_nav.dart';
import '../../../../widget/signalement_card.dart';

class DossiersScreen extends StatefulWidget {
  const DossiersScreen({super.key});

  @override
  State<DossiersScreen> createState() => _DossiersScreenState();
}

class _DossiersScreenState extends State<DossiersScreen> {
  final _searchController = TextEditingController();
  SignalementStatus? _selectedFilter;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Signalement> get _filtered {
    return kSignalements.where((s) {
      final matchStatus = _selectedFilter == null || s.status == _selectedFilter;
      final matchSearch = _searchQuery.isEmpty ||
          s.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.ref.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchStatus && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final r       = AppResponsive(context);
    final results = _filtered;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _DossiersHeader(r: r, count: results.length),
          Padding(
            padding: EdgeInsets.fromLTRB(r.pagePadding, 0, r.pagePadding, AppSpacing.sm),
            child: _SearchField(
              controller: _searchController,
              onChanged:  (v) => setState(() => _searchQuery = v),
            ),
          ),
          _FilterChips(
            selected: _selectedFilter,
            onSelect: (f) => setState(() => _selectedFilter = f),
            padding:  r.pagePadding,
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: results.isEmpty
                ? const _EmptyState()
                : ListView.builder(
              padding: EdgeInsets.fromLTRB(
                r.pagePadding, AppSpacing.sm,
                r.pagePadding, AppSpacing.lg,
              ),
              itemCount: results.length,
              itemBuilder: (_, i) {
                final s = results[i];
                return SignalementCard(
                  emoji:   s.emoji,
                  emojiBg: s.emojiBg,
                  title:   s.title,
                  ref:     s.ref,
                  time:    s.time,
                  status:  s.status,
                );
              },
            ),
          ),
          const BottomNav(currentIndex: 1),
        ],
      ),
    );
  }
}

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
            Text(
              'Mes dossiers',
              style: AppTextStyles.bodySemiBold.copyWith(fontSize: 18),
            ),
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
        hintText:   'Rechercher par titre ou référence...',
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
          borderSide:   const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical:   AppSpacing.md,
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final SignalementStatus?               selected;
  final ValueChanged<SignalementStatus?> onSelect;
  final double                           padding;
  const _FilterChips({required this.selected, required this.onSelect, required this.padding});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding:         EdgeInsets.symmetric(horizontal: padding),
        children: [
          _Chip(
            label: 'Tous',
            isActive: selected == null,
            onTap: () => onSelect(null)
          ),
          _Chip(
            label: 'En cours',
            isActive: selected == SignalementStatus.inProgress,
            onTap: () => onSelect(SignalementStatus.inProgress)
          ),
          _Chip(
            label: 'Traité',
            isActive: selected == SignalementStatus.resolved,
            onTap: () => onSelect(SignalementStatus.resolved)
          ),
          _Chip(
            label: 'En attente',
            isActive: selected == SignalementStatus.pending,
            onTap: () => onSelect(SignalementStatus.pending)
          ),
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
          color:        isActive ? AppColors.primary : AppColors.surface,
          borderRadius: AppRadius.chip,
          border:       Border.all(color: isActive ? AppColors.primary : AppColors.border),
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
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: AppRadius.input),
            child: const Icon(Icons.folder_open_outlined, color: AppColors.primary, size: 30),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text('Aucun dossier trouvé', style: AppTextStyles.bodySemiBold),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Essayez un autre filtre ou terme de recherche.',
            style:     AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}