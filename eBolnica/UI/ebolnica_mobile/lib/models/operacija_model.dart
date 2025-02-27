import 'package:ebolnica_mobile/models/doktor_model.dart';
import 'package:ebolnica_mobile/models/pacijent_model.dart';
import 'package:ebolnica_mobile/models/terapija_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'operacija_model.g.dart';

@JsonSerializable()
class Operacija {
  final int? operacijaId;
  final int? pacijentId;
  final int? doktorId;
  final int? terapijaId;
  final DateTime? datumOperacije;
  final String? tipOperacije;
  final String? stateMachine;
  final String? komentar;
  final Pacijent? pacijent;
  final Doktor? doktor;
  final Terapija? terapija;

  Operacija(
      {this.operacijaId,
      this.pacijentId,
      this.doktorId,
      this.terapijaId,
      this.datumOperacije,
      this.tipOperacije,
      this.stateMachine,
      this.komentar,
      this.pacijent,
      this.doktor,
      this.terapija});
  factory Operacija.fromJson(Map<String, dynamic> json) =>
      _$OperacijaFromJson(json);
  Map<String, dynamic> toJson() => _$OperacijaToJson(this);
}
