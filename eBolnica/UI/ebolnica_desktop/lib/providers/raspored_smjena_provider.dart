import 'package:ebolnica_desktop/models/raspored_smjena_model.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class RasporedSmjenaProvider extends BaseProvider<RasporedSmjena> {
  RasporedSmjenaProvider() : super("RasporedSmjena");
  @override
  RasporedSmjena fromJson(data) {
    return RasporedSmjena.fromJson(data);
  }

  Future<void> generisiRaspored(DateTime startDate, DateTime endDate) async {
    var url =
        "${BaseProvider.baseUrl}RasporedSmjena/generisi-raspored?startDate=$startDate&endDate=$endDate";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.post(uri, headers: headers);

    if (response.statusCode != 200) {
      throw Exception("Greška pri generisanju rasporeda: ${response.body}");
    }
  }
}
