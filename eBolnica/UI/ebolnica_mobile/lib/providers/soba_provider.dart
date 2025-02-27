import 'dart:convert';

import 'package:ebolnica_mobile/models/soba_model.dart';
import 'package:ebolnica_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class SobaProvider extends BaseProvider<Soba> {
  SobaProvider() : super("Soba");

  @override
  Soba fromJson(data) {
    return Soba.fromJson(data);
  }

  Future<List<Soba>> getSobeByOdjelId(int odjelId) async {
    var url = "${BaseProvider.baseUrl}Soba/GetSobaByOdjelId?odjelId=$odjelId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      if (data is List) {
        List<Soba> lista = data.map((item) => Soba.fromJson(item)).toList();
        return lista;
      } else {
        throw Exception("Ocekivana lista iz JSON odgovora");
      }
    }
    throw Exception("Greska");
  }

  Future<List<Soba>> getSlobodneSobeByOdjelId(int odjelId) async {
    var url =
        "${BaseProvider.baseUrl}Soba/GetSlobodnaSobaByOdjelId?odjelId=$odjelId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      if (data is List) {
        List<Soba> lista = data.map((item) => Soba.fromJson(item)).toList();
        return lista;
      } else {
        throw Exception("Ocekivana lista iz JSON odgovora");
      }
    }
    throw Exception("Greska");
  }
}
