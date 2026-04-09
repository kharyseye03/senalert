// ============================================================
//  AlertCitoyen — Auth : Numéro de téléphone
//  Fichier : lib/features/auth/phone_screen.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/responsive/app_responsive.dart';
import '../../widget/deco_circles.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final _phoneController = TextEditingController();
  bool _isValid = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    // Numéro sénégalais valide = 9 chiffres
    setState(() => _isValid = value.replaceAll(' ', '').length >= 9);
  }

  void _onSubmit() {
    if (!_isValid) return;
    context.goNamed('otp', extra: _phoneController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          const DecoCircles(),
          SafeArea(
            child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: r.pagePadding),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: r.spacing(small: 40, normal: 52, large: 64)),
                                
                      // Logo
                      Container(
                        width:      52,
                        height:     52,
                        decoration: const BoxDecoration(
                          color:        AppColors.primary,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        child: const Icon(Icons.shield_rounded, color: AppColors.textOnPrimary, size: 28),
                      ),
                                
                      SizedBox(height: r.spacing(small: 18, normal: 22, large: 28)),
                                
                      // Titre
                      Text('Mon espace', style: AppTextStyles.greeting),
                      const SizedBox(height: AppSpacing.xs),
                      Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text:  'Entrez votre\nnuméro ',
                            style: AppTextStyles.heroTitle.copyWith(fontSize: r.heroFontSize),
                          ),
                          TextSpan(
                            text:  'mobile',
                            style: AppTextStyles.heroTitle.copyWith(
                              fontSize: r.heroFontSize,
                              color:    AppColors.primary,
                            ),
                          ),
                        ]),
                      ),
                                
                      SizedBox(height: r.spacing(small: 8, normal: 10, large: 12)),
                      Text(
                        'Nous vous enverrons un code SMS\npour confirmer votre identité.',
                        style: AppTextStyles.onboardingBody,
                      ),
                                
                      SizedBox(height: r.spacing(small: 24, normal: 30, large: 36)),
                                
                      // Champ téléphone
                      _PhoneField(
                        controller: _phoneController,
                        onChanged:  _onChanged,
                        onSubmit:   _onSubmit,
                      ),
                                
                      const Spacer(),
                                
                      // Bouton
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity:  _isValid ? 1.0 : 0.5,
                        child: SizedBox(
                          width:  double.infinity,
                          height: r.primaryBtnHeight,
                          child: ElevatedButton(
                            onPressed: _isValid ? _onSubmit : null,
                            child: Text('Recevoir le code SMS', style: AppTextStyles.buttonLabel),
                          ),
                        ),
                      ),
                                
                      const SizedBox(height: AppSpacing.md),
                       Text(
                        'En continuant, vous acceptez nos conditions d\'utilisation.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Déjà un compte ? ',
                            style: AppTextStyles.bodySmall,
                          ),
                          GestureDetector(
                            onTap: () => context.goNamed('login'),
                            child: Text(
                              'Se connecter',
                              style: AppTextStyles.bodySmall.copyWith(
                                color:      AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                                
                      SizedBox(height: r.bottomSafeH + AppSpacing.lg),
                    ],
                  ),
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
//  CHAMP TÉLÉPHONE
// ─────────────────────────────────────────

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>  onChanged;
  final VoidCallback          onSubmit;

  const _PhoneField({
    required this.controller,
    required this.onChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: AppRadius.card,
        border:       Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Sélecteur pays (statique pour l'instant)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical:   AppSpacing.md,
            ),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                const Text('🇸🇳', style: TextStyle(fontSize: 20)),
                const SizedBox(width: AppSpacing.sm),
                Text('+221', style: AppTextStyles.bodySemiBold),
                const SizedBox(width: AppSpacing.xs),
                const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textHint, size: 18),
              ],
            ),
          ),

          // Input numéro
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: TextField(
              controller:     controller,
              keyboardType:   TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _PhoneFormatter(),
              ],
              style:          AppTextStyles.bodySemiBold.copyWith(fontSize: 16),
              onChanged:      onChanged,
              onSubmitted:    (_) => onSubmit(),
              decoration:     InputDecoration(
                hintText:       '77 XXX XX XX',
                hintStyle:      AppTextStyles.bodyMedium.copyWith(
                  color:    AppColors.textDisabled,
                  fontSize: 16,
                ),
                border:         InputBorder.none,
                enabledBorder:  InputBorder.none,
                focusedBorder:  InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Formateur : 77 123 45 67
class _PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue old, TextEditingValue next) {
    final digits = next.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length && i < 9; i++) {
      if (i == 2 || i == 5 || i == 7) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final str = buffer.toString();
    return next.copyWith(
      text:      str,
      selection: TextSelection.collapsed(offset: str.length),
    );
  }
}