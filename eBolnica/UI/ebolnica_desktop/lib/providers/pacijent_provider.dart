import 'package:ebolnica_desktop/models/Response/broj_pacijenata_response.dart';
import 'package:ebolnica_desktop/models/hospitalizacija_model.dart';
import 'package:ebolnica_desktop/models/laboratorijski_nalaz_model.dart';
import 'package:ebolnica_desktop/models/operacija_model.dart';
import 'package:ebolnica_desktop/models/otpusno_pismo_model.dart';
import 'package:ebolnica_desktop/models/pacijent_model.dart';
import 'package:ebolnica_desktop/models/pregled_model.dart';
import 'package:ebolnica_desktop/models/terapija_model.dart';
import 'package:ebolnica_desktop/models/termin_model.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PacijentProvider extends BaseProvider<Pacijent> {
  PacijentProvider() : super("Pacijent");

  @override
  Pacijent fromJson(data) {
    return Pacijent.fromJson(data);
  }

  Future<List<Termin>> getTerminByPacijentId(int pacijentId) async {
    var url =
        "${BaseProvider.baseUrl}Pacijent/GetTerminByPacijent?pacijentId=$pacijentId";
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

  Future<List<Pregled>> getPreglediByPacijentId(int pacijentId) async {
    var url =
        "${BaseProvider.baseUrl}Pacijent/getPregledByPacijentId/$pacijentId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body) as List;
      return data.map((item) => Pregled.fromJson(item)).toList();
    }

    throw Exception("Greška pri dobavljanju pregleda.");
  }

  Future<List<Hospitalizacija>> getHospitalizacijeByPacijentId(
      int pacijentId) async {
    var url =
        "${BaseProvider.baseUrl}Pacijent/getHospitalizacijeByPacijentId/$pacijentId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body) as List;
      return data.map((item) => Hospitalizacija.fromJson(item)).toList();
    }

    throw Exception("Greška pri dobavljanju hospitalizacija.");
  }

  Future<List<OtpusnoPismo>> getOtpusnaPismaByPacijentId(int pacijentId) async {
    var url =
        "${BaseProvider.baseUrl}Pacijent/getOtpusnaPismaByPacijentId/$pacijentId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body) as List;
      return data.map((item) => OtpusnoPismo.fromJson(item)).toList();
    }

    throw Exception("Greška pri dobavljanju otpusnih pisama.");
  }

  Future<List<Terapija>> getTerapijaByPacijentId(int pacijentId) async {
    var url =
        "${BaseProvider.baseUrl}Pacijent/getTerapijaByPacijentId/$pacijentId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body) as List;
      return data.map((item) => Terapija.fromJson(item)).toList();
    }

    throw Exception("Greška pri dobavljanju terapija.");
  }

  Future<List<Operacija>> GetOperacijeByPacijentId(int pacijentId) async {
    var url =
        "${BaseProvider.baseUrl}Pacijent/getOperacijeByPacijentId/$pacijentId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body) as List;
      return data.map((item) => Operacija.fromJson(item)).toList();
    }

    throw Exception("Greška pri dobavljanju operacija.");
  }

  Future<List<LaboratorijskiNalaz>> GetNalaziByPacijentId(
      int pacijentId) async {
    var url =
        "${BaseProvider.baseUrl}Pacijent/getNalaziByPacijentId/$pacijentId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body) as List;
      return data.map((item) => LaboratorijskiNalaz.fromJson(item)).toList();
    }

    throw Exception("Greška pri dobavljanju nalaza.");
  }

  Future<List<BrojPacijenataResponse>> getBrojPacijenata() async {
    var url = "${BaseProvider.baseUrl}Pacijent/broj-pacijenata";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      if (data is Map<String, dynamic>) {
        return [BrojPacijenataResponse.fromJson(data)];
      } else {
        throw Exception("Očekivana mapa iz JSON odgovora");
      }
    }
    throw Exception("Greška prilikom dohvaćanja podataka");
  }
}
