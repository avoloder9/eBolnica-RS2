// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisnik_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Korisnik _$KorisnikFromJson(Map<String, dynamic> json) => Korisnik(
      ime: json['ime'] as String,
      prezime: json['prezime'] as String,
      email: json['email'] as String,
      korisnickoIme: json['korisnickoIme'] as String,
      datumRodjenja: DateTime.parse(json['datumRodjenja'] as String),
      telefon: json['telefon'] as String?,
      spol: json['spol'] as String?,
      status: json['status'] as bool,
    );

Map<String, dynamic> _$KorisnikToJson(Korisnik instance) => <String, dynamic>{
      'ime': instance.ime,
      'prezime': instance.prezime,
      'email': instance.email,
      'korisnickoIme': instance.korisnickoIme,
      'datumRodjenja': instance.datumRodjenja.toIso8601String(),
      'telefon': instance.telefon,
      'spol': instance.spol,
      'status': instance.status,
    };
