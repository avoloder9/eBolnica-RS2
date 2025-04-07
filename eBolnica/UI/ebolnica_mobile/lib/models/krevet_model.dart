import 'package:ebolnica_mobile/models/soba_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'krevet_model.g.dart';

@JsonSerializable()
class Krevet {
  int? krevetId;
  int? sobaId;
  bool? zauzet;

  Soba? soba;

  Krevet({
    this.krevetId,
    this.sobaId,
    this.zauzet,
    this.soba,
  });
  factory Krevet.fromJson(Map<String, dynamic> json) => _$KrevetFromJson(json);
  Map<String, dynamic> toJson() => _$KrevetToJson(this);
}
