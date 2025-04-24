import 'package:ebolnica_desktop/models/doktor_model.dart';

import 'package:ebolnica_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class DoktorProvider extends BaseProvider<Doktor> {
  DoktorProvider() : super("Doktor");
  @override
  Doktor fromJson(data) {
    return Doktor.fromJson(data);
  }

  Future<int?> getDoktorIdByKorisnikId(int korisnikId) async {
    var url =
        "${BaseProvider.baseUrl}Doktor/GetDoktorIdByKorisnikId/$korisnikId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = int.tryParse(response.body);

      if (data != null) {
        return data;
      } else {
        throw Exception("Doktor not found or invalid response.");
      }
    }

    throw Exception("Failed to get Doktor");
  }
}
