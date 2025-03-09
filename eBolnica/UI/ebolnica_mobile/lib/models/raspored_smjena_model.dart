import 'package:ebolnica_mobile/models/korisnik_model.dart';
import 'package:ebolnica_mobile/models/smjena_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'raspored_smjena_model.g.dart';

@JsonSerializable()
class RasporedSmjena {
  int? rasporedSmjenaId;
  int? smjenaId;
  int? korisnikId;
  DateTime? datum;
  Korisnik? korisnik;
  Smjena? smjena;

  RasporedSmjena(
      {this.rasporedSmjenaId,
      this.smjenaId,
      this.korisnikId,
      this.datum,
      this.korisnik,
      this.smjena});
  factory RasporedSmjena.fromJson(Map<String, dynamic> json) =>
      _$RasporedSmjenaFromJson(json);
  Map<String, dynamic> toJson() => _$RasporedSmjenaToJson(this);
}
