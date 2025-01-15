import 'package:ebolnica_desktop/models/pacijent_model.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';

class PacijentProvider extends BaseProvider<Pacijent> {
  PacijentProvider() : super("Pacijent");

  @override
  Pacijent fromJson(data) {
    return Pacijent.fromJson(data);
  }
}
