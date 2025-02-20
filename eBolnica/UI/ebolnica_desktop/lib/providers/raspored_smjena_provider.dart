import 'package:ebolnica_desktop/models/raspored_smjena_model.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';

class RasporedSmjenaProvider extends BaseProvider<RasporedSmjena> {
  RasporedSmjenaProvider() : super("RasporedSmjena");
  @override
  RasporedSmjena fromJson(data) {
    return RasporedSmjena.fromJson(data);
  }
}
