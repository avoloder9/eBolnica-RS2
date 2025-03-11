import 'package:ebolnica_mobile/models/pacijent_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'vitalni_parametri_model.g.dart';

@JsonSerializable()
class VitalniParametri {
  final int? vitalniParametriId;
  final int? pacijentId;
  final int? otkucajSrca;
  final int? saturacija;
  final double? secer;
  final DateTime? datumMjerenja;
  final Pacijent? pacijent;
  VitalniParametri(
      {this.vitalniParametriId,
      this.pacijentId,
      this.otkucajSrca,
      this.saturacija,
      this.secer,
      this.datumMjerenja,
      this.pacijent});
  factory VitalniParametri.fromJson(Map<String, dynamic> json) =>
      _$VitalniParametriFromJson(json);
  Map<String, dynamic> toJson() => _$VitalniParametriToJson(this);
}
