import 'package:ebolnica_desktop/models/Response/broj_zaposlenih_po_odjelu_response.dart';

import 'package:ebolnica_desktop/models/odjel_model.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OdjelProvider extends BaseProvider<Odjel> {
  OdjelProvider() : super("Odjel");
  @override
  Odjel fromJson(data) {
    return Odjel.fromJson(data);
  }

  Future<List<BrojZaposlenihPoOdjeluResponse>>
      getUkupanBrojZaposlenihPoOdjelima() async {
    var url = "${BaseProvider.baseUrl}Odjel/broj-zaposlenih";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      if (data is List) {
        return data
            .map((item) => BrojZaposlenihPoOdjeluResponse.fromJson(item))
            .toList();
      } else {
        throw Exception("Očekivana lista iz JSON odgovora");
      }
    }
    throw Exception("Greška prilikom dohvaćanja podataka");
  }
}
