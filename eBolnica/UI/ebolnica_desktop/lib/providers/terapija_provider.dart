import 'package:ebolnica_desktop/models/terapija_model.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';

class TerapijaProvider extends BaseProvider<Terapija> {
  TerapijaProvider() : super("Terapija");

  @override
  Terapija fromJson(data) {
    return Terapija.fromJson(data);
  }
}
