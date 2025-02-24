import 'package:ebolnica_desktop/models/doktor_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ebolnica_desktop/models/pacijent_model.dart';
part 'laboratorijski_nalaz_model.g.dart';

@JsonSerializable()
class LaboratorijskiNalaz {
  int? laboratorijskiNalazId;
  int? pacijentId;
  int? doktorId;
  DateTime? datumNalaza;
  Pacijent? pacijent;
  Doktor? doktor;
  LaboratorijskiNalaz(
      {this.laboratorijskiNalazId,
      this.pacijentId,
      this.doktorId,
      this.datumNalaza,
      this.pacijent,
      this.doktor});
  factory LaboratorijskiNalaz.fromJson(Map<String, dynamic> json) =>
      _$LaboratorijskiNalazFromJson(json);
  Map<String, dynamic> toJson() => _$LaboratorijskiNalazToJson(this);
}
