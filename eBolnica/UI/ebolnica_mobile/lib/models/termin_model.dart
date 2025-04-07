import 'package:ebolnica_mobile/models/doktor_model.dart';
import 'package:ebolnica_mobile/models/odjel_model.dart';
import 'package:ebolnica_mobile/models/pacijent_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'termin_model.g.dart';

@JsonSerializable()
class Termin {
  final int? terminId;
  final int? pacijentId;
  final int? doktorId;
  final int? odjelId;
  final DateTime? datumTermina;
  final Duration? vrijemeTermina;
  final bool? otkazano;
  final Doktor? doktor;
  final Odjel? odjel;
  final Pacijent? pacijent;
  Termin(
      {this.terminId,
      this.pacijentId,
      this.doktorId,
      this.odjelId,
      this.datumTermina,
      this.vrijemeTermina,
      this.otkazano,
      this.doktor,
      this.odjel,
      this.pacijent});

  factory Termin.fromJson(Map<String, dynamic> json) {
    return Termin(
      terminId: json['terminId'] as int?,
      pacijentId: json['pacijentId'] as int?,
      doktorId: json['doktorId'] as int?,
      odjelId: json['odjelId'] as int?,
      datumTermina: json['datumTermina'] == null
          ? null
          : DateTime.parse(json['datumTermina'] as String),
      vrijemeTermina: json['vrijemeTermina'] == null
          ? null
          : _parseDuration(json['vrijemeTermina'] as String),
      otkazano: json['otkazano'] as bool?,
      doktor: json['doktor'] == null
          ? null
          : Doktor.fromJson(json['doktor'] as Map<String, dynamic>),
      odjel: json['odjel'] == null
          ? null
          : Odjel.fromJson(json['odjel'] as Map<String, dynamic>),
      pacijent: json['pacijent'] == null
          ? null
          : Pacijent.fromJson(json['pacijent'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => _$TerminToJson(this);

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
