import 'package:ebolnica_mobile/models/doktor_model.dart';
import 'package:ebolnica_mobile/models/pacijent_model.dart';
import 'package:ebolnica_mobile/models/pregledi_response.dart';
import 'package:ebolnica_mobile/models/terapija_model.dart';

import 'package:ebolnica_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PacijentProvider extends BaseProvider<Pacijent> {
  PacijentProvider() : super("Pacijent");

  @override
  Pacijent fromJson(data) {
    return Pacijent.fromJson(data);
  }

  Future<int?> getPacijentIdByKorisnikId(int korisnikId) async {
    var url =
        "${BaseProvider.baseUrl}Pacijent/GetPacijentIdByKorisnikId/$korisnikId";
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

  Future<List<Pacijent>> getPacijentSaDokumentacijom() async {
    var url = "${BaseProvider.baseUrl}Pacijent/GetPacijentSaDokumenticijom";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      if (data is List) {
        List<Pacijent> lista =
            data.map((item) => Pacijent.fromJson(item)).toList();
        return lista;
      } else {
        throw Exception("Ocekivana lista iz JSON odgovora");
      }
    }
    throw Exception("Greska");
  }

  Future<List<Pacijent>> getPacijentiZaHospitalizaciju() async {
    var url = "${BaseProvider.baseUrl}Pacijent/GetPacijentiZaHospitalizaciju";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      if (data is List) {
        List<Pacijent> lista =
            data.map((item) => Pacijent.fromJson(item)).toList();
        return lista;
      } else {
        throw Exception("Ocekivana lista iz JSON odgovora");
      }
    }
    throw Exception("Greska");
  }

  Future<List<PreglediResponse>> getPreglediByPacijentId(int pacijentId) async {
    var url =
        "${BaseProvider.baseUrl}Pacijent/getPregledByPacijentId/$pacijentId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body) as List;
      return data.map((item) => PreglediResponse.fromJson(item)).toList();
    }

    throw Exception("Greška pri dobavljanju pregleda.");
  }

  Future<List<Terapija>> getAktivneTerapijeByPacijentId(int pacijentId) async {
    var url =
        "${BaseProvider.baseUrl}Pacijent/getAktivneTerapijeByPacijentId/$pacijentId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body) as List;
      return data.map((item) => Terapija.fromJson(item)).toList();
    }

    throw Exception("Greška pri dobavljanju terapija.");
  }

  Future<List<Terapija>> getGotoveTerapijeByPacijentId(int pacijentId) async {
    var url =
        "${BaseProvider.baseUrl}Pacijent/getGotoveTerapijeByPacijentId/$pacijentId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body) as List;
      return data.map((item) => Terapija.fromJson(item)).toList();
    }

    throw Exception("Greška pri dobavljanju terapija.");
  }

  Future<List<Doktor>> getRecommendedDoktori(int pacijentId) async {
    var url = "${BaseProvider.baseUrl}Pacijent/$pacijentId/recommended-doktori";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      if (data is List) {
        return data.map((item) => Doktor.fromJson(item)).toList();
      } else {
        throw Exception("Očekivana lista iz JSON odgovora");
      }
    }
    throw Exception("Greška prilikom dohvata preporučenih doktora");
  }
}
