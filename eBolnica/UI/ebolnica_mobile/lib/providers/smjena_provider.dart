import 'package:ebolnica_mobile/models/smjena_model.dart';
import 'package:ebolnica_mobile/providers/base_provider.dart';

class SmjenaProvider extends BaseProvider<Smjena> {
  SmjenaProvider() : super("Smjena");
  @override
  Smjena fromJson(data) {
    return Smjena.fromJson(data);
  }
}
