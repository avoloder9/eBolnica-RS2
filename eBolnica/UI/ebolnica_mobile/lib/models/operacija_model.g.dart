// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operacija_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Operacija _$OperacijaFromJson(Map<String, dynamic> json) => Operacija(
      operacijaId: (json['operacijaId'] as num?)?.toInt(),
      pacijentId: (json['pacijentId'] as num?)?.toInt(),
      doktorId: (json['doktorId'] as num?)?.toInt(),
      terapijaId: (json['terapijaId'] as num?)?.toInt(),
      datumOperacije: json['datumOperacije'] == null
          ? null
          : DateTime.parse(json['datumOperacije'] as String),
      tipOperacije: json['tipOperacije'] as String?,
      stateMachine: json['stateMachine'] as String?,
      komentar: json['komentar'] as String?,
      pacijent: json['pacijent'] == null
          ? null
          : Pacijent.fromJson(json['pacijent'] as Map<String, dynamic>),
      doktor: json['doktor'] == null
          ? null
          : Doktor.fromJson(json['doktor'] as Map<String, dynamic>),
      terapija: json['terapija'] == null
          ? null
          : Terapija.fromJson(json['terapija'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OperacijaToJson(Operacija instance) => <String, dynamic>{
      'operacijaId': instance.operacijaId,
      'pacijentId': instance.pacijentId,
      'doktorId': instance.doktorId,
      'terapijaId': instance.terapijaId,
      'datumOperacije': instance.datumOperacije?.toIso8601String(),
      'tipOperacije': instance.tipOperacije,
      'stateMachine': instance.stateMachine,
      'komentar': instance.komentar,
      'pacijent': instance.pacijent,
      'doktor': instance.doktor,
      'terapija': instance.terapija,
    };
