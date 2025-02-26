import 'package:ebolnica_desktop/models/otpusno_pismo_model.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';

class OtpusnoPismoProvider extends BaseProvider<OtpusnoPismo> {
  OtpusnoPismoProvider() : super("OtpusnoPismo");
  @override
  OtpusnoPismo fromJson(data) {
    return OtpusnoPismo.fromJson(data);
  }
}
