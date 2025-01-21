import 'package:ebolnica_desktop/models/medicinsko_osoblje_model.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';

class MedicinskoOsobljeProvider extends BaseProvider<MedicinskoOsoblje> {
  MedicinskoOsobljeProvider() : super("MedicinskoOsoblje");

  @override
  MedicinskoOsoblje fromJson(data) {
    return MedicinskoOsoblje.fromJson(data);
  }
}
