// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radni_zadatak_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RadniZadatak _$RadniZadatakFromJson(Map<String, dynamic> json) => RadniZadatak(
      radniZadatakId: (json['radniZadatakId'] as num?)?.toInt(),
      doktorId: (json['doktorId'] as num?)?.toInt(),
      pacijentId: (json['pacijentId'] as num?)?.toInt(),
      medicinskoOsobljeId: (json['medicinskoOsobljeId'] as num?)?.toInt(),
      opis: json['opis'] as String?,
      datumZadatka: json['datumZadatka'] == null
          ? null
          : DateTime.parse(json['datumZadatka'] as String),
      status: json['status'] as bool?,
      doktor: json['doktor'] == null
          ? null
          : Doktor.fromJson(json['doktor'] as Map<String, dynamic>),
      pacijent: json['pacijent'] == null
          ? null
          : Pacijent.fromJson(json['pacijent'] as Map<String, dynamic>),
      medicinskoOsoblje: json['medicinskoOsoblje'] == null
          ? null
          : MedicinskoOsoblje.fromJson(
              json['medicinskoOsoblje'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RadniZadatakToJson(RadniZadatak instance) =>
    <String, dynamic>{
      'radniZadatakId': instance.radniZadatakId,
      'doktorId': instance.doktorId,
      'pacijentId': instance.pacijentId,
      'medicinskoOsobljeId': instance.medicinskoOsobljeId,
      'opis': instance.opis,
      'datumZadatka': instance.datumZadatka?.toIso8601String(),
      'status': instance.status,
      'doktor': instance.doktor,
      'pacijent': instance.pacijent,
      'medicinskoOsoblje': instance.medicinskoOsoblje,
    };
