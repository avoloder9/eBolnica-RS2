import 'package:ebolnica_mobile/models/odjel_model.dart';
import 'package:ebolnica_mobile/providers/base_provider.dart';

class OdjelProvider extends BaseProvider<Odjel> {
  OdjelProvider() : super("Odjel");
  @override
  Odjel fromJson(data) {
    return Odjel.fromJson(data);
  }
}
