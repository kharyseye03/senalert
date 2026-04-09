@override
Widget build(BuildContext context) {
  final r = AppResponsive(context);

  return Scaffold(
    backgroundColor: AppColors.background,
    body: SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        r.pagePadding,
        MediaQuery.of(context).padding.top + AppSpacing.md,
        r.pagePadding,
        r.spacing(small: 28, normal: 36, large: 44),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

      // Header simple sans fond rouge
      Row(
      children: [
      InkWell(
      onTap: () {
    if (context.canPop()) context.pop();
    else context.goNamed('dashboard');
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
    const SizedBox(width: AppSpacing.md),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Mes récompenses', style: AppTextStyles.bodySemiBold),
        Text('Vos gains citoyen', style: AppTextStyles.bodySmall),
      ],
    ),
    ],
  ),

  SizedBox(height: r.spacing(small: 20, normal: 24, large: 28)),

  _SoldeCard(
  r:         r,
  isVisible: _soldeVisible,
  onToggle:  () => setState(() => _soldeVisible = !_soldeVisible),
  ),

  // ... reste identique