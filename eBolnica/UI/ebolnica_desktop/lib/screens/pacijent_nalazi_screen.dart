import 'package:ebolnica_desktop/models/laboratorijski_nalaz_model.dart';
import 'package:ebolnica_desktop/providers/laboratorijski_nalaz_provider.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';
import 'package:ebolnica_desktop/screens/nalaz_details_screen.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
import 'package:flutter/material.dart';

class PacijentNalaziScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  const PacijentNalaziScreen({super.key, required this.userId, this.userType});

  @override
  _PacijentNalaziScreenState createState() => _PacijentNalaziScreenState();
}

class _PacijentNalaziScreenState extends State<PacijentNalaziScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista nalaza"),
      ),
      drawer: SideBar(
        userId: widget.userId,
        userType: widget.userType!,
      ),
      body: _buildResultView(),
    );
  }

  List<LaboratorijskiNalaz>? nalazi = [];
  late LaboratorijskiNalazProvider nalazProvider;
  late PacijentProvider pacijentProvider;
  int? pacijentId;
  @override
  void initState() {
    super.initState();
    nalazProvider = LaboratorijskiNalazProvider();
    pacijentProvider = PacijentProvider();
    fetchNalaz();
  }

  Future<void> fetchNalaz() async {
    nalazi = [];
    pacijentId =
        await pacijentProvider.getPacijentIdByKorisnikId(widget.userId);
    if (pacijentId != null) {
      var result = await pacijentProvider.GetNalaziByPacijentId(pacijentId!);
      setState(() {
        nalazi = result;
      });
    } else {
      print("error");
    }
  }

  Widget _buildResultView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
            columns: const [
              DataColumn(label: Text("Doktor")),
              DataColumn(label: Text("Datum nalaza")),
              DataColumn(label: Text("")),
            ],
            rows: nalazi!
                .map<DataRow>(
                  (e) => DataRow(
                    cells: [
                      DataCell(Text(
                          "${e.doktor!.korisnik!.ime} ${e.doktor!.korisnik!.prezime}")),
                      DataCell(Text(formattedDate(e.datumNalaza))),
                      DataCell(ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    NalazDetaljiScreen(laboratorijskiNalaz: e));
                          },
                          child: const Text("Prikazi nalaz"))),
                    ],
                  ),
                )
                .toList()),
      ),
    );
  }
}
