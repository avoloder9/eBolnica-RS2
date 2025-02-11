import 'package:ebolnica_desktop/models/medicinska_dokumentacija_model.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MedicinskaDokumentacijaProvider
    extends BaseProvider<MedicinskaDokumentacija> {
  MedicinskaDokumentacijaProvider() : super("MedicinskaDokumentacija");
  @override
  MedicinskaDokumentacija fromJson(data) {
    return MedicinskaDokumentacija.fromJson(data);
  }

  Future<MedicinskaDokumentacija> getMedicinskaDokumentacijaByPacijentId(
      int pacijentId) async {
    var url =
        "${BaseProvider.baseUrl}MedicinskaDokumentacija/getMedicinskaDokumentacija/$pacijentId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      if (data != null) {
        return MedicinskaDokumentacija.fromJson(data);
      } else {
        throw Exception("Ocekivana lista iz JSON odgovora");
      }
    }
    throw Exception("Greska");
  }
}
