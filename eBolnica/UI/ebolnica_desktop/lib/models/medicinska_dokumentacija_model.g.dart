// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicinska_dokumentacija_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicinskaDokumentacija _$MedicinskaDokumentacijaFromJson(
        Map<String, dynamic> json) =>
    MedicinskaDokumentacija(
      medicinskaDokumentacijaId:
          (json['medicinskaDokumentacijaId'] as num?)?.toInt(),
      pacijentId: (json['pacijentId'] as num?)?.toInt(),
      datumKreiranja: json['datumKreiranja'] == null
          ? null
          : DateTime.parse(json['datumKreiranja'] as String),
      hospitalizovan: json['hospitalizovan'] as bool?,
      napomena: json['napomena'] as String?,
      pacijent: json['pacijent'] == null
          ? null
          : Pacijent.fromJson(json['pacijent'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MedicinskaDokumentacijaToJson(
        MedicinskaDokumentacija instance) =>
    <String, dynamic>{
      'medicinskaDokumentacijaId': instance.medicinskaDokumentacijaId,
      'pacijentId': instance.pacijentId,
      'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
      'hospitalizovan': instance.hospitalizovan,
      'napomena': instance.napomena,
      'pacijent': instance.pacijent,
    };
