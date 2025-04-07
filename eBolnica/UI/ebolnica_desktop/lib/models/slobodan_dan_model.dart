import 'package:ebolnica_desktop/models/korisnik_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'slobodan_dan_model.g.dart';

@JsonSerializable()
class SlobodniDan {
  final int? slobodniDanId;
  final int? korisnikId;
  final DateTime? datum;
  final String? razlog;
  final bool? status;
  final Korisnik? korisnik;
  SlobodniDan({
    this.slobodniDanId,
    this.korisnikId,
    this.datum,
    this.razlog,
    this.status,
    this.korisnik,
  });

  factory SlobodniDan.fromJson(Map<String, dynamic> json) =>
      _$SlobodniDanFromJson(json);
  Map<String, dynamic> toJson() => _$SlobodniDanToJson(this);
}
