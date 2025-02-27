import 'package:ebolnica_mobile/models/medicinska_dokumentacija_model.dart';
import 'package:ebolnica_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MedicinskaDokumentacijaProvider
    extends BaseProvider<MedicinskaDokumentacija> {
  MedicinskaDokumentacijaProvider() : super("MedicinskaDokumentacija");
  @override
  MedicinskaDokumentacija fromJson(data) {
    return MedicinskaDokumentacija.fromJson(data);
  }

  Future<MedicinskaDokumentacija?> getMedicinskaDokumentacijaByPacijentId(
      int pacijentId) async {
    var url =
        "${BaseProvider.baseUrl}MedicinskaDokumentacija/getMedicinskaDokumentacija/$pacijentId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return MedicinskaDokumentacija.fromJson(data);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception("Greška: ${response.statusCode}");
    }
  }
}
