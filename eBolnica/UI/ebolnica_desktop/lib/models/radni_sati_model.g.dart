// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radni_sati_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RadniSati _$RadniSatiFromJson(Map<String, dynamic> json) => RadniSati(
      radniSatiId: (json['radniSatiId'] as num?)?.toInt(),
      medicinskoOsobljeId: (json['medicinskoOsobljeId'] as num?)?.toInt(),
      rasporedSmjenaId: (json['rasporedSmjenaId'] as num?)?.toInt(),
      vrijemeDolaska: json['vrijemeDolaska'] == null
          ? null
          : Duration(microseconds: (json['vrijemeDolaska'] as num).toInt()),
      vrijemeOdlaska: json['vrijemeOdlaska'] == null
          ? null
          : Duration(microseconds: (json['vrijemeOdlaska'] as num).toInt()),
      medicinskoOsoblje: json['medicinskoOsoblje'] == null
          ? null
          : MedicinskoOsoblje.fromJson(
              json['medicinskoOsoblje'] as Map<String, dynamic>),
      rasporedSmjena: json['rasporedSmjena'] == null
          ? null
          : RasporedSmjena.fromJson(
              json['rasporedSmjena'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RadniSatiToJson(RadniSati instance) => <String, dynamic>{
      'radniSatiId': instance.radniSatiId,
      'medicinskoOsobljeId': instance.medicinskoOsobljeId,
      'rasporedSmjenaId': instance.rasporedSmjenaId,
      'vrijemeDolaska': instance.vrijemeDolaska?.inMicroseconds,
      'vrijemeOdlaska': instance.vrijemeOdlaska?.inMicroseconds,
      'medicinskoOsoblje': instance.medicinskoOsoblje,
      'rasporedSmjena': instance.rasporedSmjena,
    };
