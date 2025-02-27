import 'package:ebolnica_mobile/models/termin_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'uputnica_model.g.dart';

@JsonSerializable()
class Uputnica {
  final int? uputnicaId;
  final int? terminId;
  final bool? status;
  final DateTime? datumKreiranja;
  final String? stateMachine;
  final Termin? termin;

  Uputnica({
    this.uputnicaId,
    this.terminId,
    this.status,
    this.datumKreiranja,
    this.stateMachine,
    this.termin,
  });

  factory Uputnica.fromJson(Map<String, dynamic> json) =>
      _$UputnicaFromJson(json);
  Map<String, dynamic> toJson() => _$UputnicaToJson(this);
}
