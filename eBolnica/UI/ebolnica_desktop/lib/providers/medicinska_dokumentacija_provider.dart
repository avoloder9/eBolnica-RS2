import 'package:ebolnica_desktop/models/medicinska_dokumentacija_model.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';

class MedicinskaDokumentacijaProvider
    extends BaseProvider<MedicinskaDokumentacija> {
  MedicinskaDokumentacijaProvider() : super("MedicinskaDokumentacija");
  @override
  MedicinskaDokumentacija fromJson(data) {
    return MedicinskaDokumentacija.fromJson(data);
  }
}
