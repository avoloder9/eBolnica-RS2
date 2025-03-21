import 'package:ebolnica_mobile/models/termin_model.dart';
import 'package:ebolnica_mobile/models/operacija_model.dart';

class DnevniRasporedResponse {
  int doktorId;
  String datum;
  List<Termin> termini;
  List<Operacija> operacije;

  DnevniRasporedResponse({
    required this.doktorId,
    required this.datum,
    required this.termini,
    required this.operacije,
  });

  factory DnevniRasporedResponse.fromJson(Map<String, dynamic> json) {
    return DnevniRasporedResponse(
      doktorId: json['doktorId'],
      datum: json['datum'],
      termini: (json['termini'] as List)
          .map((item) => Termin.fromJson(item))
          .toList(),
      operacije: (json['operacije'] as List)
          .map((item) => Operacija.fromJson(item))
          .toList(),
    );
  }
}
