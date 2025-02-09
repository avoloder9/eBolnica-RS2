// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'administrator_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Administrator _$AdministratorFromJson(Map<String, dynamic> json) =>
    Administrator(
      administratorId: (json['administratorId'] as num?)?.toInt(),
      korisnikId: (json['korisnikId'] as num?)?.toInt(),
      korisnik: json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
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

Map<String, dynamic> _$AdministratorToJson(Administrator instance) =>
    <String, dynamic>{
      'administratorId': instance.administratorId,
      'korisnikId': instance.korisnikId,
      'korisnik': instance.korisnik,
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
