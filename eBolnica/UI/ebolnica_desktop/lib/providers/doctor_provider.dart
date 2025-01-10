import 'dart:convert';

import 'package:ebolnica_desktop/providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class DoctorProvider {
  static String? _baseUrl;
  DoctorProvider() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://localhost:5218/");
  }

  Future<dynamic> get() async {
    var url = "${_baseUrl}Doktor";
    var uri = Uri.parse(url);

    var response = await http.get(uri, headers: createHeaders());

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Unknown exception");
    }
  }

  bool isValidResponse(Response response) {
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw Exception("Unathorized");
    } else {
      throw Exception("Something bad happeend, please try again!");
    }
  }

  Map<String, String> createHeaders() {
    String username = AuthProvider.username!;
    String password = AuthProvider.password!;
    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";
    var headers = {
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };
    return headers;
  }
}
