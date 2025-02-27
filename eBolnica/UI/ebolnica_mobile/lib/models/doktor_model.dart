import 'package:ebolnica_mobile/models/korisnik_model.dart';
import 'package:ebolnica_mobile/models/odjel_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'doktor_model.g.dart';

@JsonSerializable()
class Doktor {
  int? doktorId;
  int? korisnikId;
  int? odjelId;
  String? specijalizacija;
  String? biografija;
  Korisnik? korisnik;
  Odjel? odjel;
  final String? ime;
  final String? prezime;
  final String? email;
  final String? korisnickoIme;
  final DateTime? datumRodjenja;
  final String? telefon;
  final String? spol;
  final bool? status;
  String? slika;

  String? slikaThumb;
  Doktor({
    this.doktorId,
    this.korisnikId,
    this.odjelId,
    this.specijalizacija,
    this.biografija,
    this.korisnik,
    this.odjel,
    this.ime,
    this.prezime,
    this.email,
    this.korisnickoIme,
    this.datumRodjenja,
    this.telefon,
    this.spol,
    this.status,
    this.slika,
    this.slikaThumb,
  });

  factory Doktor.fromJson(Map<String, dynamic> json) => _$DoktorFromJson(json);
  Map<String, dynamic> toJson() => _$DoktorToJson(this);
}
