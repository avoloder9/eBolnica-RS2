import 'package:ebolnica_desktop/models/doktor_model.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';

class DoktorProvider extends BaseProvider<Doktor> {
  DoktorProvider() : super("Doktor");
  @override
  Doktor fromJson(data) {
    return Doktor.fromJson(data);
  }
}
