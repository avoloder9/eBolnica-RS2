import 'package:ebolnica_mobile/models/parametar_model.dart';
import 'package:ebolnica_mobile/providers/base_provider.dart';

class ParametarProvider extends BaseProvider<Parametar> {
  ParametarProvider() : super("Parametar");
  @override
  Parametar fromJson(data) {
    return Parametar.fromJson(data);
  }
}
