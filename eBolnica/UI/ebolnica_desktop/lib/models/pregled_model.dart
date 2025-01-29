import 'package:ebolnica_desktop/models/medicinska_dokumentacija_model.dart';
import 'package:ebolnica_desktop/models/uputnica_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pregled_model.g.dart';

@JsonSerializable()
class Pregled {
  final int? pregledId;
  final int? uputnicaId;
  final String? glavnaDijagnoza;
  final String? anamneza;
  final String? zakljucak;
  final int? medicinskaDokumentacijaId;
  final MedicinskaDokumentacija? medicinskaDokumentacija;
  final Uputnica? uputnica;

  Pregled({
    required this.pregledId,
    required this.uputnicaId,
    required this.glavnaDijagnoza,
    required this.anamneza,
    required this.zakljucak,
    required this.medicinskaDokumentacijaId,
    this.medicinskaDokumentacija,
    this.uputnica,
  });

  factory Pregled.fromJson(Map<String, dynamic> json) =>
      _$PregledFromJson(json);
  Map<String, dynamic> toJson() => _$PregledToJson(this);
}
