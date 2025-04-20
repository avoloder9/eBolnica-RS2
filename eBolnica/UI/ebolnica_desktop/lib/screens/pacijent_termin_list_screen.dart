import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/models/termin_model.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';
import 'package:ebolnica_desktop/providers/termin_provider.dart';
import 'package:ebolnica_desktop/screens/novi_termin_screen.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
import 'package:flutter/material.dart';

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

  Future<void> fetchTermini() async {
    setState(() {
      termini = [];
      _isLoading = true;
    });
    pacijentId =
        await pacijentProvider.getPacijentIdByKorisnikId(widget.userId);
    if (pacijentId != null) {
      var result =
          await terminProvider.get(filter: {"PacijentId": pacijentId!});
      setState(() {
        termini = result.result;
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
        actions: pacijentId == null
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
        userId: widget.userId,
        userType: widget.userType!,
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
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
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
            headingRowColor: MaterialStateProperty.all(
              Colors.blueGrey.shade50,
            ),
            headingTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
            columnSpacing: 24,
            dataRowHeight: 60,
            columns: const [
              DataColumn(label: Text("Ime i prezime doktora")),
              DataColumn(label: Text("Odjel")),
              DataColumn(label: Text("Datum termina")),
              DataColumn(label: Text("Vrijeme termina")),
              DataColumn(label: Text("")),
            ],
            rows: List.generate(termini!.length, (index) {
              final e = termini![index];
              final isEven = index % 2 == 0;

              return DataRow(
                color: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    return isEven ? Colors.grey[50] : null;
                  },
                ),
                cells: [
                  DataCell(Text(
                      "${e.doktor!.korisnik!.ime} ${e.doktor!.korisnik!.prezime}")),
                  DataCell(Text(e.odjel!.naziv.toString())),
                  DataCell(Text(formattedDate(e.datumTermina))),
                  DataCell(Text(formattedTime(e.vrijemeTermina!))),
                  DataCell(
                    ElevatedButton.icon(
                      icon: const Icon(Icons.cancel, size: 18),
                      label: const Text("Otkaži"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        showCustomDialog(
                          context: context,
                          title: "Otkazati termin?",
                          message:
                              "Da li ste sigurni da želite otkazati termin?",
                          confirmText: "Da",
                          onConfirm: () async {
                            var request = {
                              "DatumTermina": e.datumTermina!.toIso8601String(),
                              "VrijemeTermina": e.vrijemeTermina.toString(),
                              "Otkazano": true,
                            };
                            try {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => const Center(
                                    child: CircularProgressIndicator()),
                              );
                              await terminProvider.update(e.terminId!, request);
                              if (!context.mounted) return;
                              Navigator.of(context, rootNavigator: true).pop();
                              await Flushbar(
                                message: "Uspješno otkazan termin",
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 3),
                              ).show(context);
                              if (context.mounted) {
                                fetchTermini();
                                setState(() {});
                              }
                            } catch (error) {
                              if (!context.mounted) return;
                              Navigator.of(context, rootNavigator: true).pop();
                              await Flushbar(
                                message:
                                    "Došlo je do greške. Pokušajte ponovo.",
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 3),
                              ).show(context);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
