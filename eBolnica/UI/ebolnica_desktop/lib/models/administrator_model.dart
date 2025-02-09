import 'package:ebolnica_desktop/models/korisnik_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'administrator_model.g.dart';

@JsonSerializable()
class Administrator {
  final int? administratorId;
  int? korisnikId;
  Korisnik? korisnik;

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

  Administrator({
    this.administratorId,
    this.korisnikId,
    this.korisnik,
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
  factory Administrator.fromJson(Map<String, dynamic> json) =>
      _$AdministratorFromJson(json);
  Map<String, dynamic> toJson() => _$AdministratorToJson(this);
}
