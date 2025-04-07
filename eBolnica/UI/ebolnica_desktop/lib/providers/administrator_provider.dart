import 'dart:convert';

import 'package:ebolnica_desktop/models/Response/dashboard_response.dart';
import 'package:ebolnica_desktop/models/administrator_model.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class AdministratorProvider extends BaseProvider<Administrator> {
  AdministratorProvider() : super("Administrator");
  @override
  Administrator fromJson(data) {
    return Administrator.fromJson(data);
  }

  Future<int?> getAdministratorIdByKorisnikId(int korisnikId) async {
    var url =
        "${BaseProvider.baseUrl}Administrator/GetAdministratorIdByKorisnikId/$korisnikId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = int.tryParse(response.body);

      if (data != null) {
        return data;
      } else {
        throw Exception("Administrator not found or invalid response.");
      }
    }

    throw Exception("Failed to get Administrator");
  }

  Future<List<DashboardResponse>> getDashboardData() async {
    var url = "${BaseProvider.baseUrl}Administrator/dashboard-data";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      if (data is Map<String, dynamic>) {
        return [DashboardResponse.fromJson(data)];
      } else {
        throw Exception("Očekivana mapa iz JSON odgovora");
      }
    }
    throw Exception("Greška prilikom dohvaćanja podataka");
  }
}
