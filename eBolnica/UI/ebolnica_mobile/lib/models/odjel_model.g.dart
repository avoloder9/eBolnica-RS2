// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'odjel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Odjel _$OdjelFromJson(Map<String, dynamic> json) => Odjel(
      odjelId: (json['odjelId'] as num?)?.toInt(),
      naziv: json['naziv'] as String?,
      brojSoba: (json['brojSoba'] as num?)?.toInt(),
      brojKreveta: (json['brojKreveta'] as num?)?.toInt(),
      brojSlobodnihKreveta: (json['brojSlobodnihKreveta'] as num?)?.toInt(),
      bolnicaId: (json['bolnicaId'] as num?)?.toInt(),
      glavniDoktorId: (json['glavniDoktorId'] as num?)?.toInt(),
      bolnica: json['bolnica'] == null
          ? null
          : Bolnica.fromJson(json['bolnica'] as Map<String, dynamic>),
      glavniDoktor: json['glavniDoktor'] == null
          ? null
          : Doktor.fromJson(json['glavniDoktor'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OdjelToJson(Odjel instance) => <String, dynamic>{
      'odjelId': instance.odjelId,
      'naziv': instance.naziv,
      'brojSoba': instance.brojSoba,
      'brojKreveta': instance.brojKreveta,
      'brojSlobodnihKreveta': instance.brojSlobodnihKreveta,
      'bolnicaId': instance.bolnicaId,
      'glavniDoktorId': instance.glavniDoktorId,
      'bolnica': instance.bolnica,
      'glavniDoktor': instance.glavniDoktor,
    };
