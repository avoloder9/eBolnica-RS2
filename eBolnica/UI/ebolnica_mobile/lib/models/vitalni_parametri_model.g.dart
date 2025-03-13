// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vitalni_parametri_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VitalniParametri _$VitalniParametriFromJson(Map<String, dynamic> json) =>
    VitalniParametri(
      vitalniParametriId: (json['vitalniParametriId'] as num?)?.toInt(),
      pacijentId: (json['pacijentId'] as num?)?.toInt(),
      otkucajSrca: (json['otkucajSrca'] as num?)?.toInt(),
      saturacija: (json['saturacija'] as num?)?.toInt(),
      secer: (json['secer'] as num?)?.toDouble(),
      datumMjerenja: json['datumMjerenja'] == null
          ? null
          : DateTime.parse(json['datumMjerenja'] as String),
      vrijemeMjerenja: json['vrijemeMjerenja'] == null
          ? null
          : Duration(microseconds: (json['vrijemeMjerenja'] as num).toInt()),
      pacijent: json['pacijent'] == null
          ? null
          : Pacijent.fromJson(json['pacijent'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VitalniParametriToJson(VitalniParametri instance) =>
    <String, dynamic>{
      'vitalniParametriId': instance.vitalniParametriId,
      'pacijentId': instance.pacijentId,
      'otkucajSrca': instance.otkucajSrca,
      'saturacija': instance.saturacija,
      'secer': instance.secer,
      'datumMjerenja': instance.datumMjerenja?.toIso8601String(),
      'vrijemeMjerenja': instance.vrijemeMjerenja?.inMicroseconds,
      'pacijent': instance.pacijent,
    };
