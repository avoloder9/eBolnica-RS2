import 'package:ebolnica_mobile/models/doktor_model.dart';
import 'package:ebolnica_mobile/models/medicinsko_osoblje_model.dart';
import 'package:ebolnica_mobile/models/pacijent_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'radni_zadatak_model.g.dart';

@JsonSerializable()
class RadniZadatak {
  final int? radniZadatakId;
  final int? doktorId;
  final int? pacijentId;
  final int? medicinskoOsobljeId;
  final String? opis;
  final DateTime? datumZadatka;
  final bool? status;
  final Doktor? doktor;
  final Pacijent? pacijent;
  final MedicinskoOsoblje? medicinskoOsoblje;

  RadniZadatak(
      {this.radniZadatakId,
      this.doktorId,
      this.pacijentId,
      this.medicinskoOsobljeId,
      this.opis,
      this.datumZadatka,
      this.status,
      this.doktor,
      this.pacijent,
      this.medicinskoOsoblje});

  factory RadniZadatak.fromJson(Map<String, dynamic> json) =>
      _$RadniZadatakFromJson(json);
  Map<String, dynamic> toJson() => _$RadniZadatakToJson(this);
}
