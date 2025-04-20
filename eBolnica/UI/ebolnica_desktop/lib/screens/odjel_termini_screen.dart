import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/models/search_result.dart';
import 'package:ebolnica_desktop/models/termin_model.dart';
import 'package:ebolnica_desktop/models/uputnica_model.dart';
import 'package:ebolnica_desktop/providers/medicinsko_osoblje_provider.dart';
import 'package:ebolnica_desktop/providers/odjel_provider.dart';
import 'package:ebolnica_desktop/providers/termin_provider.dart';
import 'package:ebolnica_desktop/providers/uputnica_provider.dart';
import 'package:ebolnica_desktop/screens/novi_termin_screen.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
import 'package:flutter/material.dart';

class OdjelTerminiScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  const OdjelTerminiScreen({super.key, required this.userId, this.userType});
  @override
  State<OdjelTerminiScreen> createState() => _OdjelTerminiScreenState();
}

class _OdjelTerminiScreenState extends State<OdjelTerminiScreen> {
  late OdjelProvider odjelProvider;
  late MedicinskoOsobljeProvider osobljeProvider;
  late UputnicaProvider uputnicaProvider;
  late TerminProvider terminProvider;
  int? osobljeId;
  int? odjelId;
  List<Termin>? termini = [];

  @override
  void initState() {
    super.initState();
    odjelProvider = OdjelProvider();
    osobljeProvider = MedicinskoOsobljeProvider();
    uputnicaProvider = UputnicaProvider();
    terminProvider = TerminProvider();
    fetchTermini();
  }

  Future<void> fetchTermini() async {
    termini = [];
    osobljeId = await osobljeProvider.getOsobljeByKorisnikId(widget.userId);
    if (osobljeId != null) {
      odjelId =
          await osobljeProvider.getOdjelIdByMedicinskoOsoljeId(osobljeId!);
      if (odjelId != null) {
        var result = await terminProvider.get(filter: {"OdjelId": odjelId!});
        setState(() {
          termini = result.result;
        });
        if (termini == null) {
          print("error");
        }
      } else
        print("error");
    } else
      print("error");
  }

  @override
  Widget build(BuildContext context) {
    if (termini == null || termini!.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchTermini();
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Termini"),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return NoviTerminScreen(
                      userId: widget.userId,
                      odjelId: odjelId,
                      userType: widget.userType,
                    );
                  },
                  barrierDismissible: false);
            },
            icon: const Icon(Icons.add),
            label: const Text("Dodaj novi termin"),
          ),
        ],
      ),
      drawer: SideBar(
        userType: widget.userType!,
        userId: widget.userId,
      ),
      body: Column(
        children: [_buildResultView()],
      ),
    );
  }

  Widget _buildResultView() {
    if (termini == null || termini!.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text(
            "Nemate zakazanih termina",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: DataTable(
            columns: const [
              DataColumn(label: Text("Pacijent")),
              DataColumn(label: Text("Doktor")),
              DataColumn(label: Text("Odjel")),
              DataColumn(label: Text("Datum termina")),
              DataColumn(label: Text("Vrijeme termina")),
              DataColumn(label: Text("")),
              DataColumn(label: Text("Uputnica")),
            ],
            rows: termini!
                .map<DataRow>(
                  (e) => DataRow(cells: [
                    DataCell(Text(
                        "${e.pacijent!.korisnik!.ime} ${e.pacijent!.korisnik!.prezime}")),
                    DataCell(Text(
                        "${e.doktor!.korisnik!.ime} ${e.doktor!.korisnik!.prezime}")),
                    DataCell(Text(e.odjel!.naziv.toString())),
                    DataCell(Text(formattedDate(e.datumTermina))),
                    DataCell(Text(formattedTime(e.vrijemeTermina!))),
                    DataCell(
                      ElevatedButton(
                          child: const Text("Otkaži termin"),
                          onPressed: () async {
                            showCustomDialog(
                                context: context,
                                title: "Otkazati termin?",
                                message:
                                    "Da li ste sigurni da želite otkazati termin?",
                                confirmText: "Da",
                                onConfirm: () async {
                                  var request = {
                                    "DatumTermina":
                                        e.datumTermina!.toIso8601String(),
                                    "VrijemeTermina":
                                        e.vrijemeTermina.toString(),
                                    "Otkazano": true
                                  };
                                  try {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (_) => const Center(
                                          child: CircularProgressIndicator()),
                                    );
                                    await terminProvider.update(
                                        e.terminId!, request);
                                    if (!mounted) return;
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    await Flushbar(
                                      message: "Uspješno otkazan termin",
                                      backgroundColor: Colors.green,
                                      duration: const Duration(seconds: 3),
                                    ).show(context);
                                    if (mounted) {
                                      fetchTermini();
                                      setState(() {});
                                    }
                                  } catch (error) {
                                    if (!mounted) return;
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    await Flushbar(
                                      message:
                                          "Došlo je do greške. Pokušajte ponovo.",
                                      backgroundColor: Colors.red,
                                      duration: const Duration(seconds: 3),
                                    ).show(context);
                                  }
                                });
                          }),
                    ),
                    DataCell(
                      buildActionButtons(e, () {
                        setState(() {
                          fetchTermini();
                        });
                      }),
                    ),
                  ]),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Future<void> kreirajUputnicu(BuildContext context, Termin termin) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Potvrda"),
          content: const Text("Da li ste sigurni da želite kreirati uputnicu?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Ne"),
            ),
            TextButton(
              onPressed: () async {
                var request = {
                  "TerminId": termin.terminId,
                  "Status": true,
                  "DatumKreiranja": DateTime.now().toIso8601String(),
                };

                try {
                  await uputnicaProvider.insert(request);
                  Navigator.of(context).pop();
                  await Flushbar(
                          message: "Uputnica uspješno kreirana",
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 3))
                      .show(context);
                  setState(() {});
                } catch (error) {
                  await Flushbar(
                          message: "Došlo je do greške. Pokušajte ponovo.",
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 3))
                      .show(context);
                }
              },
              child: const Text("Da"),
            ),
          ],
        );
      },
    );
  }

  Widget buildActionButtons(Termin termin, VoidCallback onActionCompleted) {
    return FutureBuilder<SearchResult<Uputnica?>>(
      future: uputnicaProvider.get(filter: {"TerminId": termin.terminId}),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.result.isEmpty) {
          return ElevatedButton(
            child: const Text("Kreiraj uputnicu"),
            onPressed: () {
              kreirajUputnicu(context, termin);
              onActionCompleted();
            },
          );
        }
        return uputnicaProvider.buildUputnicaButtons(
            context, snapshot.data!.result.first!.uputnicaId!);
      },
    );
  }
}
