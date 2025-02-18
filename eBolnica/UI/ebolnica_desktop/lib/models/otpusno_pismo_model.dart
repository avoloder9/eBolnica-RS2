import 'package:ebolnica_desktop/models/hospitalizacija_model.dart';
import 'package:ebolnica_desktop/models/terapija_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'otpusno_pismo_model.g.dart';

@JsonSerializable()
class OtpusnoPismo {
  final int? otpusnoPismoId;
  final int? hospitalizacijaId;
  final String? dijagnoza;
  final String? anamneza;
  final String? zakljucak;
  final int? terapijaId;
  final Hospitalizacija? hospitalizacija;
  final Terapija? terapija;

  OtpusnoPismo(
      {this.otpusnoPismoId,
      this.hospitalizacijaId,
      this.dijagnoza,
      this.anamneza,
      this.zakljucak,
      this.terapijaId,
      this.hospitalizacija,
      this.terapija});
  factory OtpusnoPismo.fromJson(Map<String, dynamic> json) =>
      _$OtpusnoPismoFromJson(json);
  Map<String, dynamic> toJson() => _$OtpusnoPismoToJson(this);
}
