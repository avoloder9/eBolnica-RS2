import 'package:ebolnica_mobile/models/pregled_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'terapija_model.g.dart';

@JsonSerializable()
class Terapija {
  final int? terapijaId;
  final String? naziv;
  final String? opis;
  final DateTime? datumPocetka;
  final DateTime? datumZavrsetka;
  final int? pregledId;
  final Pregled? pregled;

  Terapija({
    this.terapijaId,
    this.naziv,
    this.opis,
    this.datumPocetka,
    this.datumZavrsetka,
    this.pregledId,
    this.pregled,
  });
  factory Terapija.fromJson(Map<String, dynamic> json) =>
      _$TerapijaFromJson(json);
  Map<String, dynamic> toJson() => _$TerapijaToJson(this);
}
