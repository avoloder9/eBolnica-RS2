import 'package:ebolnica_desktop/models/laboratorijski_nalaz_model.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';

class LaboratorijskiNalazProvider extends BaseProvider<LaboratorijskiNalaz> {
  LaboratorijskiNalazProvider() : super("LaboratorijskiNalaz");
  @override
  LaboratorijskiNalaz fromJson(data) {
    return LaboratorijskiNalaz.fromJson(data);
  }
}
