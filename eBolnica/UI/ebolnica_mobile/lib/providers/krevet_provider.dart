import 'package:ebolnica_mobile/models/krevet_model.dart';
import 'package:ebolnica_mobile/providers/base_provider.dart';
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
}
