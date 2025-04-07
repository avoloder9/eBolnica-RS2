import 'package:ebolnica_mobile/models/nalaz_parametar_model.dart';
import 'package:ebolnica_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NalazParametarProvider extends BaseProvider<NalazParametar> {
  NalazParametarProvider() : super("NalazParametar");
  @override
  NalazParametar fromJson(data) {
    return NalazParametar.fromJson(data);
  }

  Future<List<NalazParametar>> getNalazParametarValues(
      {int? laboratorijskiNalazId, int? hospitalizacijaId}) async {
    var queryParams = <String, String>{};

    if (laboratorijskiNalazId != null) {
      queryParams["LaboratorijskiNalazId"] = laboratorijskiNalazId.toString();
    }
    if (hospitalizacijaId != null) {
      queryParams["HospitalizacijaId"] = hospitalizacijaId.toString();
    }

    var url = Uri.parse(
            "${BaseProvider.baseUrl}NalazParametar/GetNalazParametarValues")
        .replace(queryParameters: queryParams);

    var headers = createHeaders();
    var response = await http.get(url, headers: headers);

    if (isValidResponse(response)) {
      var data = json.decode(response.body) as List;
      return data.map((item) => NalazParametar.fromJson(item)).toList();
    }

    throw Exception("Failed to fetch NalazParametar values");
  }
}
