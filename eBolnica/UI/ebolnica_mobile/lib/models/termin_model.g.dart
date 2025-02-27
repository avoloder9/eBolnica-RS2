// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'termin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Termin _$TerminFromJson(Map<String, dynamic> json) => Termin(
      terminId: (json['terminId'] as num?)?.toInt(),
      pacijentId: (json['pacijentId'] as num?)?.toInt(),
      doktorId: (json['doktorId'] as num?)?.toInt(),
      odjelId: (json['odjelId'] as num?)?.toInt(),
      datumTermina: json['datumTermina'] == null
          ? null
          : DateTime.parse(json['datumTermina'] as String),
      vrijemeTermina: json['vrijemeTermina'] == null
          ? null
          : Duration(microseconds: (json['vrijemeTermina'] as num).toInt()),
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

Map<String, dynamic> _$TerminToJson(Termin instance) => <String, dynamic>{
      'terminId': instance.terminId,
      'pacijentId': instance.pacijentId,
      'doktorId': instance.doktorId,
      'odjelId': instance.odjelId,
      'datumTermina': instance.datumTermina?.toIso8601String(),
      'vrijemeTermina': instance.vrijemeTermina?.inMicroseconds,
      'otkazano': instance.otkazano,
      'doktor': instance.doktor,
      'odjel': instance.odjel,
      'pacijent': instance.pacijent,
    };
