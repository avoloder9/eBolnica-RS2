import 'package:ebolnica_mobile/models/medicinsko_osoblje_model.dart';
import 'package:ebolnica_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class MedicinskoOsobljeProvider extends BaseProvider<MedicinskoOsoblje> {
  MedicinskoOsobljeProvider() : super("MedicinskoOsoblje");

  @override
  MedicinskoOsoblje fromJson(data) {
    return MedicinskoOsoblje.fromJson(data);
  }

  Future<int?> getOsobljeByKorisnikId(int korisnikId) async {
    var url =
        "${BaseProvider.baseUrl}MedicinskoOsoblje/GetMedicinskoOsobljeIdByKorisnikId/$korisnikId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = int.tryParse(response.body);

      if (data != null) {
        return data;
      } else {
        throw Exception("PacijentId not found or invalid response.");
      }
    }

    throw Exception("Failed to get PacijentId");
  }

  Future<int?> getOdjelIdByMedicinskoOsoljeId(int odjelId) async {
    var url =
        "${BaseProvider.baseUrl}MedicinskoOsoblje/GetOdjelIdByMedicinskoOsoljeId/$odjelId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = int.tryParse(response.body);

      if (data != null) {
        return data;
      } else {
        throw Exception("PacijentId not found or invalid response.");
      }
    }

    throw Exception("Failed to get PacijentId");
  }
}
