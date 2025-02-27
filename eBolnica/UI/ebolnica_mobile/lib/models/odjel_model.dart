import 'package:ebolnica_mobile/models/bolnica_model.dart';
import 'package:ebolnica_mobile/models/doktor_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'odjel_model.g.dart';

@JsonSerializable()
class Odjel {
  int? odjelId;
  String? naziv;
  int? brojSoba;
  int? brojKreveta;
  int? brojSlobodnihKreveta;
  int? bolnicaId;
  int? glavniDoktorId;
  Bolnica? bolnica;
  Doktor? glavniDoktor;

  Odjel({
    this.odjelId,
    this.naziv,
    this.brojSoba,
    this.brojKreveta,
    this.brojSlobodnihKreveta,
    this.bolnicaId,
    this.glavniDoktorId,
    this.bolnica,
    this.glavniDoktor,
  });

  factory Odjel.fromJson(Map<String, dynamic> json) => _$OdjelFromJson(json);
  Map<String, dynamic> toJson() => _$OdjelToJson(this);
}
