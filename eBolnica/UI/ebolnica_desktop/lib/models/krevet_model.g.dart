// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'krevet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Krevet _$KrevetFromJson(Map<String, dynamic> json) => Krevet(
      krevetId: (json['krevetId'] as num?)?.toInt(),
      sobaId: (json['sobaId'] as num?)?.toInt(),
      zauzet: json['zauzet'] as bool?,
      soba: json['soba'] == null
          ? null
          : Soba.fromJson(json['soba'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$KrevetToJson(Krevet instance) => <String, dynamic>{
      'krevetId': instance.krevetId,
      'sobaId': instance.sobaId,
      'zauzet': instance.zauzet,
      'soba': instance.soba,
    };
