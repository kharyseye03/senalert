import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/responsive/app_responsive.dart';
import 'confirmation_screen.dart';

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

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int  _selectedType = 0;
  bool _isAnonymous  = true;

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

    if (_descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Veuillez ajouter une description.',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textOnPrimary),
          ),
          backgroundColor: AppColors.textPrimary,
          behavior:        SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
        ),
      );
      return;
    }

    final ref = '#DK-2024-${DateTime.now().millisecond.toString().padLeft(4, '0')}';
    showModalBottomSheet(
      context:            context,
      isScrollControlled: true,
      backgroundColor:    Colors.transparent,
      isDismissible:      false,
      builder:            (_) => ConfirmationSheet(refNumber: ref),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _RedHeader(r: r),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                r.pagePadding,
                r.spacing(small: 20, normal: 24, large: 28),
                r.pagePadding,
                r.spacing(small: 20, normal: 24, large: 28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ① Toggle anonyme
                  _AnonymousToggle(
                    isAnonymous: _isAnonymous,
                    onChanged:   (v) => setState(() => _isAnonymous = v),
                  ),

                  // Bloc identité animé
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve:    Curves.easeInOut,
                    child: _isAnonymous
                        ? const SizedBox.shrink()
                        : _IdentitySection(
                      prenomController: _prenomController,
                      nomController:    _nomController,
                      telController:    _telController,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // ② Type d'incident
                  const _FieldLabel(text: 'Type d\'incident', required: true),
                  const SizedBox(height: AppSpacing.sm),
                  _IncidentTypeGrid(
                    selected:   _selectedType,
                    onSelected: (i) => setState(() => _selectedType = i),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // ③ Localisation
                  const _FieldLabel(text: 'Localisation', required: true),
                  const SizedBox(height: AppSpacing.sm),
                  const _LocationField(),

                  const SizedBox(height: AppSpacing.xl),

                  // ④ Description
                  const _FieldLabel(text: 'Description', required: true),
                  const SizedBox(height: AppSpacing.sm),
                  _DescriptionField(controller: _descController),

                  const SizedBox(height: AppSpacing.xl),

                  // ⑤ Photo
                  const _FieldLabel(text: 'Photo', required: false),
                  const SizedBox(height: AppSpacing.sm),
                  const _PhotoField(),

                  const SizedBox(height: AppSpacing.xxxl),
                ],
              ),
            ),
          ),
          _SubmitButton(onTap: _onSubmit, r: r),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  HEADER ROUGE — pleine largeur
// ─────────────────────────────────────────

