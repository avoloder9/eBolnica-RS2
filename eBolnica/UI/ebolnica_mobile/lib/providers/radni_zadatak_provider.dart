import 'package:ebolnica_mobile/models/radni_zadatak_model.dart';
import 'package:ebolnica_mobile/providers/base_provider.dart';

class RadniZadatakProvider extends BaseProvider<RadniZadatak> {
  RadniZadatakProvider() : super("RadniZadatak");

  @override
  RadniZadatak fromJson(data) {
    return RadniZadatak.fromJson(data);
  }
}
