import 'package:ebolnica_desktop/models/nalaz_parametar_model.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';

class NalazParametarProvider extends BaseProvider<NalazParametar> {
  NalazParametarProvider() : super("NalazParametar");
  @override
  NalazParametar fromJson(data) {
    return NalazParametar.fromJson(data);
  }
}
