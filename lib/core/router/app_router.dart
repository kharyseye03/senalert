import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/otp_screen.dart';
import '../../features/auth/phone_screen.dart';
import '../../features/auth/pin_screen.dart';
import '../../features/auth/police_login_screen.dart';
import '../../features/profil/agent/dashbaord/police_dashboard_screen.dart';
import '../../features/profil/agent/dossier/police_dossiers_screen.dart';
import '../../features/profil/agent/profil/police_profil_screen.dart';
import '../../features/profil/citoyen/dashabord/dashbaord_citoyen.dart';
import '../../features/profil/citoyen/dossier/dossier_screen.dart';
import '../../features/profil/citoyen/profil/profil_screen.dart';
import '../../features/profil/citoyen/recompense/recompenses_screen.dart';
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
  static const String dashboard      = '/dashboard';
  static const String dashboard_police      = '/police_dashboard';
}

class AppRouter {
  AppRouter._();

  static GoRouter create() {
    return GoRouter(
      //initialLocation: AppRoutes.splash,
      //initialLocation: AppRoutes.dashboard,
      initialLocation: AppRoutes.dashboard_police,
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
                return ConfirmationSheet(refNumber: ref);
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
          builder: (context, state) => const PhoneScreen(),
          routes: [
            GoRoute(
              path:    'otp',
              name:    'otp',
              builder: (context, state) {
                final phone = state.extra as String? ?? '';
                return OtpScreen(phoneNumber: phone);
              },
            ),
            GoRoute(
              path:    'pin',
              name:    'pin',
              builder: (context, state) => const PinScreen(),
            ),
          ],
        ),
        GoRoute(
          path:    AppRoutes.dashboard,
          name:    'dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),

        GoRoute(
          path:    '/recompenses',
          name:    'recompenses',
          builder: (context, state) => const RecompensesScreen(),
        ),

        GoRoute(
          path:    '/profile',
          name:    'profile',
          builder: (context, state) => const ProfilScreen(),
        ),

        GoRoute(
          path:    AppRoutes.register,
          name:    'register',
          builder: (context, state) => const _Placeholder('Inscription'),
        ),

        GoRoute(
          path:    '/dossiers',
          name:    'dossiers',
          builder: (context, state) => const DossiersScreen(),
        ),

        GoRoute(
          path:    '/police-login',
          name:    'police_login',
          builder: (context, state) => const PoliceLoginScreen(),
        ),

        GoRoute(
          path:    AppRoutes.dashboard_police,
          name:    'police_dashboard',
          builder: (context, state) => const PoliceDashboardScreen(),
        ),

        GoRoute(
          path:    '/police-dossiers',
          name:    'police_dossiers',
          builder: (context, state) => const PoliceDossiersScreen(),
        ),

        GoRoute(
          path:    '/police-profil',
          name:    'police_profil',
          builder: (context, state) => const PoliceProfilScreen(),
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