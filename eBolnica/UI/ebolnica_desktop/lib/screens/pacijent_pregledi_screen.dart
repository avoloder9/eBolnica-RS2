import 'package:ebolnica_desktop/models/Response/pregledi_response.dart';
import 'package:ebolnica_desktop/models/terapija_model.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';
import 'package:ebolnica_desktop/providers/terapija_provider.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
import 'package:flutter/material.dart';

class PacijentPreglediScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  const PacijentPreglediScreen(
      {super.key, required this.userId, this.userType});

  @override
  _PacijentPreglediScreenState createState() => _PacijentPreglediScreenState();
}

class _PacijentPreglediScreenState extends State<PacijentPreglediScreen> {
  late PacijentProvider pacijentProvider;
  late TerapijaProvider terapijaProvider;
  int? pacijentId;
  Terapija? terapija;
  List<PreglediResponse>? pregledi = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    pacijentProvider = PacijentProvider();
    terapijaProvider = TerapijaProvider();
    fetchPregledi();
  }

  Future<void> fetchTerapija(int pregledId) async {
    var result = await terapijaProvider.getTerapijabyPregledId(pregledId);
    setState(() {
      terapija = result;
    });
  }

  Future<void> fetchPregledi() async {
    setState(() {
      pregledi = [];
      _isLoading = true;
    });
    pacijentId =
        await pacijentProvider.getPacijentIdByKorisnikId(widget.userId);
    if (pacijentId != null) {
      var result = await pacijentProvider.getPreglediByPacijentId(pacijentId!);
      setState(() {
        pregledi = result;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pregledi"),
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

    if (pregledi == null || pregledi!.isEmpty) {
      return const Expanded(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Nema obavljenih pregleda",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
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
            dataRowColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.blue.withOpacity(0.2);
                }
                return null;
              },
            ),
            dataTextStyle: const TextStyle(
              fontSize: 14,
            ),
            columnSpacing: 24,
            columns: const [
              DataColumn(label: Text("Doktor")),
              DataColumn(label: Text("Odjel")),
              DataColumn(label: Text("Datum pregleda")),
              DataColumn(label: Text("Glavna dijagnoza")),
              DataColumn(label: Text("Anamneza")),
              DataColumn(label: Text("Zaključak")),
              DataColumn(label: Text("Terapija")),
              DataColumn(label: Text("")),
            ],
            rows: pregledi!.map<DataRow>(
              (e) {
                return DataRow(
                  cells: [
                    DataCell(Text("${e.imeDoktora} ${e.prezimeDoktora}")),
                    DataCell(Text(e.nazivOdjela)),
                    DataCell(Text(formattedDate(e.datumTermina))),
                    DataCell(
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 150),
                        child: Text(
                          e.glavnaDijagnoza,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 150),
                        child: Text(
                          e.anamneza,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 150),
                        child: Text(
                          e.zakljucak,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 150),
                        child: FutureBuilder<Terapija?>(
                          future: terapijaProvider
                              .getTerapijabyPregledId(e.pregledId),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text(
                                "Nije određena terapija nakon pregleda",
                                style: TextStyle(color: Colors.red),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data == null) {
                              return const Text("—");
                            } else {
                              return Text(
                                snapshot.data!.opis ?? "",
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    DataCell(ElevatedButton(
                      child: const Text("Detalji"),
                      onPressed: () {
                        showPregledDetailsDialog(context, e);
                      },
                    ))
                  ],
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }

  void showPregledDetailsDialog(
      BuildContext context, PreglediResponse pregled) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: FutureBuilder<Terapija?>(
            future: terapijaProvider.getTerapijabyPregledId(pregled.pregledId),
            builder: (context, snapshot) {
              bool hasTerapija = snapshot.hasData && snapshot.data != null;
              double dialogHeight = hasTerapija
                  ? MediaQuery.of(context).size.height * 0.50
                  : MediaQuery.of(context).size.height * 0.3;

              return Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: dialogHeight,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "🩺 Detalji pregleda",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildDetailRowWithIcon(
                              icon: Icons.person,
                              label: "Doktor:",
                              value:
                                  "${pregled.imeDoktora} ${pregled.prezimeDoktora}",
                            ),
                            buildDetailRowWithIcon(
                              icon: Icons.calendar_today,
                              label: "Datum pregleda:",
                              value: formattedDate(pregled.datumTermina),
                            ),
                            buildDetailRowWithIcon(
                              icon: Icons.assignment,
                              label: "Glavna dijagnoza:",
                              value: pregled.glavnaDijagnoza,
                            ),
                            buildDetailRowWithIcon(
                              icon: Icons.notes,
                              label: "Anamneza:",
                              value: pregled.anamneza,
                            ),
                            buildDetailRowWithIcon(
                              icon: Icons.check_circle_outline,
                              label: "Zaključak:",
                              value: pregled.zakljucak,
                            ),
                            if (hasTerapija) ...[
                              const SizedBox(height: 10),
                              const Divider(),
                              const Row(
                                children: [
                                  Icon(Icons.medical_services,
                                      size: 22, color: Colors.blueGrey),
                                  SizedBox(width: 8),
                                  Text(
                                    "Terapija",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              buildDetailRowWithIcon(
                                icon: Icons.label,
                                label: "Naziv terapije:",
                                value: snapshot.data!.naziv!,
                              ),
                              buildDetailRowWithIcon(
                                icon: Icons.description,
                                label: "Opis:",
                                value: snapshot.data!.opis ?? "N/A",
                              ),
                              buildDetailRowWithIcon(
                                icon: Icons.calendar_today,
                                label: "Datum početka:",
                                value:
                                    formattedDate(snapshot.data!.datumPocetka),
                              ),
                              buildDetailRowWithIcon(
                                icon: Icons.event_available,
                                label: "Datum završetka:",
                                value: formattedDate(
                                    snapshot.data!.datumZavrsetka),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                        ),
                        child: const Text(
                          "Zatvori",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
