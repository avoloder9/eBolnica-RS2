import 'package:ebolnica_desktop/models/korisnik_model.dart';
import 'package:ebolnica_desktop/models/smjena_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'raspored_smjena_model.g.dart';

@JsonSerializable()
class RasporedSmjena {
  int? rasporedSmjena;
  int? smjenaId;
  int? korisnikId;
  DateTime? datum;
  Korisnik? korisnik;
  Smjena? smjena;

  RasporedSmjena(
      {this.rasporedSmjena,
      this.smjenaId,
      this.korisnikId,
      this.datum,
      this.korisnik,
      this.smjena});
  factory RasporedSmjena.fromJson(Map<String, dynamic> json) =>
      _$RasporedSmjenaFromJson(json);
  Map<String, dynamic> toJson() => _$RasporedSmjenaToJson(this);
}
