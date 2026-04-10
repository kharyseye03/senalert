import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_dimensions.dart';
import '../core/theme/app_text_styles.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;

  const BottomNav({super.key, required this.currentIndex});

  static const _items = [
    _NavItemData(icon: Icons.home_rounded,       label: 'Accueil',  route: 'dashboard'),
    _NavItemData(icon: Icons.folder_outlined,     label: 'Dossiers', route: 'dossiers'),
    _NavItemData(icon: Icons.map_outlined,        label: 'Carte',    route: 'carte'),
    _NavItemData(icon: Icons.person_outline_rounded, label: 'Profil', route: 'profile'),
  ];

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
            children: List.generate(_items.length, (i) {
              final item     = _items[i];
              final isActive = i == currentIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (!isActive) context.goNamed(item.route);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        size:  22,
                        color: isActive ? AppColors.primary : AppColors.textHint,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
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
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final String   label;
  final String   route;
  const _NavItemData({required this.icon, required this.label, required this.route});
}