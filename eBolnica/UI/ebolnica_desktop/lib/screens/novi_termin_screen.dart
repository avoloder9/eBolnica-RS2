import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/models/doktor_model.dart';
import 'package:ebolnica_desktop/models/odjel_model.dart';
import 'package:ebolnica_desktop/models/search_result.dart';
import 'package:ebolnica_desktop/providers/doktor_provider.dart';
import 'package:ebolnica_desktop/providers/odjel_provider.dart';
import 'package:ebolnica_desktop/providers/termin_provider.dart';
import 'package:ebolnica_desktop/screens/pacijent_termin_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoviTerminScreen extends StatefulWidget {
  final int pacijentId;
  final int userId;
  const NoviTerminScreen(
      {super.key, required this.pacijentId, required this.userId});

  @override
  _NoviTerminScreenState createState() => _NoviTerminScreenState();
}

class _NoviTerminScreenState extends State<NoviTerminScreen> {
  final _formKey = GlobalKey<FormState>();
  late DoktorProvider doktorProvider;
  late OdjelProvider odjelProvider;
  late TerminProvider terminProvider;
  List<String> odjeli = [];
  Odjel? odabraniOdjel;
  Doktor? odabraniDoktor;
  List<Doktor>? resultDoktor;
  SearchResult<Odjel>? resultOdjel;
  List<String> zauzetiTermini = [];
  DateTime selectedDate = DateTime.now();
  String? time;

  @override
  void initState() {
    super.initState();
    odjelProvider = OdjelProvider();
    doktorProvider = DoktorProvider();
    terminProvider = TerminProvider();
    fetchOdjeli();
  }

  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        zauzetiTermini = [];
      });
      loadZauzetiTermini();
    }
  }

  Future<void> loadZauzetiTermini() async {
    try {
      var result = await terminProvider.getZauzetiTermini(
          selectedDate, odabraniDoktor!.doktorId!);
      setState(() {
        zauzetiTermini = result;
      });
    } catch (e) {
      debugPrint('Greška pri učitavanju zauzetih termina: $e');
    }
  }

  Future<void> fetchOdjeli() async {
    try {
      SearchResult<Odjel> fetchedResult = await odjelProvider.get();
      debugPrint('Fetched Odjeli: ${fetchedResult.result}');
      setState(() {
        resultOdjel = fetchedResult;
      });
    } catch (e) {
      debugPrint('Error fetching odjeli: $e');
    }
  }

  Future<void> fetchDoktor() async {
    try {
      if (odabraniOdjel != null && odabraniOdjel!.odjelId != null) {
        List<Doktor> fetchedResult =
            await odjelProvider.getDoktorByOdjelId(odabraniOdjel!.odjelId!);
        debugPrint('Fetched Doktor: $fetchedResult');
        setState(() {
          resultDoktor = fetchedResult;
        });
      } else {
        debugPrint("Odabrani odjel je null");
      }
    } catch (e) {
      debugPrint('Error fetching doktori: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(15.0),
      title: const Center(
        child: Text(
          "Novi termin",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: DropdownButtonFormField<Odjel>(
                    value: odabraniOdjel,
                    decoration: InputDecoration(
                      labelText: 'Odjel',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: const Icon(Icons.business),
                    ),
                    items: resultOdjel?.result
                        .map((odjel) => DropdownMenuItem(
                              value: odjel,
                              child: Text(odjel.naziv.toString()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        odabraniOdjel = value;
                        odabraniDoktor = null;
                        resultDoktor = [];
                      });
                      fetchDoktor();
                    },
                    validator: (value) {
                      if (value == null || value.naziv == "") {
                        return 'Molimo odaberite odjel';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: DropdownButtonFormField<Doktor>(
                    value: resultDoktor?.contains(odabraniDoktor) == true
                        ? odabraniDoktor
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Doktor',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: const Icon(Icons.business),
                    ),
                    items: (resultDoktor ?? [])
                        .map((doktor) => DropdownMenuItem(
                              value: doktor,
                              child: Text(
                                  "${doktor.korisnik?.ime ?? "Nepoznato"} ${doktor.korisnik?.prezime ?? "Nepoznato"}"),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        odabraniDoktor = value;
                        zauzetiTermini = [];
                      });
                      loadZauzetiTermini();
                    },
                    validator: (value) {
                      if (value == null || value.korisnik!.ime == "") {
                        return 'Molimo odaberite odjel';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(children: [
                    GestureDetector(
                      onTap: pickDate,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('yyyy-MM-dd').format(selectedDate),
                              style: const TextStyle(fontSize: 18),
                            ),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Wrap(
                    spacing: 11,
                    direction: Axis.horizontal,
                    runSpacing: 8,
                    alignment: WrapAlignment.spaceBetween,
                    children: List.generate(12, (index) {
                      int hour = 9 + index ~/ 3;
                      int minute = (index % 3) * 20;

                      String selectedTime =
                          "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
                      bool isZauzet = zauzetiTermini.contains(selectedTime);
                      return ElevatedButton(
                        onPressed: isZauzet
                            ? null
                            : () {
                                setState(() {
                                  time = selectedTime;
                                });
                                debugPrint('Odabran termin: $time');
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isZauzet ? Colors.grey : Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(selectedTime),
                      );
                    }),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Odustani")),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            var noviTermin = {
                              "pacijentId": widget.pacijentId,
                              "doktorId": odabraniDoktor!.doktorId,
                              "odjelId": odabraniOdjel!.odjelId,
                              "datumTermina":
                                  DateFormat('yyyy-MM-dd').format(selectedDate),
                              "vrijemeTermina": "$time:00",
                              "otkazano": false,
                            };
                            print(noviTermin);
                            try {
                              await terminProvider.insert(noviTermin);
                              await Flushbar(
                                      message: "Termin je uspješno dodan",
                                      backgroundColor: Colors.green,
                                      duration: const Duration(seconds: 3))
                                  .show(context);
                              setState(() {});
                              _formKey.currentState?.reset();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TerminiScreen(
                                          userId: widget.userId,
                                        )),
                              );
                            } catch (e) {
                              await Flushbar(
                                      message:
                                          "Došlo je do greške. Pokušajte ponovo.",
                                      backgroundColor: Colors.red,
                                      duration: const Duration(seconds: 2))
                                  .show(context);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        child: const Text(
                          "Zakaži termin",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
