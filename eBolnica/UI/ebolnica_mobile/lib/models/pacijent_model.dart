import 'package:ebolnica_mobile/models/korisnik_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:typed_data';
part 'pacijent_model.g.dart';

@JsonSerializable()
class Pacijent {
  int? pacijentId;
  String? ime;
  String? prezime;
  String? email;
  String? korisnickoIme;
  String? lozinka;
  String? lozinkaPotvrda;
  @JsonKey(fromJson: _bytesFromJson, toJson: _bytesToJson)
  Uint8List? slika;

  @JsonKey(fromJson: _bytesFromJson, toJson: _bytesToJson)
  Uint8List? slikaThumb;

  DateTime? datumRodjenja;
  String? telefon;
  String? spol;
  bool? status;
  int? brojZdravstveneKartice;
  String? adresa;
  int? dob;
  final Korisnik? korisnik;
  @JsonKey(includeFromJson: false, includeToJson: false)
  int? korisnikId;
  Pacijent({
    this.pacijentId,
    this.ime,
    this.prezime,
    this.email,
    this.korisnickoIme,
    this.lozinka,
    this.lozinkaPotvrda,
    this.slika,
    this.slikaThumb,
    this.datumRodjenja,
    this.telefon,
    this.spol,
    this.status = true,
    this.brojZdravstveneKartice,
    this.adresa,
    this.dob,
    this.korisnikId,
    this.korisnik,
  });

  factory Pacijent.fromJson(Map<String, dynamic> json) =>
      _$PacijentFromJson(json);
  Map<String, dynamic> toJson() => _$PacijentToJson(this);

  static Uint8List? _bytesFromJson(List<int>? bytes) =>
      bytes != null ? Uint8List.fromList(bytes) : null;

  static List<int>? _bytesToJson(Uint8List? bytes) => bytes?.toList();
}
