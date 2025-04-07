// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hospitalizacija_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hospitalizacija _$HospitalizacijaFromJson(Map<String, dynamic> json) =>
    Hospitalizacija(
      hospitalizacijaId: (json['hospitalizacijaId'] as num?)?.toInt(),
      pacijentId: (json['pacijentId'] as num?)?.toInt(),
      doktorId: (json['doktorId'] as num?)?.toInt(),
      odjelId: (json['odjelId'] as num?)?.toInt(),
      datumPrijema: json['datumPrijema'] == null
          ? null
          : DateTime.parse(json['datumPrijema'] as String),
      datumOtpusta: json['datumOtpusta'] == null
          ? null
          : DateTime.parse(json['datumOtpusta'] as String),
      sobaId: (json['sobaId'] as num?)?.toInt(),
      krevetId: (json['krevetId'] as num?)?.toInt(),
      medicinskaDokumentacijaId:
          (json['medicinskaDokumentacijaId'] as num?)?.toInt(),
      pacijent: json['pacijent'] == null
          ? null
          : Pacijent.fromJson(json['pacijent'] as Map<String, dynamic>),
      doktor: json['doktor'] == null
          ? null
          : Doktor.fromJson(json['doktor'] as Map<String, dynamic>),
      odjel: json['odjel'] == null
          ? null
          : Odjel.fromJson(json['odjel'] as Map<String, dynamic>),
      soba: json['soba'] == null
          ? null
          : Soba.fromJson(json['soba'] as Map<String, dynamic>),
      krevet: json['krevet'] == null
          ? null
          : Krevet.fromJson(json['krevet'] as Map<String, dynamic>),
      medicinskaDokumentacija: json['medicinskaDokumentacija'] == null
          ? null
          : MedicinskaDokumentacija.fromJson(
              json['medicinskaDokumentacija'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HospitalizacijaToJson(Hospitalizacija instance) =>
    <String, dynamic>{
      'hospitalizacijaId': instance.hospitalizacijaId,
      'pacijentId': instance.pacijentId,
      'doktorId': instance.doktorId,
      'odjelId': instance.odjelId,
      'datumPrijema': instance.datumPrijema?.toIso8601String(),
      'datumOtpusta': instance.datumOtpusta?.toIso8601String(),
      'sobaId': instance.sobaId,
      'krevetId': instance.krevetId,
      'medicinskaDokumentacijaId': instance.medicinskaDokumentacijaId,
      'pacijent': instance.pacijent,
      'doktor': instance.doktor,
      'odjel': instance.odjel,
      'soba': instance.soba,
      'krevet': instance.krevet,
      'medicinskaDokumentacija': instance.medicinskaDokumentacija,
    };
