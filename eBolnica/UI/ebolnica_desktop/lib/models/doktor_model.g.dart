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
      ime: json['ime'] as String?,
      prezime: json['prezime'] as String?,
      email: json['email'] as String?,
      korisnickoIme: json['korisnickoIme'] as String?,
      datumRodjenja: json['datumRodjenja'] == null
          ? null
          : DateTime.parse(json['datumRodjenja'] as String),
      telefon: json['telefon'] as String?,
      spol: json['spol'] as String?,
      status: json['status'] as bool?,
      slika: json['slika'] as String?,
      slikaThumb: json['slikaThumb'] as String?,
    );

Map<String, dynamic> _$DoktorToJson(Doktor instance) => <String, dynamic>{
      'doktorId': instance.doktorId,
      'korisnikId': instance.korisnikId,
      'odjelId': instance.odjelId,
      'specijalizacija': instance.specijalizacija,
      'biografija': instance.biografija,
      'korisnik': instance.korisnik,
      'odjel': instance.odjel,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'email': instance.email,
      'korisnickoIme': instance.korisnickoIme,
      'datumRodjenja': instance.datumRodjenja?.toIso8601String(),
      'telefon': instance.telefon,
      'spol': instance.spol,
      'status': instance.status,
      'slika': instance.slika,
      'slikaThumb': instance.slikaThumb,
    };
