// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'laboratorijski_nalaz_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LaboratorijskiNalaz _$LaboratorijskiNalazFromJson(Map<String, dynamic> json) =>
    LaboratorijskiNalaz(
      laboratorijskiNalazId: (json['laboratorijskiNalazId'] as num?)?.toInt(),
      pacijentId: (json['pacijentId'] as num?)?.toInt(),
      doktorId: (json['doktorId'] as num?)?.toInt(),
      datumNalaza: json['datumNalaza'] == null
          ? null
          : DateTime.parse(json['datumNalaza'] as String),
      pacijent: json['pacijent'] == null
          ? null
          : Pacijent.fromJson(json['pacijent'] as Map<String, dynamic>),
      doktor: json['doktor'] == null
          ? null
          : Doktor.fromJson(json['doktor'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LaboratorijskiNalazToJson(
        LaboratorijskiNalaz instance) =>
    <String, dynamic>{
      'laboratorijskiNalazId': instance.laboratorijskiNalazId,
      'pacijentId': instance.pacijentId,
      'doktorId': instance.doktorId,
      'datumNalaza': instance.datumNalaza?.toIso8601String(),
      'pacijent': instance.pacijent,
      'doktor': instance.doktor,
    };
