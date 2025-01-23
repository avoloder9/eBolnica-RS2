import 'package:ebolnica_desktop/models/odjel_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'soba_model.g.dart';

@JsonSerializable()
class Soba {
  int? sobaId;
  String? naziv;
  int? odjelId;
  int? brojKreveta;
  bool? zauzeta;

  Odjel? odjel;

  Soba({
    this.sobaId,
    this.naziv,
    this.odjelId,
    this.brojKreveta,
    this.zauzeta,
    this.odjel,
  });

  factory Soba.fromJson(Map<String, dynamic> json) => _$SobaFromJson(json);
  Map<String, dynamic> toJson() => _$SobaToJson(this);
}
