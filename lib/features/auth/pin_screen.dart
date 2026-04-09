import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/responsive/app_responsive.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String _pin        = '';
  String _confirmPin = '';
  bool   _isConfirm  = false;
  bool   _hasError   = false;

  static const int _pinLength = 6;

  void _onKeyTap(String digit) {
    if (_isConfirm) {
      if (_confirmPin.length < _pinLength) {
        setState(() {
          _confirmPin += digit;
          _hasError    = false;
        });
        if (_confirmPin.length == _pinLength) _onConfirmComplete();
      }
    } else {
      if (_pin.length < _pinLength) {
        setState(() => _pin += digit);
        if (_pin.length == _pinLength) _onPinComplete();
      }
    }
  }

  void _onDelete() {
    setState(() {
      _hasError = false;
      if (_isConfirm) {
        if (_confirmPin.isNotEmpty) _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
      } else {
        if (_pin.isNotEmpty) _pin = _pin.substring(0, _pin.length - 1);
      }
    });
  }

  void _onPinComplete() {
    // Passer à la confirmation
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() => _isConfirm = true);
    });
  }

  void _onConfirmComplete() {
    if (_pin == _confirmPin) {
      // PIN OK → portail
      Future.delayed(const Duration(milliseconds: 300), () {
        context.goNamed('dashboard');
      });
    } else {
      // PIN incorrect → réessayer
      setState(() {
        _hasError   = true;
        _confirmPin = '';
      });
    }
  }

  String get _currentPin => _isConfirm ? _confirmPin : _pin;

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _PinHeader(isConfirm: _isConfirm, hasError: _hasError, r: r),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: r.pagePadding),
                child: Column(
                  children: [
                    SizedBox(height: r.spacing(small: 40, normal: 52, large: 60)),

                    // Points indicateurs
                    _PinDots(filled: _currentPin.length, hasError: _hasError),

                    if (_hasError) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Les codes ne correspondent pas. Réessayez.',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
                        textAlign: TextAlign.center,
                      ),
                    ],

                    SizedBox(height: r.spacing(small: 48, normal: 56, large: 64)),

                    // Clavier numérique
                    _Keypad(onTap: _onKeyTap, onDelete: _onDelete),

                    SizedBox(height: r.bottomSafeH + AppSpacing.xl),
                  ],
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
//  HEADER ROUGE
// ─────────────────────────────────────────

class _PinHeader extends StatelessWidget {
  final bool         isConfirm;
  final bool         hasError;
  final AppResponsive r;
  const _PinHeader({required this.isConfirm, required this.hasError, required this.r});

  @override
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ColoredBox(
        color: hasError ? AppColors.primaryDark : AppColors.primary,
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Positioned(top: -35, right: -25, child: _DecoCircle(size: 110, opacity: .09)),
              Positioned(top:  10, right:  20, child: _DecoCircle(size:  65, opacity: .07)),
              Positioned(top:  42, right:  58, child: _DecoCircle(size:  34, opacity: .06)),
              Padding(
                padding: EdgeInsets.fromLTRB(r.pagePadding, 20, r.pagePadding, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        key:   ValueKey(isConfirm),
                        isConfirm ? 'Confirmez votre code PIN' : 'Créez votre code PIN',
                        style: AppTextStyles.screenTitle,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isConfirm
                          ? 'Saisissez à nouveau votre code'
                          : '6 chiffres — pour vous reconnecter',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textOnPrimary.withOpacity(0.65),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DecoCircle extends StatelessWidget {
  final double size;
  final double opacity;
  const _DecoCircle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:      size,
      height:     size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}

// ─────────────────────────────────────────
//  POINTS INDICATEURS
// ─────────────────────────────────────────

class _PinDots extends StatelessWidget {
  final int  filled;
  final bool hasError;
  const _PinDots({required this.filled, required this.hasError});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (i) {
        final isFilled = i < filled;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width:  isFilled ? 18 : 16,
          height: isFilled ? 18 : 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? AppColors.primary : Colors.transparent,
            border: Border.all(
              color: isFilled ? AppColors.primary : AppColors.textHint,
              width: 2,
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────
//  CLAVIER NUMÉRIQUE
// ─────────────────────────────────────────

class _Keypad extends StatelessWidget {
  final ValueChanged<String> onTap;
  final VoidCallback         onDelete;

  const _Keypad({required this.onTap, required this.onDelete});

  static const _keys = [
    ['1', ''],    ['2', 'ABC'],  ['3', 'DEF'],
    ['4', 'GHI'], ['5', 'JKL'],  ['6', 'MNO'],
    ['7', 'PQRS'],['8', 'TUV'],  ['9', 'WXYZ'],
    ['', ''],     ['0', ''],     ['del', ''],
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap:  true,
      physics:     const NeverScrollableScrollPhysics(),
      itemCount:   _keys.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:   3,
        mainAxisSpacing:  10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.6,
      ),
      itemBuilder: (_, i) {
        final key = _keys[i];
        final digit = key[0];
        final alpha = key[1];

        // Touche vide
        if (digit.isEmpty) return const SizedBox.shrink();

        // Touche suppression
        if (digit == 'del') {
          return GestureDetector(
            onTap: onDelete,
            child: Container(
              decoration: BoxDecoration(
                color:        AppColors.primaryLight,
                borderRadius: AppRadius.input,
                border:       Border.all(color: const Color(0xFFF5C4C4)),
              ),
              child: const Center(
                child: Icon(Icons.backspace_outlined, color: AppColors.primary, size: 22),
              ),
            ),
          );
        }

        // Touche chiffre
        return GestureDetector(
          onTap: () => onTap(digit),
          child: Container(
            decoration: BoxDecoration(
              color:        AppColors.surface,
              borderRadius: AppRadius.input,
              border:       Border.all(color: AppColors.border),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  digit,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 22),
                ),
                if (alpha.isNotEmpty)
                  Text(
                    alpha,
                    style: AppTextStyles.sectionLabel.copyWith(fontSize: 8),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}