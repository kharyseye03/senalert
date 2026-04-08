import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/responsive/app_responsive.dart';
import '../../widget/deco_circles.dart';

// ─────────────────────────────────────────
//  MODÈLE — Type d'incident
// ─────────────────────────────────────────

class _IncidentType {
  final String emoji;
  final String label;
  const _IncidentType({required this.emoji, required this.label});
}

const _types = [
  _IncidentType(emoji: '🔥', label: 'Incendie'),
  _IncidentType(emoji: '🚗', label: 'Accident'),
  _IncidentType(emoji: '⚠️', label: 'Violence'),
  _IncidentType(emoji: '🏥', label: 'Médical'),
  _IncidentType(emoji: '🔧', label: 'Voirie'),
  _IncidentType(emoji: '📋', label: 'Autre'),
];

// ─────────────────────────────────────────
//  ÉCRAN PRINCIPAL
// ─────────────────────────────────────────

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  // État du formulaire
  int     _selectedType = 0;
  bool    _isAnonymous  = true;

  // Contrôleurs
  final _descController   = TextEditingController();
  final _prenomController = TextEditingController();
  final _nomController    = TextEditingController();
  final _telController    = TextEditingController();

  @override
  void dispose() {
    _descController.dispose();
    _prenomController.dispose();
    _nomController.dispose();
    _telController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    // Validation basique
    if (!_isAnonymous) {
      if (_prenomController.text.trim().isEmpty ||
          _nomController.text.trim().isEmpty   ||
          _telController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Veuillez remplir vos informations ou activer le mode anonyme.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textOnPrimary),
            ),
            backgroundColor: AppColors.textPrimary,
            behavior:        SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
          ),
        );
        return;
      }
    }
    // Navigation vers confirmation
    context.goNamed('confirmation', extra: '#DK-2024-${DateTime.now().millisecond.toString().padLeft(4, '0')}');
  }

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const DecoCirclesTop(),
          Column(
            children: [
              // Header rouge
              _RedHeader(r: r),

              // Formulaire scrollable
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: r.pagePadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: r.spacing(small: 14, normal: 16, large: 20)),

                      // ① Anonyme en premier
                      _AnonymousToggle(
                        isAnonymous: _isAnonymous,
                        onChanged:   (v) => setState(() => _isAnonymous = v),
                      ),

                      // Bloc identité — visible si non anonyme
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve:    Curves.easeInOut,
                        child: _isAnonymous
                            ? const SizedBox.shrink()
                            : _IdentityFields(
                          prenomController: _prenomController,
                          nomController:    _nomController,
                          telController:    _telController,
                        ),
                      ),

                      SizedBox(height: r.spacing(small: 14, normal: 16, large: 20)),

                      // ② Type d'incident
                      const _SectionLabel(label: 'Type d\'incident'),
                      const SizedBox(height: AppSpacing.sm),
                      _IncidentTypeGrid(
                        selected:   _selectedType,
                        onSelected: (i) => setState(() => _selectedType = i),
                      ),

                      SizedBox(height: r.spacing(small: 14, normal: 16, large: 20)),

                      // ③ Localisation
                      const _SectionLabel(label: 'Localisation'),
                      const SizedBox(height: AppSpacing.sm),
                      const _LocationField(),

                      SizedBox(height: r.spacing(small: 14, normal: 16, large: 20)),

                      // ④ Description
                      const _SectionLabel(label: 'Description (optionnel)'),
                      const SizedBox(height: AppSpacing.sm),
                      _DescriptionField(controller: _descController),

                      SizedBox(height: r.spacing(small: 14, normal: 16, large: 20)),

                      // ⑤ Photo
                      const _SectionLabel(label: 'Photo (optionnel)'),
                      const SizedBox(height: AppSpacing.sm),
                      const _PhotoField(),

                      SizedBox(height: r.spacing(small: 24, normal: 28, large: 36)),
                    ],
                  ),
                ),
              ),

              // Bouton envoyer
              _SubmitButton(onTap: _onSubmit, r: r),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  HEADER ROUGE
