import 'package:ebolnica_desktop/models/pregled_model.dart';
import 'package:ebolnica_desktop/models/terapija_model.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';
import 'package:ebolnica_desktop/providers/terapija_provider.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
import 'package:flutter/material.dart';

class PacijentPreglediScreen extends StatefulWidget {
  final int userId;
  const PacijentPreglediScreen({super.key, required this.userId});

  @override
  _PacijentPreglediScreenState createState() => _PacijentPreglediScreenState();
}

class _PacijentPreglediScreenState extends State<PacijentPreglediScreen> {
  late PacijentProvider pacijentProvider;
  late TerapijaProvider terapijaProvider;
  int? pacijentId;
  Terapija? terapija;
  List<Pregled>? pregledi = [];

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
    });
    pacijentId =
        await pacijentProvider.getPacijentIdByKorisnikId(widget.userId);
    if (pacijentId != null) {
      var result = await pacijentProvider.getPreglediByPacijentId(pacijentId!);
      setState(() {
        pregledi = result;
      });
    } else
      print("error");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pregledi"),
      ),
      drawer: SideBar(
        userType: 'pacijent',
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
              DataColumn(label: Text("Doktor")),
              DataColumn(label: Text("Odjel")),
              DataColumn(label: Text("Datum pregleda")),
              DataColumn(label: Text("Glavna dijagnoza")),
              DataColumn(label: Text("Anamneza")),
              DataColumn(label: Text("Zakljucak")),
              DataColumn(label: Text("Terapija")),
            ],
            rows: pregledi!
                .map<DataRow>(
                  (e) => DataRow(
                    cells: [
                      DataCell(Text(
                          "${e.uputnica!.termin!.doktor!.korisnik!.ime} ${e.uputnica!.termin!.doktor!.korisnik!.prezime}")),
                      DataCell(
                          Text(e.uputnica!.termin!.odjel!.naziv.toString())),
                      DataCell(Text(
                          formattedDate(e.uputnica!.termin!.datumTermina))),
                      DataCell(Text(e.glavnaDijagnoza.toString())),
                      DataCell(Text(e.anamneza.toString())),
                      DataCell(Text(e.zakljucak.toString())),
                      DataCell(
                        FutureBuilder<Terapija?>(
                          future: terapijaProvider
                              .getTerapijabyPregledId(e.pregledId!),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text(
                                  "Nije određena terapija nakon pregleda");
                            } else if (!snapshot.hasData ||
                                snapshot.data == null) {
                              return const Text("");
                            } else {
                              return Text(snapshot.data!.opis ?? "");
                            }
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
