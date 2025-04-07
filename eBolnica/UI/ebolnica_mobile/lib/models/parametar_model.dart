import 'package:json_annotation/json_annotation.dart';

part 'parametar_model.g.dart';

@JsonSerializable()
class Parametar {
  final int? parametarId;
  final String? naziv;
  final double? minVrijednost;
  final double? maxVrijednost;

  Parametar(
      {this.parametarId, this.naziv, this.minVrijednost, this.maxVrijednost});

  factory Parametar.fromJson(Map<String, dynamic> json) =>
      _$ParametarFromJson(json);
  Map<String, dynamic> toJson() => _$ParametarToJson(this);
}