// ─────────────────────────────────────────

class _RedHeader extends StatelessWidget {
  final AppResponsive r;
  const _RedHeader({required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(r.pagePadding, 12, r.pagePadding, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bouton retour
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width:      32,
                  height:     32,
                  decoration: BoxDecoration(
                    color:        AppColors.decoOnRed1,
                    borderRadius: AppRadius.input,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.textOnPrimary,
                    size:  16,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Nouveau signalement',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textOnPrimary.withOpacity(0.65),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Que s\'est-il\npassé ?',
                style: AppTextStyles.screenTitle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  TOGGLE ANONYME
// ─────────────────────────────────────────

class _AnonymousToggle extends StatelessWidget {
  final bool              isAnonymous;
  final ValueChanged<bool> onChanged;
  const _AnonymousToggle({required this.isAnonymous, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:    const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: AppRadius.card,
        border:       Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width:      40,
            height:     40,
            decoration: BoxDecoration(
              color:        isAnonymous ? AppColors.successLight : AppColors.primaryLight,
              borderRadius: AppRadius.input,
            ),
            child: Icon(
              isAnonymous ? Icons.visibility_off_rounded : Icons.person_outline_rounded,
              color: isAnonymous ? AppColors.success : AppColors.primary,
              size:  20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Signalement anonyme', style: AppTextStyles.bodySemiBold),
                const SizedBox(height: 2),
                Text(
                  isAnonymous
                      ? 'Votre identité reste confidentielle'
                      : 'Vos informations seront transmises',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value:           isAnonymous,
            onChanged:       onChanged,
            activeColor:     AppColors.success,
            inactiveThumbColor: AppColors.textHint,
            inactiveTrackColor: AppColors.surfaceAlt,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  CHAMPS IDENTITÉ
// ─────────────────────────────────────────

class _IdentityFields extends StatelessWidget {
  final TextEditingController prenomController;
  final TextEditingController nomController;
  final TextEditingController telController;

  const _IdentityFields({
    required this.prenomController,
    required this.nomController,
    required this.telController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:     const EdgeInsets.only(top: AppSpacing.md),
      padding:    const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: AppRadius.card,
        border:       Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person_outline_rounded, size: 14, color: AppColors.textHint),
              const SizedBox(width: AppSpacing.sm),
              Text('Vos informations', style: AppTextStyles.sectionLabel),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _InputField(
            controller:  prenomController,
            hint:        'Prénom',
            icon:        Icons.badge_outlined,
            inputType:   TextInputType.name,
            capitalization: TextCapitalization.words,
          ),
          const SizedBox(height: AppSpacing.sm),
          _InputField(
            controller:  nomController,
            hint:        'Nom de famille',
            icon:        Icons.badge_outlined,
            inputType:   TextInputType.name,
            capitalization: TextCapitalization.words,
          ),
          const SizedBox(height: AppSpacing.sm),
          _InputField(
            controller: telController,
            hint:       'Numéro de téléphone',
            icon:       Icons.phone_outlined,
            inputType:  TextInputType.phone,
            formatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController      controller;
  final String                     hint;
  final IconData                   icon;
  final TextInputType              inputType;
  final TextCapitalization         capitalization;
  final List<TextInputFormatter>?  formatters;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.inputType     = TextInputType.text,
    this.capitalization = TextCapitalization.none,
    this.formatters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:        AppColors.background,
        borderRadius: AppRadius.input,
        border:       Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const SizedBox(width: AppSpacing.md),
          Icon(icon, size: 16, color: AppColors.textHint),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              controller:          controller,
              keyboardType:        inputType,
              textCapitalization:  capitalization,
              inputFormatters:     formatters,
              style:               AppTextStyles.bodyMedium,
              decoration: InputDecoration(
                hintText:       hint,
                hintStyle:      AppTextStyles.bodyMedium.copyWith(color: AppColors.textDisabled),
                border:         InputBorder.none,
                enabledBorder:  InputBorder.none,
                focusedBorder:  InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  GRILLE TYPES D'INCIDENT
// ─────────────────────────────────────────

class _IncidentTypeGrid extends StatelessWidget {
  final int                selected;
  final ValueChanged<int>  onSelected;
  const _IncidentTypeGrid({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap:  true,
      physics:     const NeverScrollableScrollPhysics(),
      itemCount:   _types.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:   3,
        mainAxisSpacing:  8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.3,
      ),
      itemBuilder: (_, i) {
        final isSelected = i == selected;
        return GestureDetector(
          onTap: () => onSelected(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color:        isSelected ? AppColors.primaryLight : AppColors.surface,
              borderRadius: AppRadius.input,
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_types[i].emoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 4),
                Text(
                  _types[i].label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color:      isSelected ? AppColors.primary : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                    fontSize:   10,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────
//  LOCALISATION
// ─────────────────────────────────────────

class _LocationField extends StatelessWidget {
  const _LocationField();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:    const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: AppRadius.card,
        border:       Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width:      38,
            height:     38,
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: AppRadius.input),
            child: const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Plateau, Dakar', style: AppTextStyles.bodySemiBold),
                const SizedBox(height: 2),
                Text(
                  '✓ Position GPS détectée automatiquement',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.success, fontSize: 10),
                ),
              ],
            ),
          ),
          const Icon(Icons.edit_location_alt_outlined, color: AppColors.textHint, size: 18),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  DESCRIPTION
// ─────────────────────────────────────────

class _DescriptionField extends StatelessWidget {
  final TextEditingController controller;
  const _DescriptionField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: AppRadius.card,
        border:       Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller:  controller,
        maxLines:    4,
        style:       AppTextStyles.bodyMedium,
        decoration:  InputDecoration(
          hintText:       'Décrivez brièvement la situation…',
          hintStyle:      AppTextStyles.bodyMedium.copyWith(color: AppColors.textDisabled),
          border:         InputBorder.none,
          enabledBorder:  InputBorder.none,
          focusedBorder:  InputBorder.none,
          contentPadding: const EdgeInsets.all(AppSpacing.cardPadding),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  PHOTO
// ─────────────────────────────────────────

class _PhotoField extends StatelessWidget {
  const _PhotoField();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // image_picker : ImagePicker().pickImage(source: ImageSource.camera)
      },
      child: Container(
        padding:    const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color:        AppColors.surface,
          borderRadius: AppRadius.card,
          border:       Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width:      52,
              height:     52,
              decoration: BoxDecoration(
                color:        AppColors.background,
                borderRadius: AppRadius.input,
                border:       Border.all(color: AppColors.border, width: 1.5),
              ),
              child: const Icon(Icons.add_a_photo_outlined, color: AppColors.textHint, size: 22),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ajouter une photo', style: AppTextStyles.bodySemiBold),
                  const SizedBox(height: 3),
                  Text(
                    'Aide les agents à évaluer la situation.',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  BOUTON ENVOYER
// ─────────────────────────────────────────

class _SubmitButton extends StatelessWidget {
  final VoidCallback  onTap;
  final AppResponsive r;
  const _SubmitButton({required this.onTap, required this.r});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          r.pagePadding, AppSpacing.md,
          r.pagePadding, AppSpacing.lg,
        ),
        child: SizedBox(
          width:  double.infinity,
          height: r.primaryBtnHeight,
          child: ElevatedButton.icon(
            onPressed: onTap,
            icon:  const Icon(Icons.send_rounded, size: 18),
            label: Text('Envoyer le signalement', style: AppTextStyles.buttonLabel),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  LABEL DE SECTION
// ─────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label.toUpperCase(), style: AppTextStyles.sectionLabel);
  }
}