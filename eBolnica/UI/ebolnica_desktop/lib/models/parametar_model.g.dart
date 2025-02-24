// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parametar_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Parametar _$ParametarFromJson(Map<String, dynamic> json) => Parametar(
      parametarId: (json['parametarId'] as num?)?.toInt(),
      naziv: json['naziv'] as String?,
      minVrijednost: (json['minVrijednost'] as num?)?.toDouble(),
      maxVrijednost: (json['maxVrijednost'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ParametarToJson(Parametar instance) => <String, dynamic>{
      'parametarId': instance.parametarId,
      'naziv': instance.naziv,
      'minVrijednost': instance.minVrijednost,
      'maxVrijednost': instance.maxVrijednost,
    };
