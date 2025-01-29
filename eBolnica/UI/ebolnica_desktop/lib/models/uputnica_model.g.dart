// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uputnica_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Uputnica _$UputnicaFromJson(Map<String, dynamic> json) => Uputnica(
      uputnicaId: (json['uputnicaId'] as num?)?.toInt(),
      terminId: (json['terminId'] as num?)?.toInt(),
      status: json['status'] as bool?,
      datumKreiranja: json['datumKreiranja'] == null
          ? null
          : DateTime.parse(json['datumKreiranja'] as String),
      stateMachine: json['stateMachine'] as String?,
      termin: json['termin'] == null
          ? null
          : Termin.fromJson(json['termin'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UputnicaToJson(Uputnica instance) => <String, dynamic>{
      'uputnicaId': instance.uputnicaId,
      'terminId': instance.terminId,
      'status': instance.status,
      'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
      'stateMachine': instance.stateMachine,
      'termin': instance.termin,
    };
