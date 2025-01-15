import 'package:json_annotation/json_annotation.dart';

part 'korisnik_model.g.dart';

@JsonSerializable()
class Korisnik {
  final String ime;
  final String prezime;
  final String email;
  final String korisnickoIme;
  final DateTime datumRodjenja;
  final String? telefon;
  final String? spol;
  final bool status;

  Korisnik({
    required this.ime,
    required this.prezime,
    required this.email,
    required this.korisnickoIme,
    required this.datumRodjenja,
    this.telefon,
    this.spol,
    required this.status,
  });

  factory Korisnik.fromJson(Map<String, dynamic> json) =>
      _$KorisnikFromJson(json);

  Map<String, dynamic> toJson() => _$KorisnikToJson(this);
}
