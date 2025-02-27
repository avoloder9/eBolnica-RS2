import 'package:json_annotation/json_annotation.dart';
part 'bolnica_model.g.dart';

@JsonSerializable()
class Bolnica {
  int? bolnicaId;
  String? naziv;
  String? adresa;
  String? telefon;
  String? email;
  int? ukupanBrojSoba;
  int? ukupanBrojOdjela;
  int? ukupanBrojKreveta;
  int? trenutniBrojHospitalizovanih;

  Bolnica({
    this.bolnicaId,
    this.naziv,
    this.adresa,
    this.telefon,
    this.email,
    this.ukupanBrojSoba,
    this.ukupanBrojOdjela,
    this.ukupanBrojKreveta,
    this.trenutniBrojHospitalizovanih,
  });

  factory Bolnica.fromJson(Map<String, dynamic> json) =>
      _$BolnicaFromJson(json);
  Map<String, dynamic> toJson() => _$BolnicaToJson(this);
}
