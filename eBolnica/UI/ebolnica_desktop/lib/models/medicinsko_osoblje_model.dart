import 'package:ebolnica_desktop/models/korisnik_model.dart';
import 'package:ebolnica_desktop/models/odjel_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'medicinsko_osoblje_model.g.dart';

@JsonSerializable()
class MedicinskoOsoblje {
  int? medicinskoOsobljeId;
  int? korisnikId;
  int? odjelId;
  Korisnik? korisnik;
  Odjel? odjel;

  MedicinskoOsoblje({
    this.medicinskoOsobljeId,
    this.korisnikId,
    this.odjelId,
    this.korisnik,
    this.odjel,
  });
  factory MedicinskoOsoblje.fromJson(Map<String, dynamic> json) =>
      _$MedicinskoOsobljeFromJson(json);
  Map<String, dynamic> toJson() => _$MedicinskoOsobljeToJson(this);
}
