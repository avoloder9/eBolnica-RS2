import 'package:ebolnica_mobile/models/pregled_model.dart';
import 'package:ebolnica_mobile/providers/base_provider.dart';

class PregledProvider extends BaseProvider<Pregled> {
  PregledProvider() : super("Pregled");
  @override
  Pregled fromJson(data) {
    return Pregled.fromJson(data);
  }
}
