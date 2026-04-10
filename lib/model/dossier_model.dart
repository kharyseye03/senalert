import 'package:sen_alert/model/signalement.dart';

import '../widget/signalement_card.dart';

class DossierModel {
  final String            emoji;
  final String            title;
  final String            ref;
  final String            time;
  final SignalementStatus status;

  const DossierModel({
    required this.emoji,
    required this.title,
    required this.ref,
    required this.time,
    required this.status,
  });
}

const List<DossierModel> dossiersMock = [
  DossierModel(
    emoji:  '🚗',
    title:  'Accident de la route',
    ref:    'SIG-2026-00089',
    time:   'il y a 2h',
    status: SignalementStatus.inProgress,
  ),
  DossierModel(
    emoji:  '⚠️',
    title:  'Trouble de voisinage',
    ref:    'SIG-2026-00071',
    time:   'hier',
    status: SignalementStatus.resolved,
  ),
  DossierModel(
    emoji:  '🔥',
    title:  'Incendie — Marché Sandaga',
    ref:    'SIG-2026-00054',
    time:   'il y a 3j',
    status: SignalementStatus.resolved,
  ),
  DossierModel(
    emoji:  '🏥',
    title:  'Urgence médicale',
    ref:    'SIG-2026-00038',
    time:   'il y a 5j',
    status: SignalementStatus.pending,
  ),
  DossierModel(
    emoji:  '🔧',
    title:  'Voirie — Rue Moussé',
    ref:    'SIG-2026-00021',
    time:   'il y a 8j',
    status: SignalementStatus.resolved,
  ),
];