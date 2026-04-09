import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/responsive/app_responsive.dart';
import '../../widget/deco_circles.dart';

class _OnboardingData {
  final IconData icon;
  final String   title;
  final String   subtitle;
  //final Color    iconBg;
  const _OnboardingData({
    required this.icon,
    required this.title,
    required this.subtitle,
    //required this.iconBg,
  });
}

const _slides = [
  _OnboardingData(
    icon:     Icons.shield_rounded,
    title:    'Signalez en\nquelques secondes',
    subtitle: 'Photographiez, localisez et décrivez l\'incident. Votre signalement parvient immédiatement aux services compétents.',
    //iconBg:   AppColors.primaryLight,
  ),
  _OnboardingData(
    icon:     Icons.location_on_rounded,
    title:    'Votre position\nautomatiquement',
    subtitle: 'Le GPS détecte votre localisation en temps réel. Plus besoin de chercher votre adresse en situation d\'urgence.',
    //iconBg:   Color(0xFFEAF1FB),
  ),
  _OnboardingData(
    icon:     Icons.track_changes_rounded,
    title:    'Suivez votre\ndossier en direct',
    subtitle: 'Consultez l\'avancement de votre signalement étape par étape, de la réception jusqu\'à l\'intervention sur le terrain.',
    //iconBg:   AppColors.successLight,
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  bool get _isLastPage => _currentPage == _slides.length - 1;

  void _goToPortal() => context.goNamed('portal');

  void _onNext() {
    if (_isLastPage) {
      _goToPortal();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 380),
        curve:    Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
            child: Column(
              children: [
                // Bouton Passer
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.md, right: AppSpacing.xl),
                    child: TextButton(
                      onPressed: _goToPortal,
                      child: Text(
                        'Passer',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),

                // Slides
                Expanded(
                  child: PageView.builder(
                    controller:    _pageController,
                    itemCount:     _slides.length,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemBuilder:   (context, i) => _OnboardingSlide(
                      data: _slides[i],
                      r:    r,
                    ),
                  ),
                ),

                // Bas : dots + bouton
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    r.pagePadding, AppSpacing.lg,
                    r.pagePadding,
                    r.bottomSafeH + r.spacing(small: 20, normal: 28, large: 36),
                  ),
                  child: Column(
                    children: [
                      SmoothPageIndicator(
                        controller: _pageController,
                        count:      _slides.length,
                        effect:     ExpandingDotsEffect(
                          dotHeight:       7,
                          dotWidth:        7,
                          expansionFactor: 3,
                          spacing:         6,
                          activeDotColor:  AppColors.primary,
                          dotColor:        AppColors.deco2,
                        ),
                      ),
                      SizedBox(height: r.spacing(small: 28, normal: 36, large: 44)),
                      SizedBox(
                        width:  double.infinity,
                        height: r.primaryBtnHeight,
                        child: ElevatedButton(
                          onPressed: _onNext,
                          child: Text(
                            _isLastPage ? 'Commencer' : 'Suivant',
                            style: AppTextStyles.buttonLabel,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  final _OnboardingData data;
  final AppResponsive   r;
  const _OnboardingSlide({required this.data, required this.r});

  @override
  Widget build(BuildContext context) {
    final iconSize = r.spacing(small: 100, normal: 120, large: 136);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.pagePadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width:      iconSize,
            height:     iconSize,
            /*decoration: BoxDecoration(
              color: data.iconBg,
              shape: BoxShape.circle),*/
            child: Icon(data.icon, size: iconSize * 0.46, color: AppColors.primary),
          ),
          SizedBox(height: r.spacing(small: 32, normal: 40, large: 48)),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.heroTitle.copyWith(fontSize: r.heroFontSize - 2),
          ),
          SizedBox(height: r.spacing(small: 14, normal: 18, large: 22)),
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.onboardingBody,
          ),
        ],
      ),
    );
  }
}