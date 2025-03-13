import 'package:ebolnica_mobile/models/pacijent_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'vitalni_parametri_model.g.dart';

@JsonSerializable()
class VitalniParametri {
  final int? vitalniParametriId;
  final int? pacijentId;
  final int? otkucajSrca;
  final int? saturacija;
  final double? secer;
  final DateTime? datumMjerenja;
  final Duration? vrijemeMjerenja;
  final Pacijent? pacijent;
  VitalniParametri(
      {this.vitalniParametriId,
      this.pacijentId,
      this.otkucajSrca,
      this.saturacija,
      this.secer,
      this.datumMjerenja,
      this.vrijemeMjerenja,
      this.pacijent});

  factory VitalniParametri.fromJson(Map<String, dynamic> json) {
    return VitalniParametri(
      vitalniParametriId: json['vitalniParametriId'] as int?,
      pacijentId: json['pacijentId'] as int?,
      otkucajSrca: json['otkucajSrca'] as int?,
      saturacija: json['saturacija'] as int?,
      secer: json['secer'] as double?,
      datumMjerenja: json['datumMjerenja'] == null
          ? null
          : DateTime.parse(json['datumMjerenja'] as String),
      vrijemeMjerenja: json['vrijemeMjerenja'] == null
          ? null
          : _parseDuration(json['vrijemeMjerenja'] as String),
      pacijent: json['pacijent'] == null
          ? null
          : Pacijent.fromJson(json['pacijent'] as Map<String, dynamic>),
    );
  }
  static Duration _parseDuration(String durationStr) {
    final parts = durationStr.split(':');
    if (parts.length == 2) {
      return Duration(hours: int.parse(parts[0]), minutes: int.parse(parts[1]));
    } else if (parts.length == 3) {
      return Duration(
          hours: int.parse(parts[0]),
          minutes: int.parse(parts[1]),
          seconds: int.parse(parts[2]));
    } else {
      throw const FormatException("Invalid duration format");
    }
  }
}
