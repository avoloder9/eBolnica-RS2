// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slobodan_dan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlobodniDan _$SlobodniDanFromJson(Map<String, dynamic> json) => SlobodniDan(
      slobodniDanId: (json['slobodniDanId'] as num?)?.toInt(),
      korisnikId: (json['korisnikId'] as num?)?.toInt(),
      datum: json['datum'] == null
          ? null
          : DateTime.parse(json['datum'] as String),
      razlog: json['razlog'] as String?,
      status: json['status'] as bool?,
      korisnik: json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SlobodniDanToJson(SlobodniDan instance) =>
    <String, dynamic>{
      'slobodniDanId': instance.slobodniDanId,
      'korisnikId': instance.korisnikId,
      'datum': instance.datum?.toIso8601String(),
      'razlog': instance.razlog,
      'status': instance.status,
      'korisnik': instance.korisnik,
    };
