import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/report/tracking_screen.dart';
import '../../features/starter/onbaording_screen.dart';
import '../../features/starter/portal_screen.dart';
import '../../features/starter/splahscreen_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../../features/report/report_screen.dart';
import '../../features/report/confirmation_screen.dart';

class AppRoutes {
  AppRoutes._();
  static const String splash       = '/';
  static const String onboarding   = '/onboarding';
  static const String portal       = '/portal';
  static const String report       = '/report';
  static const String confirmation = '/report/confirmation';
  static const String tracking     = '/tracking';
  static const String login        = '/login';
  static const String register     = '/register';
  static const String profile      = '/profile';
}

class AppRouter {
  AppRouter._();

  static GoRouter create() {
    return GoRouter(
      initialLocation: AppRoutes.splash,
      routes: [
        GoRoute(
          path:    AppRoutes.splash,
          name:    'splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path:    AppRoutes.onboarding,
          name:    'onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path:    AppRoutes.portal,
          name:    'portal',
          builder: (context, state) => const PortalScreen(),
        ),
        GoRoute(
          path:    AppRoutes.report,
          name:    'report',
          builder: (context, state) => const ReportScreen(),
          routes: [
            GoRoute(
              path:    'confirmation',
              name:    'confirmation',
              builder: (context, state) {
                final ref = state.extra as String? ?? '#DK-2024-0000';
                return ConfirmationScreen(refNumber: ref);
              },
            ),
          ],
        ),
        GoRoute(
          path:    AppRoutes.tracking,
          name:    'tracking',
          builder: (context, state) => const TrackingScreen(),
        ),
        GoRoute(
          path:    AppRoutes.login,
          name:    'login',
          builder: (context, state) => const _Placeholder('Connexion'),
        ),
        GoRoute(
          path:    AppRoutes.register,
          name:    'register',
          builder: (context, state) => const _Placeholder('Inscription'),
        ),
        GoRoute(
          path:    AppRoutes.profile,
          name:    'profile',
          builder: (context, state) => const _Placeholder('Mon espace'),
        ),
      ],
      errorBuilder: (context, state) => const _Placeholder('Page introuvable'),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final String label;
  const _Placeholder(this.label);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(child: Text(label, style: AppTextStyles.cardTitle)),
    );
  }
}