class _RedHeader extends StatelessWidget {
  final AppResponsive r;
  const _RedHeader({required this.r});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ColoredBox(
        color: AppColors.primary,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(r.pagePadding, 12, r.pagePadding, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.goNamed('portal');
                    }
                  },
                  borderRadius: AppRadius.input,
                  child: Container(
                    width:      34,
                    height:     34,
                    decoration: BoxDecoration(
                      color:        Colors.white.withOpacity(0.18),
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
                const SizedBox(height: 4),
                Text('Que s\'est-il passé ?', style: AppTextStyles.screenTitle),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  LABEL DE CHAMP avec * obligatoire
// ─────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  final bool   required;
  const _FieldLabel({super.key, required this.text, required this.required});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text:  text,
            style: AppTextStyles.bodySemiBold.copyWith(fontSize: 14),
          ),
          if (required)
            TextSpan(
              text:  ' *',
              style: AppTextStyles.bodySemiBold.copyWith(
                fontSize: 14,
                color:    AppColors.primary,
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  TOGGLE ANONYME
// ─────────────────────────────────────────

class _AnonymousToggle extends StatelessWidget {
  final bool               isAnonymous;
  final ValueChanged<bool> onChanged;
  const _AnonymousToggle({required this.isAnonymous, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical:   AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: AppRadius.card,
        border:       Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Signalement anonyme', style: AppTextStyles.bodySemiBold),
                const SizedBox(height: 3),
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
            value:              isAnonymous,
            onChanged:          onChanged,
            activeColor:        AppColors.success,
            inactiveThumbColor: AppColors.textHint,
            inactiveTrackColor: AppColors.surfaceAlt,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  SECTION IDENTITÉ
// ─────────────────────────────────────────

class _IdentitySection extends StatelessWidget {
  final TextEditingController prenomController;
  final TextEditingController nomController;
  final TextEditingController telController;

  const _IdentitySection({
    required this.prenomController,
    required this.nomController,
    required this.telController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.xl),
        const _FieldLabel(text: 'Prénom', required: true),
        const SizedBox(height: AppSpacing.sm),
        _SimpleInput(
          controller:     prenomController,
          hint:           'Votre prénom',
          inputType:      TextInputType.name,
          capitalization: TextCapitalization.words,
        ),
        const SizedBox(height: AppSpacing.lg),
        const _FieldLabel(text: 'Nom de famille', required: true),
        const SizedBox(height: AppSpacing.sm),
        _SimpleInput(
          controller:     nomController,
          hint:           'Votre nom',
          inputType:      TextInputType.name,
          capitalization: TextCapitalization.words,
        ),
        const SizedBox(height: AppSpacing.lg),
        const _FieldLabel(text: 'Numéro de téléphone', required: true),
        const SizedBox(height: AppSpacing.sm),
        _SimpleInput(
          controller: telController,
          hint:       '77 XXX XX XX',
          inputType:  TextInputType.phone,
          formatters: [FilteringTextInputFormatter.digitsOnly],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
//  INPUT SIMPLE — épuré
// ─────────────────────────────────────────

class _SimpleInput extends StatelessWidget {
  final TextEditingController     controller;
  final String                    hint;
  final TextInputType             inputType;
  final TextCapitalization        capitalization;
  final List<TextInputFormatter>? formatters;

  const _SimpleInput({
    required this.controller,
    required this.hint,
    this.inputType      = TextInputType.text,
    this.capitalization = TextCapitalization.none,
    this.formatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller:         controller,
      keyboardType:       inputType,
      textCapitalization: capitalization,
      inputFormatters:    formatters,
      style:              AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        hintText:    hint,
        hintStyle:   AppTextStyles.bodyMedium.copyWith(color: AppColors.textDisabled),
        filled:      true,
        fillColor:   AppColors.surface,
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
          borderSide:   const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical:   AppSpacing.md,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  GRILLE TYPES D'INCIDENT
// ─────────────────────────────────────────

class _IncidentTypeGrid extends StatelessWidget {
  final int               selected;
  final ValueChanged<int> onSelected;
  const _IncidentTypeGrid({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap:  true,
      physics:     const NeverScrollableScrollPhysics(),
      itemCount:   _types.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:   3,
        mainAxisSpacing:  10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.25,
      ),
      itemBuilder: (_, i) {
        final sel = i == selected;
        return GestureDetector(
          onTap: () => onSelected(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color:        sel ? AppColors.primaryLight : AppColors.surface,
              borderRadius: AppRadius.card,
              border: Border.all(
                color: sel ? AppColors.primary : AppColors.border,
                width: sel ? 1.5 : 1.0,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_types[i].emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 6),
                Text(
                  _types[i].label,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize:   11,
                    color:      sel ? AppColors.primary : AppColors.textSecondary,
                    fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical:   AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: AppRadius.input,
        border:       Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Plateau, Dakar', style: AppTextStyles.bodySemiBold),
                const SizedBox(height: 3),
                Text(
                  '✓ Position GPS détectée',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.success, fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.edit_outlined, color: AppColors.textHint, size: 17),
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
    return TextField(
      controller: controller,
      maxLines:   4,
      style:      AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        hintText:  'Décrivez brièvement la situation…',
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDisabled),
        filled:    true,
        fillColor: AppColors.surface,
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
          borderSide:   const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.all(AppSpacing.lg),
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
        width:   double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
        decoration: BoxDecoration(
          color:        AppColors.surface,
          borderRadius: AppRadius.input,
          border:       Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            const Icon(Icons.add_a_photo_outlined, color: AppColors.textHint, size: 28),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Appuyer pour ajouter une photo',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 3),
            Text(
              'Optionnel — aide les agents à évaluer',
              style: AppTextStyles.bodySmall,
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
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          r.pagePadding, AppSpacing.md,
          r.pagePadding, AppSpacing.lg,
        ),
        decoration: const BoxDecoration(
          color:  AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SizedBox(
          height: r.primaryBtnHeight,
          child: ElevatedButton(
            onPressed: onTap,
            child: Text('Envoyer le signalement', style: AppTextStyles.buttonLabel),
          ),
        ),
      ),
    );
  }
}