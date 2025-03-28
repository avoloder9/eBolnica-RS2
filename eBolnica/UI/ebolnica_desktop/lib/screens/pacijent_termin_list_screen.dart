import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/models/termin_model.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';
import 'package:ebolnica_desktop/providers/termin_provider.dart';
import 'package:ebolnica_desktop/screens/novi_termin_screen.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TerminiScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  const TerminiScreen({super.key, required this.userId, this.userType});
  @override
  _TerminiScreenState createState() => _TerminiScreenState();
}

class _TerminiScreenState extends State<TerminiScreen> {
  int? pacijentId;
  late PacijentProvider pacijentProvider;
  late TerminProvider terminProvider;
  List<Termin>? termini = [];
  bool _isLoading = true;
  bool _dataFetched = false;

  @override
  void initState() {
    super.initState();
    pacijentProvider = PacijentProvider();
    terminProvider = TerminProvider();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
    setState(() {
      termini = [];
      _isLoading = true;
    });
    pacijentId =
        await pacijentProvider.getPacijentIdByKorisnikId(widget.userId);
    if (pacijentId != null) {
      var result = await pacijentProvider.getTerminByPacijentId(pacijentId!);
      setState(() {
        termini = result;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_dataFetched) {
      _dataFetched = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchTermini();
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Termini"),
        actions: widget.userType == "pacijent"
            ? null
            : [
                ElevatedButton.icon(
                  onPressed: pacijentId == null
                      ? null
                      : () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return NoviTerminScreen(
                                  pacijentId: pacijentId!,
                                  userId: widget.userId,
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
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (termini == null || termini!.isEmpty) {
      return const Expanded(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Nema dostupnih termina",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
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
              DataColumn(label: Text("Ime i prezime doktora")),
              DataColumn(label: Text("Odjel")),
              DataColumn(label: Text("Datum termina")),
              DataColumn(label: Text("Vrijeme termina")),
              DataColumn(label: Text(" ")),
            ],
            rows: termini!
                .map<DataRow>(
                  (e) => DataRow(
                    cells: [
                      DataCell(Text(
                          "${e.doktor!.korisnik!.ime} ${e.doktor!.korisnik!.prezime}")),
                      DataCell(Text(e.odjel!.naziv.toString())),
                      DataCell(Text(formattedDate(e.datumTermina))),
                      DataCell(Text(formattedTime(e.vrijemeTermina!))),
                      DataCell(
                        ElevatedButton(
                          child: const Text("Otkaži termin"),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  backgroundColor:
                                      Colors.white.withOpacity(0.9),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: ConstrainedBox(
                                      constraints:
                                          const BoxConstraints(maxWidth: 400),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 60,
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          const Text(
                                            "Otkazati termin?",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 8),
                                          const Text(
                                            "Da li ste sigurni da želite otkazati termin?",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16),
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20,
                                                      vertical: 12),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                ),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text("Odustani"),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green,
                                                    foregroundColor:
                                                        Colors.white,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 20,
                                                      vertical: 12,
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    )),
                                                onPressed: () async {
                                                  var request = {
                                                    "DatumTermina": e
                                                        .datumTermina!
                                                        .toIso8601String(),
                                                    "VrijemeTermina": e
                                                        .vrijemeTermina
                                                        .toString(),
                                                    "Otkazano": true
                                                  };
                                                  try {
                                                    await terminProvider.update(
                                                        e.terminId!, request);
                                                    Navigator.of(context).pop();
                                                    await Flushbar(
                                                      message:
                                                          "Uspješno otkazan termin",
                                                      backgroundColor:
                                                          Colors.green,
                                                      duration: const Duration(
                                                          seconds: 3),
                                                    ).show(context);
                                                    fetchTermini();
                                                  } catch (error) {
                                                    await Flushbar(
                                                      message:
                                                          "Došlo je do greške. Pokušajte ponovo.",
                                                      backgroundColor:
                                                          Colors.red,
                                                      duration: const Duration(
                                                          seconds: 3),
                                                    ).show(context);
                                                  }
                                                },
                                                child: const Text("Da"),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
