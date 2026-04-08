// ============================================================
//  AlertCitoyen — Cercles décoratifs partagés
//  Fichier : lib/core/widgets/deco_circles.dart
// ============================================================

import 'package:flutter/material.dart';

import '../core/responsive/app_responsive.dart';
import '../core/theme/app_colors.dart';

class DecoCircles extends StatelessWidget {
  const DecoCircles({super.key});

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive(context);
    final w = r.screenWidth;
    final h = r.screenHeight;

    return Stack(
      children: [
        Circle(size: w * .55, color: AppColors.deco1, top: -h * .07, right: -w * .12),
        Circle(size: w * .30, color: AppColors.deco2, top:  h * .02, right:  w * .05),
        Circle(size: w * .14, color: AppColors.deco3, top:  h * .10, right:  w * .26),
        Circle(size: w * .44, color: AppColors.deco1, bottom: -h * .05, left: -w * .10),
        Circle(size: w * .20, color: AppColors.deco2, bottom:  h * .04, left:  w * .12),
      ],
    );
  }
}


// ─────────────────────────────────────────
//  Variante sans cercles en bas
//  (pour les écrans avec contenu scrollable)
// ─────────────────────────────────────────

class DecoCirclesTop extends StatelessWidget {
  const DecoCirclesTop({super.key});

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive(context);
    final w = r.screenWidth;
    final h = r.screenHeight;

    return Stack(
      children: [
        Circle(size: w * .55, color: AppColors.deco1, top: -h * .07, right: -w * .12),
        Circle(size: w * .30, color: AppColors.deco2, top:  h * .02, right:  w * .05),
        Circle(size: w * .14, color: AppColors.deco3, top:  h * .10, right:  w * .26),
      ],
    );
  }
}


// ─────────────────────────────────────────
//  Cercle interne
// ─────────────────────────────────────────

class Circle extends StatelessWidget {
  final double  size;
  final Color   color;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const Circle({
    required this.size,
    required this.color,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top:    top,
      bottom: bottom,
      left:   left,
      right:  right,
      child: Container(
        width:      size,
        height:     size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}