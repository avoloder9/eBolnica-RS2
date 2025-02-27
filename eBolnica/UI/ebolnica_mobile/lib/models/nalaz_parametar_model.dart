import 'package:ebolnica_mobile/models/laboratorijski_nalaz_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ebolnica_mobile/models/parametar_model.dart';
part 'nalaz_parametar_model.g.dart';

@JsonSerializable()
class NalazParametar {
  int? nalazParametarId;
  int? laboratorijskiNalazId;
  int? parametarId;
  double? vrijednost;
  LaboratorijskiNalaz? laboratorijskiNalaz;
  Parametar? parametar;
  NalazParametar(
      {this.nalazParametarId,
      this.laboratorijskiNalazId,
      this.parametarId,
      this.vrijednost,
      this.laboratorijskiNalaz,
      this.parametar});
  factory NalazParametar.fromJson(Map<String, dynamic> json) =>
      _$NalazParametarFromJson(json);
  Map<String, dynamic> toJson() => _$NalazParametarToJson(this);
}
