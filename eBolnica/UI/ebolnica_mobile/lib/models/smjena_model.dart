import 'package:ebolnica_mobile/utils/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'smjena_model.g.dart';

@JsonSerializable()
class Smjena {
  int? smjenaId;
  String? nazivSmjene;
  @DurationConverter()
  Duration? vrijemePocetka;

  @DurationConverter()
  Duration? vrijemeZavrsetka;

  Smjena(
      {this.smjenaId,
      this.nazivSmjene,
      this.vrijemePocetka,
      this.vrijemeZavrsetka});

  factory Smjena.fromJson(Map<String, dynamic> json) => _$SmjenaFromJson(json);
  Map<String, dynamic> toJson() => _$SmjenaToJson(this);
}
