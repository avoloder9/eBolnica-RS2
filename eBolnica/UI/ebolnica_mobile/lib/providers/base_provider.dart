import 'dart:convert';
import 'package:ebolnica_mobile/models/search_result.dart';
import 'package:ebolnica_mobile/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  static String? _baseUrl;
  String _endpoint = "";

  BaseProvider(String endpoint) {
    _endpoint = endpoint;
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:5218/");
  }
  static String get baseUrl {
    if (_baseUrl == null) {
      throw Exception("Base URL is not set");
    }
    return _baseUrl!;
  }

  Future<SearchResult<T>> get(
      {dynamic filter, int? page, int? pageSize}) async {
    var url = "$_baseUrl$_endpoint";

    Map<String, dynamic> queryParams = {};

    if (filter != null) {
      queryParams.addAll(Map<String, dynamic>.from(filter));
    }

    if (page != null) {
      queryParams['page'] = page;
    }
    if (pageSize != null) {
      queryParams['pageSize'] = pageSize;
    }
    if (queryParams.isNotEmpty) {
      var queryString = getQueryString(queryParams);
      url = "$url?$queryString";
    }
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = SearchResult<T>();

      result.count = data['count'];

      for (var item in data['resultList']) {
        result.result.add(fromJson(item));
      }

      return result;
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<T> getById(int id) async {
    var url = "$_baseUrl$_endpoint/$id";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<T> insert(dynamic request) async {
    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<T> update(int id, [dynamic request]) async {
    var url = "$_baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  T fromJson(data) {
    throw Exception("Method not implemented");
  }

  bool isValidResponse(Response response) {
    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      }

      final errorResponse = jsonDecode(response.body);

      if (response.statusCode == 400) {
        throw UserFriendlyException(
            errorResponse['message'] ?? "Neispravan zahtjev.");
      } else if (response.statusCode == 401) {
        throw UserFriendlyException("Pogrešno korisničko ime ili lozinka");
      } else if (response.statusCode == 403) {
        throw UserFriendlyException(
            errorResponse['message'] ?? "Pristup odbijen.");
      } else if (response.statusCode == 404) {
        if (response.body.contains("doktori")) {
          throw UserFriendlyException(
              "Potrebno je dodati doktore na ovaj odjel.");
        }
        throw UserFriendlyException("Trazeni resurs nije pronađen.");
      } else if (response.statusCode >= 500) {
        throw UserFriendlyException("Greška na serveru. Pokušajte kasnije.");
      }

      if (errorResponse is Map<String, dynamic> &&
          errorResponse['errors'] != null &&
          errorResponse['errors']['userError'] != null) {
        throw UserFriendlyException(
            errorResponse['errors']['userError'].join(', '));
      }

      throw UserFriendlyException(
          "Došlo je do neočekivane greške. Pokušajte ponovo.");
    } catch (e) {
      if (e is UserFriendlyException) {
        throw e;
      }
      throw UserFriendlyException(
          "Neuspjela obrada odgovora. Provjerite vezu i pokušajte ponovo.");
    }
  }

  Map<String, String> createHeaders() {
    String username = AuthProvider.username ?? "";
    String password = AuthProvider.password ?? "";

    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };

    return headers;
  }

  String getQueryString(Map params,
      {String prefix = '&', bool inRecursion = false}) {
    String query = '';
    params.forEach((key, value) {
      if (inRecursion) {
        if (key is int) {
          key = '[$key]';
        } else if (value is List || value is Map) {
          key = '.$key';
        } else {
          key = '.$key';
        }
      }
      if (value is String || value is int || value is double || value is bool) {
        var encoded = value;
        if (value is String) {
          encoded = Uri.encodeComponent(value);
        }
        query += '$prefix$key=$encoded';
      } else if (value is DateTime) {
        query += '$prefix$key=${(value as DateTime).toIso8601String()}';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query +=
              getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
        });
      }
    });
    return query;
  }
}

class UserFriendlyException implements Exception {
  final String message;

  UserFriendlyException(this.message);

  @override
  String toString() => message;
}
