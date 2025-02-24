// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nalaz_parametar_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NalazParametar _$NalazParametarFromJson(Map<String, dynamic> json) =>
    NalazParametar(
      nalazParametarId: (json['nalazParametarId'] as num?)?.toInt(),
      laboratorijskiNalazId: (json['laboratorijskiNalazId'] as num?)?.toInt(),
      parametarId: (json['parametarId'] as num?)?.toInt(),
      vrijednost: (json['vrijednost'] as num?)?.toDouble(),
      laboratorijskiNalaz: json['laboratorijskiNalaz'] == null
          ? null
          : LaboratorijskiNalaz.fromJson(
              json['laboratorijskiNalaz'] as Map<String, dynamic>),
      parametar: json['parametar'] == null
          ? null
          : Parametar.fromJson(json['parametar'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NalazParametarToJson(NalazParametar instance) =>
    <String, dynamic>{
      'nalazParametarId': instance.nalazParametarId,
      'laboratorijskiNalazId': instance.laboratorijskiNalazId,
      'parametarId': instance.parametarId,
      'vrijednost': instance.vrijednost,
      'laboratorijskiNalaz': instance.laboratorijskiNalaz,
      'parametar': instance.parametar,
    };
