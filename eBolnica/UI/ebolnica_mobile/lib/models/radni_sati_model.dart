import 'package:ebolnica_mobile/models/medicinsko_osoblje_model.dart';
import 'package:ebolnica_mobile/models/raspored_smjena_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'radni_sati_model.g.dart';

@JsonSerializable()
class RadniSati {
  final int? radniSatiId;
  final int? medicinskoOsobljeId;
  final int? rasporedSmjenaId;
  final Duration? vrijemeDolaska;
  final Duration? vrijemeOdlaska;
  final MedicinskoOsoblje? medicinskoOsoblje;
  final RasporedSmjena? rasporedSmjena;

  RadniSati(
      {this.radniSatiId,
      this.medicinskoOsobljeId,
      this.rasporedSmjenaId,
      this.vrijemeDolaska,
      this.vrijemeOdlaska,
      this.medicinskoOsoblje,
      this.rasporedSmjena});
  factory RadniSati.fromJson(Map<String, dynamic> json) {
    return RadniSati(
      radniSatiId: json['radniSatiId'] as int?,
      medicinskoOsobljeId: json['medicinskoOsobljeId'] as int?,
      rasporedSmjenaId: json['rasporedSmjenaId'] as int?,
      vrijemeDolaska: json['vrijemeDolaska'] == null
          ? null
          : _parseDuration(json['vrijemeDolaska'] as String),
      vrijemeOdlaska: json['vrijemeOdlaska'] == null
          ? null
          : _parseDuration(json['vrijemeOdlaska'] as String),
      medicinskoOsoblje: json['medicinskoOsoblje'] == null
          ? null
          : MedicinskoOsoblje.fromJson(
              json['medicinskoOsoblje'] as Map<String, dynamic>),
      rasporedSmjena: json['rasporedSmjena'] == null
          ? null
          : RasporedSmjena.fromJson(
              json['rasporedSmjena'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => _$RadniSatiToJson(this);

  static Duration _parseDuration(String durationStr) {
    final parts = durationStr.split(':');
    if (parts.length == 2) {
      return Duration(hours: int.parse(parts[0]), minutes: int.parse(parts[1]));
    } else if (parts.length == 3) {
      return Duration(
          hours: int.parse(parts[0]),
          minutes: int.parse(parts[1]),
          seconds: int.parse(parts[2]));
    } else {
      throw const FormatException("Invalid duration format");
    }
  }
}
