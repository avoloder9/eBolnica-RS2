// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otpusno_pismo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpusnoPismo _$OtpusnoPismoFromJson(Map<String, dynamic> json) => OtpusnoPismo(
      otpusnoPismoId: (json['otpusnoPismoId'] as num?)?.toInt(),
      hospitalizacijaId: (json['hospitalizacijaId'] as num?)?.toInt(),
      dijagnoza: json['dijagnoza'] as String?,
      anamneza: json['anamneza'] as String?,
      zakljucak: json['zakljucak'] as String?,
      terapijaId: (json['terapijaId'] as num?)?.toInt(),
      hospitalizacija: json['hospitalizacija'] == null
          ? null
          : Hospitalizacija.fromJson(
              json['hospitalizacija'] as Map<String, dynamic>),
      terapija: json['terapija'] == null
          ? null
          : Terapija.fromJson(json['terapija'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OtpusnoPismoToJson(OtpusnoPismo instance) =>
    <String, dynamic>{
      'otpusnoPismoId': instance.otpusnoPismoId,
      'hospitalizacijaId': instance.hospitalizacijaId,
      'dijagnoza': instance.dijagnoza,
      'anamneza': instance.anamneza,
      'zakljucak': instance.zakljucak,
      'terapijaId': instance.terapijaId,
      'hospitalizacija': instance.hospitalizacija,
      'terapija': instance.terapija,
    };
