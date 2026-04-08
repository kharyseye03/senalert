// ============================================================
//  AlertCitoyen — Point d'entrée
//  Fichier : lib/main.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor:          Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(const AlertCitoyenApp());
}

class AlertCitoyenApp extends StatelessWidget {
  const AlertCitoyenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title:'AlertCitoyen',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: AppRouter.create(),
    );
  }
}