import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/models/uputnica_model.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UputnicaProvider extends BaseProvider<Uputnica> {
  UputnicaProvider() : super("Uputnica");
  @override
  Uputnica fromJson(data) {
    return Uputnica.fromJson(data);
  }

  Future<List<String>> fetchAllowedActions(int uputnicaId) async {
    var url = "${BaseProvider.baseUrl}Uputnica/$uputnicaId/allowedActions";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      return List<String>.from(jsonDecode(response.body));
    }
    throw Exception("Greška prilikom dohvatanja dozvoljenih akcija");
  }

  Future<void> sendActionRequest(
      BuildContext context, int uputnicaId, String action) async {
    var url =
        "${BaseProvider.baseUrl}Uputnica/$uputnicaId/${action.toLowerCase()}";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.put(uri, headers: headers);
    if (response.statusCode == 200) {
      Flushbar(
              message: "Akcija je uspješno izvršena",
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3))
          .show(context);
    } else {
      Flushbar(
              message: "Greska prilikom izvršavanja akcije",
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3))
          .show(context);
    }
  }

  void showConfirmationDialog(
      BuildContext context, int uputnicaId, String action) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(child: Text("Potvrda akcije")),
          content: Text("Da li ste sigurni da želite $action?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Ne"),
            ),
            ElevatedButton(
              onPressed: () {
                sendActionRequest(context, uputnicaId, action);
                Navigator.pop(context);
              },
              child: const Text("Da"),
            ),
          ],
        );
      },
    );
  }

  Widget buildUputnicaButtons(BuildContext context, int uputnicaId) {
    return StatefulBuilder(
      builder: (context, setState) {
        return FutureBuilder<List<String>>(
          future: fetchAllowedActions(uputnicaId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Greška: ${snapshot.error}");
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text("Nema dostupnih akcija");
            }

            List<String> allowedActions = snapshot.data!;

            Future<void> executeAction(String action) async {
              await sendActionRequest(context, uputnicaId, action);
              setState(() {});
            }

            return Row(
              children: [
                if (allowedActions.contains("Activate"))
                  ElevatedButton(
                    onPressed: () => executeAction("Activate"),
                    child: const Text("Aktiviraj"),
                  ),
                if (allowedActions.contains("Edit"))
                  ElevatedButton(
                    onPressed: () => executeAction("Edit"),
                    child: const Text("Ažuriraj"),
                  ),
                if (allowedActions.contains("Hide"))
                  ElevatedButton(
                    onPressed: () => executeAction("Hide"),
                    child: const Text("Sakrij"),
                  ),
                if (allowedActions.contains("Close"))
                  ElevatedButton(
                    onPressed: () => executeAction("Close"),
                    child: const Text("Otkaži"),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
