// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pacijent_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pacijent _$PacijentFromJson(Map<String, dynamic> json) => Pacijent(
      pacijentId: (json['pacijentId'] as num?)?.toInt(),
      ime: json['ime'] as String?,
      prezime: json['prezime'] as String?,
      email: json['email'] as String?,
      korisnickoIme: json['korisnickoIme'] as String?,
      lozinka: json['lozinka'] as String?,
      lozinkaPotvrda: json['lozinkaPotvrda'] as String?,
      slika: Pacijent._bytesFromJson(json['slika'] as List<int>?),
      slikaThumb: Pacijent._bytesFromJson(json['slikaThumb'] as List<int>?),
      datumRodjenja: json['datumRodjenja'] == null
          ? null
          : DateTime.parse(json['datumRodjenja'] as String),
      telefon: json['telefon'] as String?,
      spol: json['spol'] as String?,
      status: json['status'] as bool? ?? true,
      brojZdravstveneKartice: (json['brojZdravstveneKartice'] as num?)?.toInt(),
      adresa: json['adresa'] as String?,
      dob: (json['dob'] as num?)?.toInt(),
      korisnik: json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
      obrisano: json['obrisano'] as bool?,
    );

Map<String, dynamic> _$PacijentToJson(Pacijent instance) => <String, dynamic>{
      'pacijentId': instance.pacijentId,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'email': instance.email,
      'korisnickoIme': instance.korisnickoIme,
      'lozinka': instance.lozinka,
      'lozinkaPotvrda': instance.lozinkaPotvrda,
      'slika': Pacijent._bytesToJson(instance.slika),
      'slikaThumb': Pacijent._bytesToJson(instance.slikaThumb),
      'datumRodjenja': instance.datumRodjenja?.toIso8601String(),
      'telefon': instance.telefon,
      'spol': instance.spol,
      'status': instance.status,
      'brojZdravstveneKartice': instance.brojZdravstveneKartice,
      'adresa': instance.adresa,
      'dob': instance.dob,
      'obrisano': instance.obrisano,
      'korisnik': instance.korisnik,
    };
