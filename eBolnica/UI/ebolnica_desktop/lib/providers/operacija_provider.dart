import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/models/operacija_model.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class OperacijaProvider extends BaseProvider<Operacija> {
  OperacijaProvider() : super("Operacija");
  @override
  Operacija fromJson(data) {
    return Operacija.fromJson(data);
  }

  final Map<String, String> actionDescriptions = {
    "Activate": "aktivirati ovu operaciju",
    "Edit": "urediti podatke",
    "Hide": "sakriti ovu operaciju",
    "Close": "završiti ovu operaciju",
    "Update": "ažurirati operaciju",
    "Cancel": "otkazati ovu operaciju",
  };
  Future<List<String>> getZauzetiTermini(
      int doktorId, DateTime datumOperacije) async {
    var url =
        "${BaseProvider.baseUrl}Operacija/zauzet-termin?doktorId=$doktorId&datumOperacije=${datumOperacije.toIso8601String()}";
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

  Future<List<String>> fetchAllowedActions(int operacijaId) async {
    var url = "${BaseProvider.baseUrl}Operacija/$operacijaId/allowedActions";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      return List<String>.from(jsonDecode(response.body));
    }
    throw Exception("Greška prilikom dohvatanja dozvoljenih akcija");
  }

  Future<void> sendActionRequest(BuildContext context, int operacijaId,
      String action, VoidCallback onUpdate) async {
    var url =
        "${BaseProvider.baseUrl}Operacija/$operacijaId/${action.toLowerCase()}";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.put(uri, headers: headers);
    if (response.statusCode == 200) {
      await Flushbar(
              message: "Akcija je uspješno izvršena",
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3))
          .show(context);
      onUpdate();
    } else {
      await Flushbar(
              message: "Greška prilikom izvršavanja akcije",
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3))
          .show(context);
    }
  }

  void showConfirmationDialog(BuildContext context, int operacijaId,
      String action, VoidCallback onUpdate) {
    String actionDescription = actionDescriptions[action] ?? "Nepoznata akcija";
    showCustomDialog(
        context: context,
        title: "Potvrda akcije",
        message: "Da li ste sigurni da želite $actionDescription?",
        confirmText: "Da",
        onConfirm: () {
          sendActionRequest(context, operacijaId, action, onUpdate);
        });
  }

  Widget buildOperacijaButtons(
      BuildContext context, int operacijaId, VoidCallback onActionCompleted) {
    return StatefulBuilder(
      builder: (context, setState) {
        return FutureBuilder<List<String>>(
          future: fetchAllowedActions(operacijaId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Greška: ${snapshot.error}");
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text("Nema dostupnih akcija");
            }

            List<String> allowedActions = snapshot.data!;

            return Row(
              children: [
                if (allowedActions.contains("Activate"))
                  ElevatedButton(
                    onPressed: () => showConfirmationDialog(
                        context, operacijaId, "Activate", () {
                      setState(() {});
                      onActionCompleted();
                    }),
                    child: const Text("Aktiviraj"),
                  ),
                if (allowedActions.contains("Edit"))
                  ElevatedButton(
                    onPressed: () => showConfirmationDialog(
                        context, operacijaId, "Edit", () {
                      setState(() {});
                    }),
                    child: const Text("Ažuriraj"),
                  ),
                if (allowedActions.contains("Hide"))
                  ElevatedButton(
                    onPressed: () => showConfirmationDialog(
                        context, operacijaId, "Hide", () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {});
                      });
                    }),
                    child: const Text("Sakrij"),
                  ),
                if (allowedActions.contains("Close"))
                  ElevatedButton(
                    onPressed: () => showConfirmationDialog(
                        context, operacijaId, "Close", () {
                      setState(() {});
                      onActionCompleted();
                    }),
                    child: const Text("Završi"),
                  ),
                if (allowedActions.contains("Update"))
                  ElevatedButton(
                    onPressed: () {
                      showUpdateDialog(context, operacijaId, () {
                        setState(() {});
                        onActionCompleted();
                      });
                    },
                    child: const Text("Uredi"),
                  ),
                if (allowedActions.contains("Cancelled"))
                  ElevatedButton(
                    onPressed: () => showConfirmationDialog(
                        context, operacijaId, "Cancel", () {
                      setState(() {});
                    }),
                    child: const Text("Otkaži"),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  void showUpdateDialog(
      BuildContext context, int operacijaId, VoidCallback onUpdate) async {
    try {
      var url = "${BaseProvider.baseUrl}Operacija/$operacijaId";
      var uri = Uri.parse(url);
      var headers = createHeaders();

      var response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        var operacijaData = jsonDecode(response.body);

        TextEditingController tipOperacijeController =
            TextEditingController(text: operacijaData["tipOperacije"]);
        TextEditingController komentarController =
            TextEditingController(text: operacijaData["komentar"]);
        int doktorId = operacijaData["doktorId"];
        DateTime datumOperacije =
            DateTime.parse(operacijaData["datumOperacije"]);

        TextEditingController datumController =
            TextEditingController(text: formattedDate(datumOperacije));

        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Uredi operaciju",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: tipOperacijeController,
                      decoration: const InputDecoration(
                        labelText: "Tip operacije",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: komentarController,
                      decoration: const InputDecoration(
                        labelText: "Komentar",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: datumController,
                      decoration: const InputDecoration(
                        labelText: "Datum operacije",
                        border: OutlineInputBorder(),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: datumOperacije,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          datumController.text = formattedDate(pickedDate);
                          datumOperacije = pickedDate;
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                          ),
                          child: const Text(
                            "Odustani",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () async {
                            var updateData = {
                              "tipOperacije": tipOperacijeController.text,
                              "komentar": komentarController.text,
                              "doktorId": doktorId,
                              "datumOperacije":
                                  datumOperacije.toIso8601String(),
                            };

                            var updateResponse = await http.put(
                              uri,
                              headers: headers,
                              body: jsonEncode(updateData),
                            );

                            if (updateResponse.statusCode == 200) {
                              await Flushbar(
                                message: "Operacija uspješno ažurirana",
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 3),
                              ).show(context);
                              onUpdate();
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            } else {
                              await Flushbar(
                                message: "Greška prilikom ažuriranja",
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 3),
                              ).show(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Sačuvaj",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        throw Exception("Neuspješno dohvaćanje operacije");
      }
    } catch (e) {
      await Flushbar(
        message: "Došlo je do greške: $e",
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ).show(context);
    }
  }
}
