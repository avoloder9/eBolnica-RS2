import 'package:ebolnica_desktop/models/pacijent_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'medicinska_dokumentacija_model.g.dart';

@JsonSerializable()
class MedicinskaDokumentacija {
  final int? medicinskaDokumentacijaId;
  final int? pacijentId;
  final DateTime? datumKreiranja;
  final bool? hospitalizovan;
  final String? napomena;
  final Pacijent? pacijent;

  MedicinskaDokumentacija({
    this.medicinskaDokumentacijaId,
    this.pacijentId,
    this.datumKreiranja,
    this.hospitalizovan,
    this.napomena,
    this.pacijent,
  });

  factory MedicinskaDokumentacija.fromJson(Map<String, dynamic> json) =>
      _$MedicinskaDokumentacijaFromJson(json);
  Map<String, dynamic> toJson() => _$MedicinskaDokumentacijaToJson(this);
}
