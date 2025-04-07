// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soba_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Soba _$SobaFromJson(Map<String, dynamic> json) => Soba(
      sobaId: (json['sobaId'] as num?)?.toInt(),
      naziv: json['naziv'] as String?,
      odjelId: (json['odjelId'] as num?)?.toInt(),
      brojKreveta: (json['brojKreveta'] as num?)?.toInt(),
      zauzeta: json['zauzeta'] as bool?,
      odjel: json['odjel'] == null
          ? null
          : Odjel.fromJson(json['odjel'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SobaToJson(Soba instance) => <String, dynamic>{
      'sobaId': instance.sobaId,
      'naziv': instance.naziv,
      'odjelId': instance.odjelId,
      'brojKreveta': instance.brojKreveta,
      'zauzeta': instance.zauzeta,
      'odjel': instance.odjel,
    };
