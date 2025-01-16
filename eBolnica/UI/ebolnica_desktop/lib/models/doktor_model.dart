import 'package:ebolnica_desktop/models/korisnik_model.dart';
import 'package:ebolnica_desktop/models/odjel_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'doktor_model.g.dart'; // Ovaj fajl će biti generisan automatski

@JsonSerializable()
class Doktor {
  int? doktorId;
  int? korisnikId;
  int? odjelId;
  String? specijalizacija;
  String? biografija;
  Korisnik? korisnik;
  Odjel? odjel;

  Doktor({
    this.doktorId,
    this.korisnikId,
    this.odjelId,
    this.specijalizacija,
    this.biografija,
    this.korisnik,
    this.odjel,
  });

  factory Doktor.fromJson(Map<String, dynamic> json) => _$DoktorFromJson(json);
  Map<String, dynamic> toJson() => _$DoktorToJson(this);
}
