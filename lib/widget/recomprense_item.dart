import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_dimensions.dart';
import '../core/theme/app_text_styles.dart';

class RecompenseItem extends StatelessWidget {
  final String title;
  final String ref;
  final String amount;
  final String date;
  final bool   isPending;

  const RecompenseItem({
    super.key,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:    AppTextStyles.bodySemiBold.copyWith(fontSize: 12),
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