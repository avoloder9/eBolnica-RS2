import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/models/termin_model.dart';
import 'package:ebolnica_desktop/models/uputnica_model.dart';
import 'package:ebolnica_desktop/providers/medicinsko_osoblje_provider.dart';
import 'package:ebolnica_desktop/providers/odjel_provider.dart';
import 'package:ebolnica_desktop/providers/termin_provider.dart';
import 'package:ebolnica_desktop/providers/uputnica_provider.dart';
import 'package:ebolnica_desktop/screens/novi_termin_screen.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OdjelTerminiScreen extends StatefulWidget {
  final int userId;
  const OdjelTerminiScreen({super.key, required this.userId});
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

  String formattedDate(date) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  String formattedTime(Duration time) {
    final hours = time.inHours.toString().padLeft(2, '0');
    final minutes = (time.inMinutes % 60).toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  Future<void> fetchTermini() async {
    termini = [];
    osobljeId = await osobljeProvider.getOsobljeByKorisnikId(widget.userId);
    if (osobljeId != null) {
      odjelId =
          await osobljeProvider.getOdjelIdByMedicinskoOsoljeId(osobljeId!);
      if (odjelId != null) {
        var result = await odjelProvider.getTerminByOdjelId(odjelId!);
        setState(() {
          termini = result;
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
        userType: 'medicinsko osoblje',
        userId: widget.userId,
      ),
      body: Column(
        children: [_buildResultView()],
      ),
    );
  }

  Widget _buildResultView() {
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
                        onPressed: () {},
                      ),
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
    return FutureBuilder<Uputnica?>(
      future: terminProvider.getUputnicaByTerminId(termin.terminId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (!snapshot.hasData) {
          return ElevatedButton(
            child: const Text("Kreiraj uputnicu"),
            onPressed: () {
              kreirajUputnicu(context, termin);
              onActionCompleted();
            },
          );
        }
        return uputnicaProvider.buildUputnicaButtons(
            context, snapshot.data!.uputnicaId!);
      },
    );
  }
}
