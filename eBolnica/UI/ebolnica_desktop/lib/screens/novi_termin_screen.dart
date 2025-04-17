import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/models/doktor_model.dart';
import 'package:ebolnica_desktop/models/odjel_model.dart';
import 'package:ebolnica_desktop/models/pacijent_model.dart';
import 'package:ebolnica_desktop/models/search_result.dart';
import 'package:ebolnica_desktop/providers/doktor_provider.dart';
import 'package:ebolnica_desktop/providers/odjel_provider.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';
import 'package:ebolnica_desktop/providers/termin_provider.dart';
import 'package:ebolnica_desktop/screens/odjel_termini_screen.dart';
import 'package:ebolnica_desktop/screens/pacijent_termin_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoviTerminScreen extends StatefulWidget {
  final int? pacijentId;
  final int? odjelId;
  final int userId;
  const NoviTerminScreen(
      {super.key, this.pacijentId, this.odjelId, required this.userId});

  @override
  _NoviTerminScreenState createState() => _NoviTerminScreenState();
}

class _NoviTerminScreenState extends State<NoviTerminScreen> {
  final _formKey = GlobalKey<FormState>();
  late DoktorProvider doktorProvider;
  late OdjelProvider odjelProvider;
  late TerminProvider terminProvider;
  late PacijentProvider pacijentProvider;
  List<Pacijent> pacijenti = [];
  Pacijent? odabraniPacijent;
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
    pacijentProvider = PacijentProvider();
    fetchOdjeli().then((_) {
      if (widget.odjelId != null && resultOdjel != null) {
        var matchingOdjel = resultOdjel!.result.firstWhere(
            (odjel) => odjel.odjelId == widget.odjelId,
            orElse: () => Odjel());
        if (matchingOdjel.odjelId != null) {
          setState(() {
            odabraniOdjel = matchingOdjel;
          });
          fetchDoktor();
        }
      }
    });
    if (widget.pacijentId == null) {
      fetchPacijente();
    }
  }

  void fetchPacijente() async {
    final result = await pacijentProvider.getPacijentSaDokumentacijom();
    setState(() {
      pacijenti = result;
    });
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
                widget.pacijentId != null
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: DropdownButtonFormField<Pacijent>(
                          value: odabraniPacijent,
                          decoration: InputDecoration(
                            labelText: 'Pacijent',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: const Icon(Icons.person),
                          ),
                          items: pacijenti.map((pacijent) {
                            return DropdownMenuItem(
                              value: pacijent,
                              child: Text(
                                  "${pacijent.korisnik!.ime} ${pacijent.korisnik!.prezime}"),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              odabraniPacijent = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Molimo odaberite pacijenta';
                            }
                            return null;
                          },
                        ),
                      ),
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
                    onChanged: widget.odjelId != null
                        ? null
                        : (value) {
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
                      bool isSelektovan = selectedTime == time;
                      return ElevatedButton(
                        onPressed: isZauzet
                            ? null
                            : () {
                                setState(() {
                                  time = selectedTime;
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isZauzet
                              ? Colors.grey
                              : isSelektovan
                                  ? Colors.green
                                  : Colors.blue,
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
                              "pacijentId": widget.pacijentId ??
                                  odabraniPacijent?.pacijentId,
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

                              if (mounted) {
                                setState(() {
                                  odabraniPacijent = null;
                                  odabraniDoktor = null;
                                  odabraniOdjel = null;
                                });
                              }
                              if (mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      if (widget.odjelId != null) {
                                        return OdjelTerminiScreen(
                                            userId: widget.userId);
                                      } else {
                                        return TerminiScreen(
                                          userId: widget.userId,
                                        );
                                      }
                                    },
                                  ),
                                );
                                return;
                              }
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
