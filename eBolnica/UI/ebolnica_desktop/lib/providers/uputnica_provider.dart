import 'package:ebolnica_desktop/models/uputnica_model.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';

class UputnicaProvider extends BaseProvider<Uputnica> {
  UputnicaProvider() : super("Uputnica");
  @override
  Uputnica fromJson(data) {
    return Uputnica.fromJson(data);
  }
}
