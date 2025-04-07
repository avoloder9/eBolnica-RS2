// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pregled_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pregled _$PregledFromJson(Map<String, dynamic> json) => Pregled(
      pregledId: (json['pregledId'] as num?)?.toInt(),
      uputnicaId: (json['uputnicaId'] as num?)?.toInt(),
      glavnaDijagnoza: json['glavnaDijagnoza'] as String?,
      anamneza: json['anamneza'] as String?,
      zakljucak: json['zakljucak'] as String?,
      medicinskaDokumentacijaId:
          (json['medicinskaDokumentacijaId'] as num?)?.toInt(),
      medicinskaDokumentacija: json['medicinskaDokumentacija'] == null
          ? null
          : MedicinskaDokumentacija.fromJson(
              json['medicinskaDokumentacija'] as Map<String, dynamic>),
      uputnica: json['uputnica'] == null
          ? null
          : Uputnica.fromJson(json['uputnica'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PregledToJson(Pregled instance) => <String, dynamic>{
      'pregledId': instance.pregledId,
      'uputnicaId': instance.uputnicaId,
      'glavnaDijagnoza': instance.glavnaDijagnoza,
      'anamneza': instance.anamneza,
      'zakljucak': instance.zakljucak,
      'medicinskaDokumentacijaId': instance.medicinskaDokumentacijaId,
      'medicinskaDokumentacija': instance.medicinskaDokumentacija,
      'uputnica': instance.uputnica,
    };
