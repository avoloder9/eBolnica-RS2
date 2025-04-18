import 'package:ebolnica_desktop/models/doktor_model.dart';
import 'package:ebolnica_desktop/models/operacija_model.dart';
import 'package:ebolnica_desktop/models/pregled_model.dart';
import 'package:ebolnica_desktop/models/termin_model.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<List<Termin>> getTerminByDoktorId(int doktorId) async {
    var url = "${BaseProvider.baseUrl}Doktor/GetTerminByDoktorId/$doktorId";
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

  Future<List<Pregled>> getPreglediByDoktorId(int doktorId) async {
    var url = "${BaseProvider.baseUrl}Doktor/GetPregledByDoktorId/$doktorId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      if (data is List) {
        List<Pregled> lista =
            data.map((item) => Pregled.fromJson(item)).toList();
        return lista;
      } else {
        throw Exception("Ocekivana lista iz JSON odgovora");
      }
    }
    throw Exception("Greska");
  }

  Future<List<Operacija>> getOperacijeByDoktorId(int doktorId) async {
    var url = "${BaseProvider.baseUrl}Doktor/GetOperacijeByDoktorId/$doktorId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      if (data is List) {
        List<Operacija> lista =
            data.map((item) => Operacija.fromJson(item)).toList();
        return lista;
      } else {
        throw Exception("Ocekivana lista iz JSON odgovora");
      }
    }
    throw Exception("Greska");
  }
}
