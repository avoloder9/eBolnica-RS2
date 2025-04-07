// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smjena_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Smjena _$SmjenaFromJson(Map<String, dynamic> json) => Smjena(
      smjenaId: (json['smjenaId'] as num?)?.toInt(),
      nazivSmjene: json['nazivSmjene'] as String?,
      vrijemePocetka:
          const DurationConverter().fromJson(json['vrijemePocetka'] as String?),
      vrijemeZavrsetka: const DurationConverter()
          .fromJson(json['vrijemeZavrsetka'] as String?),
    );

Map<String, dynamic> _$SmjenaToJson(Smjena instance) => <String, dynamic>{
      'smjenaId': instance.smjenaId,
      'nazivSmjene': instance.nazivSmjene,
      'vrijemePocetka':
          const DurationConverter().toJson(instance.vrijemePocetka),
      'vrijemeZavrsetka':
          const DurationConverter().toJson(instance.vrijemeZavrsetka),
    };
