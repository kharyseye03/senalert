import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/responsive/app_responsive.dart';
import '../../widget/deco_circles.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
  List.generate(6, (_) => FocusNode());

  int  _secondsLeft = 60;
  bool _canResend   = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft == 0) {
        t.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _onResend() {
    setState(() {
      _secondsLeft = 60;
      _canResend   = false;
    });
    _startTimer();
    // Ici appel API pour renvoyer le SMS
  }

  void _onDigitEntered(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    // Si tous les champs sont remplis → soumettre
    final code = _controllers.map((c) => c.text).join();
    if (code.length == 6) _onSubmit(code);
  }

  void _onBackspace(int index) {
    if (index > 0 && _controllers[index].text.isEmpty) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
    }
  }

  void _onSubmit(String code) {
    // Simulation statique → on redirige vers PIN
    context.goNamed('pin');
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: r.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: r.spacing(small: 16, normal: 20, large: 24)),

                  // Retour
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width:      34,
                      height:     34,
                      decoration: BoxDecoration(
                        color:        AppColors.background,
                        borderRadius: AppRadius.input,
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, size: 15, color: AppColors.textSecondary),
                    ),
                  ),

                  SizedBox(height: r.spacing(small: 24, normal: 30, large: 36)),

                  // Titre
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text:  'Code de\n',
                        style: AppTextStyles.heroTitle.copyWith(fontSize: r.heroFontSize),
                      ),
                      TextSpan(
                        text:  'vérification',
                        style: AppTextStyles.heroTitle.copyWith(
                          fontSize: r.heroFontSize,
                          color:    AppColors.primary,
                        ),
                      ),
                    ]),
                  ),

                  const SizedBox(height: AppSpacing.sm),
                  RichText(
                    text: TextSpan(
                      style: AppTextStyles.onboardingBody,
                      children: [
                        const TextSpan(text: 'Code envoyé au '),
                        TextSpan(
                          text:  '+221 ${widget.phoneNumber}',
                          style: AppTextStyles.onboardingBody.copyWith(
                            color:      AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(text: '.\nValable 10 minutes.'),
                      ],
                    ),
                  ),

                  SizedBox(height: r.spacing(small: 28, normal: 36, large: 44)),

                  // Boites OTP
                  _OtpBoxes(
                    controllers: _controllers,
                    focusNodes:  _focusNodes,
                    onChanged:   _onDigitEntered,
                    onBackspace: _onBackspace,
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Timer + renvoyer
                  _TimerRow(
                    secondsLeft: _secondsLeft,
                    canResend:   _canResend,
                    onResend:    _onResend,
                  ),

                  const Spacer(),

                  // Bouton vérifier
                  SizedBox(
                    width:  double.infinity,
                    height: r.primaryBtnHeight,
                    child: ElevatedButton(
                      onPressed: () {
                        final code = _controllers.map((c) => c.text).join();
                        if (code.length == 6) _onSubmit(code);
                      },
                      child: Text('Vérifier →', style: AppTextStyles.buttonLabel),
                    ),
                  ),

                  SizedBox(height: r.bottomSafeH + AppSpacing.lg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  BOITES OTP
// ─────────────────────────────────────────

class _OtpBoxes extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode>             focusNodes;
  final void Function(int, String)  onChanged;
  final ValueChanged<int>           onBackspace;

  const _OtpBoxes({
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (i) {
        return SizedBox(
          width:  44,
          height: 52,
          child: TextField(
            controller:      controllers[i],
            focusNode:       focusNodes[i],
            textAlign:       TextAlign.center,
            keyboardType:    TextInputType.number,
            maxLength:       1,
            style:           AppTextStyles.heroTitle.copyWith(
              fontSize: 22,
              color:    AppColors.primary,
            ),
            decoration: InputDecoration(
              counterText:   '',
              filled:        true,
              fillColor:     controllers[i].text.isNotEmpty
                  ? AppColors.primaryLight
                  : AppColors.surface,
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
                borderSide:   const BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (v) => onChanged(i, v),
            onTap: () {
              controllers[i].selection = TextSelection.fromPosition(
                TextPosition(offset: controllers[i].text.length),
              );
            },
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────
//  TIMER + RENVOYER
// ─────────────────────────────────────────

class _TimerRow extends StatelessWidget {
  final int          secondsLeft;
  final bool         canResend;
  final VoidCallback onResend;

  const _TimerRow({
    required this.secondsLeft,
    required this.canResend,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!canResend) ...[
          Container(
            width:      32,
            height:     32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border, width: 2.5),
            ),
            child: Center(
              child: Text(
                '${secondsLeft}s',
                style: AppTextStyles.bodySmall.copyWith(
                  color:      AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize:   9,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text('Renvoyer le code dans', style: AppTextStyles.bodySmall),
        ] else
          TextButton(
            onPressed: onResend,
            child: Text(
              'Renvoyer le code',
              style: AppTextStyles.bodySemiBold.copyWith(color: AppColors.primary),
            ),
          ),
      ],
    );
  }
}



