import 'package:ebolnica_desktop/models/terapija_model.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TerapijaProvider extends BaseProvider<Terapija> {
  TerapijaProvider() : super("Terapija");

  @override
  Terapija fromJson(data) {
    return Terapija.fromJson(data);
  }

  Future<Terapija> getTerapijabyPregledId(int pregledId) async {
    var url =
        "${BaseProvider.baseUrl}Terapija/getTerapijabyPregledId/$pregledId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      if (data != null) {
        return Terapija.fromJson(data);
      } else {
        throw Exception("Ocekivana lista iz JSON odgovora");
      }
    }
    throw Exception("Greska");
  }
}
