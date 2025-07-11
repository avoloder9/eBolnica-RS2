import 'package:ebolnica_desktop/models/pregled_model.dart';
import 'package:ebolnica_desktop/models/search_result.dart';
import 'package:ebolnica_desktop/models/terapija_model.dart';
import 'package:ebolnica_desktop/providers/pregled_provider.dart';
import 'package:ebolnica_desktop/providers/terapija_provider.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
import 'package:flutter/material.dart';

class PreglediListScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  const PreglediListScreen({super.key, required this.userId, this.userType});

  @override
  _PreglediListScreenState createState() => _PreglediListScreenState();
}

class _PreglediListScreenState extends State<PreglediListScreen> {
  late TerapijaProvider terapijaProvider;
  late PregledProvider pregledProvider;
  int pageSize = 15;
  int page = 0;
  SearchResult<Pregled>? pregledi;
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    pregledProvider = PregledProvider();
    terapijaProvider = TerapijaProvider();
    fetchPregledi();
  }

  Future<void> fetchPregledi() async {
    pregledi = null;
    var result = await pregledProvider.get(page: page, pageSize: pageSize);
    setState(() {
      pregledi = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historija obavljenih pregleda"),
      ),
      drawer: SideBar(
        userId: widget.userId,
        userType: widget.userType!,
      ),
      body: Column(
        children: [_buildResultView(), _buildPaginationControls()],
      ),
    );
  }

  Widget _buildResultView() {
    return Expanded(
      child: Scrollbar(
        trackVisibility: true,
        controller: _horizontalController,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _horizontalController,
            child: Scrollbar(
                thumbVisibility: true,
                controller: _verticalController,
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    controller: _verticalController,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width,
                      ),
                      child: DataTable(
                          headingRowHeight: 56,
                          columnSpacing: 24,
                          horizontalMargin: 16,
                          columns: const [
                            DataColumn(
                                label: Text("Pacijent",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("Datum pregleda",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("Glavna dijagnoza",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("Anamneza",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("Zakljucak",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("")),
                          ],
                          rows: pregledi?.result
                                  .map<DataRow>(
                                    (e) => DataRow(
                                      cells: [
                                        DataCell(Text(
                                            "${e.uputnica!.termin!.pacijent!.korisnik!.ime} ${e.uputnica!.termin!.pacijent!.korisnik!.prezime}",
                                            style:
                                                const TextStyle(fontSize: 14))),
                                        DataCell(Text(
                                            formattedDate(e.uputnica!.termin!
                                                .datumTermina),
                                            style:
                                                const TextStyle(fontSize: 14))),
                                        DataCell(Text(
                                            e.glavnaDijagnoza.toString(),
                                            style:
                                                const TextStyle(fontSize: 14))),
                                        DataCell(Text(e.anamneza.toString(),
                                            style:
                                                const TextStyle(fontSize: 14))),
                                        DataCell(Text(e.zakljucak.toString(),
                                            style:
                                                const TextStyle(fontSize: 14))),
                                        DataCell(
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.blue,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: const Text(
                                              "Detalji",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            onPressed: () {
                                              showPregledDetailsDialog(
                                                  context, e);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList() ??
                              []),
                    )))),
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: page > 0
              ? () async {
                  page--;
                  pregledi = await pregledProvider
                      .get(filter: {}, page: page, pageSize: pageSize);
                  setState(() {});
                }
              : null,
        ),
        Text("Strana ${page + 1}"),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: pregledi != null && pregledi!.result.length == pageSize
              ? () async {
                  page++;
                  pregledi = await pregledProvider
                      .get(filter: {}, page: page, pageSize: pageSize);
                  setState(() {});
                }
              : null,
        ),
      ],
    );
  }

  void showPregledDetailsDialog(BuildContext context, Pregled pregled) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: FutureBuilder<Terapija?>(
            future: terapijaProvider.getTerapijabyPregledId(pregled.pregledId!),
            builder: (context, snapshot) {
              bool hasTerapija = snapshot.hasData && snapshot.data != null;
              double dialogHeight = hasTerapija
                  ? MediaQuery.of(context).size.height * 0.52
                  : MediaQuery.of(context).size.height * 0.33;

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
                            if (widget.userType == "administrator")
                              buildDetailRowWithIcon(
                                icon: Icons.person,
                                label: "Doktor:",
                                value:
                                    "${pregled.uputnica!.termin!.doktor!.korisnik!.ime} ${pregled.uputnica!.termin!.doktor!.korisnik!.prezime}",
                              ),
                            buildDetailRowWithIcon(
                              icon: Icons.person,
                              label: "Pacijent:",
                              value:
                                  "${pregled.uputnica!.termin!.pacijent!.korisnik!.ime} ${pregled.uputnica!.termin!.pacijent!.korisnik!.prezime}",
                            ),
                            buildDetailRowWithIcon(
                              icon: Icons.calendar_today,
                              label: "Datum pregleda:",
                              value: formattedDate(
                                  pregled.uputnica!.termin!.datumTermina),
                            ),
                            buildDetailRowWithIcon(
                              icon: Icons.assignment,
                              label: "Glavna dijagnoza:",
                              value: pregled.glavnaDijagnoza ?? "N/A",
                            ),
                            buildDetailRowWithIcon(
                              icon: Icons.notes,
                              label: "Anamneza:",
                              value: pregled.anamneza ?? "N/A",
                            ),
                            buildDetailRowWithIcon(
                              icon: Icons.check_circle_outline,
                              label: "Zaključak:",
                              value: pregled.zakljucak ?? "N/A",
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
