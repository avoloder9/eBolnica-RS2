import 'package:ebolnica_mobile/models/radni_sati_model.dart';
import 'package:ebolnica_mobile/providers/base_provider.dart';

class RadniSatiProvider extends BaseProvider<RadniSati> {
  RadniSatiProvider() : super("RadniSati");
  @override
  RadniSati fromJson(data) {
    return RadniSati.fromJson(data);
  }
}
