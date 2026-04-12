import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/responsive/app_responsive.dart';
import '../../widget/deco_circles.dart';

// Couleur principale espace policier
const _policeBlue = Color(0xFF1A56A0);
const _policeBlueLLight = Color(0xFFEAF1FB);

class PoliceLoginScreen extends StatefulWidget {
  const PoliceLoginScreen({super.key});

  @override
  State<PoliceLoginScreen> createState() => _PoliceLoginScreenState();
}

class _PoliceLoginScreenState extends State<PoliceLoginScreen> {
  final _matriculeController = TextEditingController();
  final _passwordController  = TextEditingController();
  bool  _passwordVisible     = false;
  bool  _isLoading           = false;

  @override
  void dispose() {
    _matriculeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _matriculeController.text.trim().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty;

  void _onSubmit() async {
    if (!_isValid) return;

    setState(() => _isLoading = true);

    // Simulation — remplace par appel API
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() => _isLoading = false);

    if (mounted) context.goNamed('police_dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive(context);

    return Scaffold(
      backgroundColor: AppColors.background,
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
                      SizedBox(height: r.spacing(small: 16, normal: 20, large: 24)),

                      // Bouton retour
                      InkWell(
                        onTap: () {
                          if (context.canPop()) context.pop();
                          else context.goNamed('portal');
                        },
                        borderRadius: AppRadius.input,
                        child: Container(
                          width:      34,
                          height:     34,
                          decoration: BoxDecoration(
                            color:        AppColors.surface,
                            borderRadius: AppRadius.input,
                            border:       Border.all(color: AppColors.border),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.textPrimary,
                            size:  16,
                          ),
                        ),
                      ),

                      SizedBox(height: r.spacing(small: 22, normal: 26, large: 32)),

                      // Badge policier
                      _PoliceBadge(),

                      SizedBox(height: r.spacing(small: 22, normal: 26, large: 32)),

                      // Titre
                      Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text:  'Connexion\n',
                            style: AppTextStyles.heroTitle.copyWith(
                              fontSize: r.heroFontSize,
                            ),
                          ),
                          TextSpan(
                            text:  'agent',
                            style: AppTextStyles.heroTitle.copyWith(
                              fontSize: r.heroFontSize,
                              color:    _policeBlue,
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Utilisez vos identifiants fournis par\nvotre supérieur hiérarchique.',
                        style: AppTextStyles.onboardingBody,
                      ),

                      SizedBox(height: r.spacing(small: 24, normal: 28, large: 32)),

                      // Matricule
                      _FieldLabel(text: 'Numéro de matricule'),
                      const SizedBox(height: AppSpacing.sm),
                      _PoliceInput(
                        controller:  _matriculeController,
                        hint:        'Ex: SN-2024-0042',
                        inputType:   TextInputType.text,
                        onChanged:   (_) => setState(() {}),
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Mot de passe
                      _FieldLabel(text: 'Mot de passe'),
                      const SizedBox(height: AppSpacing.sm),
                      _PoliceInput(
                        controller:      _passwordController,
                        hint:            '••••••••',
                        isPassword:      true,
                        passwordVisible: _passwordVisible,
                        onTogglePassword: () => setState(() => _passwordVisible = !_passwordVisible),
                        onChanged:       (_) => setState(() {}),
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Info
                      Container(
                        padding:    const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color:        _policeBlueLLight,
                          borderRadius: AppRadius.input,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline_rounded, color: _policeBlue, size: 16),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                'Vos identifiants sont créés par votre responsable. En cas de problème, contactez votre hiérarchie.',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: _policeBlue,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      SizedBox(height: r.spacing(small: 20, normal: 24, large: 28)),

                      // Bouton connexion
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity:  _isValid ? 1.0 : 0.5,
                        child: SizedBox(
                          width:  double.infinity,
                          height: r.primaryBtnHeight,
                          child: ElevatedButton(
                            onPressed: _isValid && !_isLoading ? _onSubmit : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _policeBlue,
                              foregroundColor: AppColors.textOnPrimary,
                              elevation:       0,
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.input,
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                              width:  20,
                              height: 20,
                              child:  CircularProgressIndicator(
                                strokeWidth: 2,
                                color:       AppColors.textOnPrimary,
                              ),
                            )
                                : Text('Se connecter', style: AppTextStyles.buttonLabel),
                          ),
                        ),
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
//  BADGE POLICIER
// ─────────────────────────────────────────

class _PoliceBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
              // Icône bouclier bleu
              Container(
                width:      44,
                height:     44,
                decoration: BoxDecoration(
                  color:        _policeBlue,
                  borderRadius: AppRadius.input,
                ),
                child: const Icon(
                  Icons.shield_rounded,
                  color: AppColors.textOnPrimary,
                  size:  24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Espace Policier',
                    style: AppTextStyles.bodySemiBold.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Accès réservé aux agents',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Drapeau Sénégal
          ClipRRect(
            borderRadius: AppRadius.chip,
            child: Row(
              children: [
                // Vert
                Expanded(child: Container(height: 6, color: const Color(0xFF009A44))),
                // Jaune avec étoile
                Expanded(
                  child: Container(
                    height: 6,
                    color:  const Color(0xFFFDEF42),
                    child:  const Center(
                      child: Text(
                        '★',
                        style: TextStyle(
                          fontSize: 5,
                          color:    Color(0xFF009A44),
                          height:   1,
                        ),
                      ),
                    ),
                  ),
                ),
                // Rouge
                Expanded(child: Container(height: 6, color: const Color(0xFFE31B23))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  LABEL CHAMP
// ─────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.bodySemiBold.copyWith(fontSize: 14),
    );
  }
}

// ─────────────────────────────────────────
//  INPUT POLICIER
// ─────────────────────────────────────────

class _PoliceInput extends StatelessWidget {
  final TextEditingController controller;
  final String                hint;
  final TextInputType         inputType;
  final bool                  isPassword;
  final bool                  passwordVisible;
  final VoidCallback?         onTogglePassword;
  final ValueChanged<String>  onChanged;

  const _PoliceInput({
    required this.controller,
    required this.hint,
    this.inputType       = TextInputType.text,
    this.isPassword      = false,
    this.passwordVisible = false,
    this.onTogglePassword,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller:          controller,
      keyboardType:        inputType,
      obscureText:         isPassword && !passwordVisible,
      onChanged:           onChanged,
      style:               AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        hintText:    hint,
        hintStyle:   AppTextStyles.bodyMedium.copyWith(color: AppColors.textDisabled),
        filled:      true,
        fillColor:   AppColors.surface,
        suffixIcon:  isPassword
            ? IconButton(
          icon: Icon(
            passwordVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: AppColors.textHint,
            size:  20,
          ),
          onPressed: onTogglePassword,
        )
            : null,
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