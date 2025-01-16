// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doktor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Doktor _$DoktorFromJson(Map<String, dynamic> json) => Doktor(
      doktorId: (json['doktorId'] as num?)?.toInt(),
      korisnikId: (json['korisnikId'] as num?)?.toInt(),
      odjelId: (json['odjelId'] as num?)?.toInt(),
      specijalizacija: json['specijalizacija'] as String?,
      biografija: json['biografija'] as String?,
      korisnik: json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
      odjel: json['odjel'] == null
          ? null
          : Odjel.fromJson(json['odjel'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DoktorToJson(Doktor instance) => <String, dynamic>{
      'doktorId': instance.doktorId,
      'korisnikId': instance.korisnikId,
      'odjelId': instance.odjelId,
      'specijalizacija': instance.specijalizacija,
      'biografija': instance.biografija,
      'korisnik': instance.korisnik,
      'odjel': instance.odjel,
    };
