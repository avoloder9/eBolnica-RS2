// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raspored_smjena_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RasporedSmjena _$RasporedSmjenaFromJson(Map<String, dynamic> json) =>
    RasporedSmjena(
      rasporedSmjena: (json['rasporedSmjena'] as num?)?.toInt(),
      smjenaId: (json['smjenaId'] as num?)?.toInt(),
      korisnikId: (json['korisnikId'] as num?)?.toInt(),
      datum: json['datum'] == null
          ? null
          : DateTime.parse(json['datum'] as String),
      korisnik: json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
      smjena: json['smjena'] == null
          ? null
          : Smjena.fromJson(json['smjena'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RasporedSmjenaToJson(RasporedSmjena instance) =>
    <String, dynamic>{
      'rasporedSmjena': instance.rasporedSmjena,
      'smjenaId': instance.smjenaId,
      'korisnikId': instance.korisnikId,
      'datum': instance.datum?.toIso8601String(),
      'korisnik': instance.korisnik,
      'smjena': instance.smjena,
    };
