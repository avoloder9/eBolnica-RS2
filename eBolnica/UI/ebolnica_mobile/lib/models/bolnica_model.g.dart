// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bolnica_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bolnica _$BolnicaFromJson(Map<String, dynamic> json) => Bolnica(
      bolnicaId: (json['bolnicaId'] as num?)?.toInt(),
      naziv: json['naziv'] as String?,
      adresa: json['adresa'] as String?,
      telefon: json['telefon'] as String?,
      email: json['email'] as String?,
      ukupanBrojSoba: (json['ukupanBrojSoba'] as num?)?.toInt(),
      ukupanBrojOdjela: (json['ukupanBrojOdjela'] as num?)?.toInt(),
      ukupanBrojKreveta: (json['ukupanBrojKreveta'] as num?)?.toInt(),
      trenutniBrojHospitalizovanih:
          (json['trenutniBrojHospitalizovanih'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BolnicaToJson(Bolnica instance) => <String, dynamic>{
      'bolnicaId': instance.bolnicaId,
      'naziv': instance.naziv,
      'adresa': instance.adresa,
      'telefon': instance.telefon,
      'email': instance.email,
      'ukupanBrojSoba': instance.ukupanBrojSoba,
      'ukupanBrojOdjela': instance.ukupanBrojOdjela,
      'ukupanBrojKreveta': instance.ukupanBrojKreveta,
      'trenutniBrojHospitalizovanih': instance.trenutniBrojHospitalizovanih,
    };
