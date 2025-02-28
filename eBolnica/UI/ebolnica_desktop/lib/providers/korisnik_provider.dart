import 'dart:convert';
import 'package:ebolnica_desktop/models/korisnik_model.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class KorisnikProvider extends BaseProvider<Korisnik> {
  KorisnikProvider() : super("Korisnik");
  @override
  Korisnik fromJson(data) {
    return Korisnik.fromJson(data);
  }

  Future<Map<String, dynamic>> login(
      String username, String password, String deviceType) async {
    var url = "${BaseProvider.baseUrl}Korisnik/login";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var body = jsonEncode(
        {"username": username, "password": password, "deviceType": deviceType});

    var response = await http.post(uri, headers: headers, body: body);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      var errorData = jsonDecode(response.body);
      String errorMessage =
          errorData['message'] ?? "Neuspješna autentifikacija";

      throw Exception(errorMessage);
    }
  }
}
