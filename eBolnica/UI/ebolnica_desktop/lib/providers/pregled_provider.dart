import 'package:ebolnica_desktop/models/Response/broj_pregleda_po_danu_response.dart';
import 'package:ebolnica_desktop/models/pregled_model.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PregledProvider extends BaseProvider<Pregled> {
  PregledProvider() : super("Pregled");
  @override
  Pregled fromJson(data) {
    return Pregled.fromJson(data);
  }

  Future<List<BrojPregledaPoDanuResponse>> getBrojPregledaPoDanu(
      int brojDana) async {
    var url = "${BaseProvider.baseUrl}Pregled/broj-pregleda?brojDana=$brojDana";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      if (data is List) {
        return data
            .map((item) => BrojPregledaPoDanuResponse.fromJson(item))
            .toList();
      } else {
        throw Exception("Očekivana lista iz JSON odgovora");
      }
    }
    throw Exception("Greška prilikom dohvaćanja podataka");
  }
}
