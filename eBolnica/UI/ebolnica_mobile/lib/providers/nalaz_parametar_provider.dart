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
      int laboratorijskiNalazId) async {
    var url =
        "${BaseProvider.baseUrl}NalazParametar/GetNalazParametarValues?LaboratorijskiNalazId=$laboratorijskiNalazId";
    var uri = Uri.parse(url);
    var headers = createHeaders();
    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = json.decode(response.body) as List;
      return data.map((item) => NalazParametar.fromJson(item)).toList();
    }
    throw Exception("Failed to fetch NalazParametar values");
  }
}
