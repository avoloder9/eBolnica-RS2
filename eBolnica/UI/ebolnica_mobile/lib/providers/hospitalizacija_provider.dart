import 'package:ebolnica_mobile/models/hospitalizacija_model.dart';
import 'package:ebolnica_mobile/providers/base_provider.dart';

class HospitalizacijaProvider extends BaseProvider<Hospitalizacija> {
  HospitalizacijaProvider() : super("Hospitalizacija");
  @override
  Hospitalizacija fromJson(data) {
    return Hospitalizacija.fromJson(data);
  }
}
