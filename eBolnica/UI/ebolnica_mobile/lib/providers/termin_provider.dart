import 'dart:convert';
import 'package:ebolnica_mobile/models/termin_model.dart';
import 'package:ebolnica_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class TerminProvider extends BaseProvider<Termin> {
  TerminProvider() : super("Termin");
  @override
  Termin fromJson(data) {
    return Termin.fromJson(data);
  }

  Future<List<String>> getZauzetiTermini(DateTime datum, int doktorId) async {
    var url =
        "${BaseProvider.baseUrl}Termin/zauzeti-termini?datum=$datum&doktorId=$doktorId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      if (data is List) {
        List<String> lista = List<String>.from(data);
        return lista;
      } else {
        throw Exception("Ocekivana lista iz JSON odgovora");
      }
    }
    throw Exception("Greska");
  }
}
