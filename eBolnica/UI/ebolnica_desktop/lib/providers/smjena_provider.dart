import 'package:ebolnica_desktop/models/smjena_model.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';

class SmjenaProvider extends BaseProvider<Smjena> {
  SmjenaProvider() : super("Smjena");
  @override
  Smjena fromJson(data) {
    return Smjena.fromJson(data);
  }
}
