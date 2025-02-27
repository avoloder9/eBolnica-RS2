// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terapija_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Terapija _$TerapijaFromJson(Map<String, dynamic> json) => Terapija(
      terapijaId: (json['terapijaId'] as num?)?.toInt(),
      naziv: json['naziv'] as String?,
      opis: json['opis'] as String?,
      datumPocetka: json['datumPocetka'] == null
          ? null
          : DateTime.parse(json['datumPocetka'] as String),
      datumZavrsetka: json['datumZavrsetka'] == null
          ? null
          : DateTime.parse(json['datumZavrsetka'] as String),
      pregledId: (json['pregledId'] as num?)?.toInt(),
      pregled: json['pregled'] == null
          ? null
          : Pregled.fromJson(json['pregled'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TerapijaToJson(Terapija instance) => <String, dynamic>{
      'terapijaId': instance.terapijaId,
      'naziv': instance.naziv,
      'opis': instance.opis,
      'datumPocetka': instance.datumPocetka?.toIso8601String(),
      'datumZavrsetka': instance.datumZavrsetka?.toIso8601String(),
      'pregledId': instance.pregledId,
      'pregled': instance.pregled,
    };
