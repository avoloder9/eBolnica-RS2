import 'package:ebolnica_desktop/models/doktor_model.dart';
import 'package:ebolnica_desktop/models/krevet_model.dart';
import 'package:ebolnica_desktop/models/medicinska_dokumentacija_model.dart';
import 'package:ebolnica_desktop/models/odjel_model.dart';
import 'package:ebolnica_desktop/models/pacijent_model.dart';
import 'package:ebolnica_desktop/models/soba_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hospitalizacija_model.g.dart';

@JsonSerializable()
class Hospitalizacija {
  final int? hospitalizacijaId;
  final int? pacijentId;
  final int? doktorId;
  final int? odjelId;
  final DateTime? datumPrijema;
  final DateTime? datumOtpusta;
  final int? sobaId;
  final int? krevetId;
  final int? medicinskaDokumentacijaId;
  final Pacijent? pacijent;
  final Doktor? doktor;
  final Odjel? odjel;
  final Soba? soba;
  final Krevet? krevet;
  final MedicinskaDokumentacija? medicinskaDokumentacija;
  Hospitalizacija({
    this.hospitalizacijaId,
    this.pacijentId,
    this.doktorId,
    this.odjelId,
    this.datumPrijema,
    this.datumOtpusta,
    this.sobaId,
    this.krevetId,
    this.medicinskaDokumentacijaId,
    this.pacijent,
    this.doktor,
    this.odjel,
    this.soba,
    this.krevet,
    this.medicinskaDokumentacija,
  });

  factory Hospitalizacija.fromJson(Map<String, dynamic> json) =>
      _$HospitalizacijaFromJson(json);
  Map<String, dynamic> toJson() => _$HospitalizacijaToJson(this);
}
