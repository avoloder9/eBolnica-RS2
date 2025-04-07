// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicinsko_osoblje_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicinskoOsoblje _$MedicinskoOsobljeFromJson(Map<String, dynamic> json) =>
    MedicinskoOsoblje(
      medicinskoOsobljeId: (json['medicinskoOsobljeId'] as num?)?.toInt(),
      korisnikId: (json['korisnikId'] as num?)?.toInt(),
      odjelId: (json['odjelId'] as num?)?.toInt(),
      korisnik: json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
      odjel: json['odjel'] == null
          ? null
          : Odjel.fromJson(json['odjel'] as Map<String, dynamic>),
      obrisano: json['obrisano'] as bool?,
    );

Map<String, dynamic> _$MedicinskoOsobljeToJson(MedicinskoOsoblje instance) =>
    <String, dynamic>{
      'medicinskoOsobljeId': instance.medicinskoOsobljeId,
      'korisnikId': instance.korisnikId,
      'odjelId': instance.odjelId,
      'korisnik': instance.korisnik,
      'odjel': instance.odjel,
      'obrisano': instance.obrisano,
    };
