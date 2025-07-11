import 'package:ebolnica_desktop/models/Response/popunjenost_bolnice_response.dart';
import 'package:ebolnica_desktop/models/krevet_model.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class KrevetProvider extends BaseProvider<Krevet> {
  KrevetProvider() : super("Krevet");
  @override
  Krevet fromJson(data) {
    return Krevet.fromJson(data);
  }

  Future<List<Krevet>> getSlobodanKrevetBySobaId(int sobaId) async {
    var url =
        "${BaseProvider.baseUrl}Krevet/GetSlobodanKrevetBySobaId?sobaId=$sobaId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      if (data is List) {
        List<Krevet> lista = data.map((item) => Krevet.fromJson(item)).toList();
        return lista;
      } else {
        throw Exception("Ocekivana lista iz JSON odgovora");
      }
    }
    throw Exception("Greska");
  }

  Future<PopunjenostBolniceResponse> getPopunjenostBolnice() async {
    var url = "${BaseProvider.baseUrl}Krevet/popunjenost";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return PopunjenostBolniceResponse.fromJson(data);
    }
    throw Exception("Greška prilikom dohvaćanja podataka");
  }
}
