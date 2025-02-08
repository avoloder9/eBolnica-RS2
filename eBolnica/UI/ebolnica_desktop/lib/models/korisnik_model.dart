import 'package:json_annotation/json_annotation.dart';

part 'korisnik_model.g.dart';

@JsonSerializable()
class Korisnik {
  final int? korisnikId;
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
  Korisnik({
    this.korisnikId,
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

  factory Korisnik.fromJson(Map<String, dynamic> json) =>
      _$KorisnikFromJson(json);

  Map<String, dynamic> toJson() => _$KorisnikToJson(this);
}
