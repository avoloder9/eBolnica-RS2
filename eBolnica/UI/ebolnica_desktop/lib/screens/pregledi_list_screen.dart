import 'package:ebolnica_desktop/models/pregled_model.dart';
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
  List<Pregled>? pregledi = [];
  @override
  void initState() {
    super.initState();
    pregledProvider = PregledProvider();
    terapijaProvider = TerapijaProvider();

    fetchPregledi();
  }

  Future<void> fetchPregledi() async {
    pregledi = [];

    var result = await pregledProvider.get();
    setState(() {
      pregledi = result.result;
    });
    if (pregledi == null) {
      print("Nema pregleda za ovog ");
    }
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
            DataColumn(label: Text("Datum pregleda")),
            DataColumn(label: Text("Glavna dijagnoza")),
            DataColumn(label: Text("Anamneza")),
            DataColumn(label: Text("Zakljucak")),
            DataColumn(label: Text("")),
          ],
          rows: pregledi!
              .map<DataRow>(
                (e) => DataRow(
                  cells: [
                    DataCell(Text(
                        "${e.uputnica!.termin!.pacijent!.korisnik!.ime} ${e.uputnica!.termin!.pacijent!.korisnik!.prezime} ")),
                    DataCell(Text(
                        formattedDate((e.uputnica!.termin!.datumTermina)))),
                    DataCell(Text(e.glavnaDijagnoza.toString())),
                    DataCell(Text(e.anamneza.toString())),
                    DataCell(Text(e.zakljucak.toString())),
                    DataCell(ElevatedButton(
                      child: const Text("Detalji"),
                      onPressed: () {
                        showPregledDetailsDialog(context, e);
                      },
                    ))
                  ],
                ),
              )
              .toList(),
        ),
      ),
    ));
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
                  ? MediaQuery.of(context).size.height * 0.57
                  : MediaQuery.of(context).size.height * 0.35;

              return Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: dialogHeight,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Detalji pregleda",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow("Pacijent:",
                                "${pregled.uputnica!.termin!.pacijent!.korisnik!.ime} ${pregled.uputnica!.termin!.pacijent!.korisnik!.prezime}"),
                            _buildDetailRow(
                                "Datum pregleda:",
                                formattedDate(
                                    pregled.uputnica!.termin!.datumTermina)),
                            _buildDetailRow("Glavna dijagnoza:",
                                pregled.glavnaDijagnoza.toString()),
                            _buildDetailRow(
                                "Anamneza:", pregled.anamneza.toString()),
                            _buildDetailRow(
                                "Zaključak:", pregled.zakljucak.toString()),
                            if (hasTerapija) ...[
                              const SizedBox(height: 20),
                              const Text(
                                "Terapija",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const Divider(),
                              _buildDetailRow("Naziv terapije:",
                                  snapshot.data!.naziv.toString()),
                              _buildDetailRow(
                                  "Opis:", snapshot.data!.opis.toString()),
                              _buildDetailRow("Datum početka:",
                                  formattedDate(snapshot.data!.datumPocetka)),
                              _buildDetailRow("Datum završetka:",
                                  formattedDate(snapshot.data!.datumZavrsetka)),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Zatvori",
                            style: TextStyle(fontSize: 18)),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
