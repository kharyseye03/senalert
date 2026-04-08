import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/router/app_router.dart';
import '../../core/responsive/app_responsive.dart';
import '../../widget/deco_circles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    // ── Animations ─────────────────────────────
    _controller = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve:  Curves.easeOut,
    );

    _scaleAnim = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    // ── Navigation après 2.5s ──────────────────
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) context.goNamed('onboarding');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [

          // ── Cercles décoratifs ────────────────
          const DecoCircles(),

          // ── Contenu centré ────────────────────
          Center(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: ScaleTransition(
                scale: _scaleAnim,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // Logo / icône
                    _LogoIcon(size: r.spacing(small: 72, normal: 84, large: 96)),

                    SizedBox(height: r.spacing(small: 20, normal: 24, large: 28)),

                    // Nom de l'app
                    Text(
                      'AlertCitoyen',
                      style: AppTextStyles.heroTitle.copyWith(
                        fontSize: r.heroFontSize,
                      ),
                    ),

                    SizedBox(height: r.spacing(small: 8, normal: 10, large: 12)),

                    // Tagline
                    Text(
                      'Signalez. Protégez. Agissez.',
                      style: AppTextStyles.greeting,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Bas de page : mention ─────────────
          Positioned(
            bottom: r.bottomSafeH + r.spacing(small: 24, normal: 32, large: 40),
            left:   0,
            right:  0,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Text(
                'Police Nationale du Sénégal',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// ─────────────────────────────────────────
//  WIDGET — Icône logo
// ─────────────────────────────────────────

class _LogoIcon extends StatelessWidget {
  final double size;
  const _LogoIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:        size,
      height:       size,
      decoration:   const BoxDecoration(
        color:        AppColors.primary,
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: Center(
        child: Icon(
          Icons.shield_rounded,
          color: AppColors.textOnPrimary,
          size:  size * 0.52,
        ),
      ),
    );
  }
}


// ─────────────────────────────────────────
//  WIDGET — Cercles décoratifs
//  Identiques au design validé ensemble
// ─────────────────────────────────────────

class _DecoCircles extends StatelessWidget {
  final AppResponsive r;
  const _DecoCircles({required this.r});

  @override
  Widget build(BuildContext context) {
    final w = r.screenWidth;
    final h = r.screenHeight;

    return Stack(
      children: [
        // ── Haut droite ──────────────────────
        Positioned(
          top:   -h * 0.08,
          right: -w * 0.14,
          child: Circle(size: w * 0.58, color: AppColors.deco1),
        ),
        Positioned(
          top:   h * 0.02,
          right: w * 0.04,
          child: Circle(size: w * 0.34, color: AppColors.deco2),
        ),
        Positioned(
          top:   h * 0.10,
          right: w * 0.24,
          child: Circle(size: w * 0.17, color: AppColors.deco3),
        ),

        // ── Bas gauche ───────────────────────
        Positioned(
          bottom: -h * 0.06,
          left:   -w * 0.12,
          child:  Circle(size: w * 0.50, color: AppColors.deco1),
        ),
        Positioned(
          bottom: h * 0.04,
          left:   w * 0.10,
          child:  Circle(size: w * 0.22, color: AppColors.deco2),
        ),
      ],
    );
  }
}