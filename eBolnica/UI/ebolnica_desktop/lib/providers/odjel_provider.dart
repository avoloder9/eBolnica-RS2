import 'package:ebolnica_desktop/models/doktor_model.dart';
import 'package:ebolnica_desktop/models/odjel_model.dart';
import 'package:ebolnica_desktop/models/termin_model.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OdjelProvider extends BaseProvider<Odjel> {
  OdjelProvider() : super("Odjel");
  @override
  Odjel fromJson(data) {
    return Odjel.fromJson(data);
  }

  Future<List<Doktor>> getDoktorByOdjelId(int odjelId) async {
    var url = "${BaseProvider.baseUrl}Odjel/GetDoktorByOdjel?odjelId=$odjelId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      if (data is List) {
        List<Doktor> lista = data.map((item) => Doktor.fromJson(item)).toList();
        return lista;
      } else {
        throw Exception("Ocekivana lista iz JSON odgovora");
      }
    }
    throw Exception("Greska");
  }

  Future<List<Termin>> getTerminByOdjelId(int odjelId) async {
    var url =
        "${BaseProvider.baseUrl}Odjel/GetTerminByOdjelId?odjelId=$odjelId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      if (data is List) {
        List<Termin> lista = data.map((item) => Termin.fromJson(item)).toList();
        return lista;
      } else {
        throw Exception("Ocekivana lista iz JSON odgovora");
      }
    }
    throw Exception("Greska");
  }

  Future<Odjel?> getOdjelByDoktorId(int doktorId) async {
    var url = "${BaseProvider.baseUrl}Odjel/get-odjel/$doktorId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return Odjel.fromJson(data);
    }
    return null;
  }
}
