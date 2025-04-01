import 'package:ebolnica_desktop/models/slobodan_dan_model.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';

class SlobodniDanProvider extends BaseProvider<SlobodniDan> {
  SlobodniDanProvider() : super("SlobodniDan");
  @override
  SlobodniDan fromJson(data) {
    return SlobodniDan.fromJson(data);
  }
}
