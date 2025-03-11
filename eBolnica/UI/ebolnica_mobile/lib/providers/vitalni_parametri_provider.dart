import 'package:ebolnica_mobile/models/vitalni_parametri_model.dart';
import 'package:ebolnica_mobile/providers/base_provider.dart';

class VitalniParametriProvider extends BaseProvider<VitalniParametri> {
  VitalniParametriProvider() : super("VitalniParametri");
  @override
  VitalniParametri fromJson(data) {
    return VitalniParametri.fromJson(data);
  }
}
