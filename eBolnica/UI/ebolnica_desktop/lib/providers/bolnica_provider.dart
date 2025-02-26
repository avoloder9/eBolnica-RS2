import 'package:ebolnica_desktop/models/bolnica_model.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';

class BolnicaProvider extends BaseProvider<Bolnica> {
  BolnicaProvider() : super("Bolnica");
  @override
  Bolnica fromJson(data) {
    return Bolnica.fromJson(data);
  }
}
