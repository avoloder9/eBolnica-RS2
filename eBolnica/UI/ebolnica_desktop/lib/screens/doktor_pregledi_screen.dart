import 'package:ebolnica_desktop/models/pregled_model.dart';
import 'package:ebolnica_desktop/providers/doktor_provider.dart';
import 'package:ebolnica_desktop/providers/pregled_provider.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
import 'package:flutter/material.dart';

class DoktorPreglediScreen extends StatefulWidget {
  final int userId;
  final String? nazivOdjela;
  const DoktorPreglediScreen(
      {super.key, required this.userId, this.nazivOdjela});

  @override
  _DoktorPreglediScreenState createState() => _DoktorPreglediScreenState();
}

class _DoktorPreglediScreenState extends State<DoktorPreglediScreen> {
  late PregledProvider pregledProvider;
  late DoktorProvider doktorProvider;

  int? doktorId;
  List<Pregled>? pregledi = [];

  @override
  void initState() {
    super.initState();
    pregledProvider = PregledProvider();
    doktorProvider = DoktorProvider();
    fetchPregledi();
  }

  Future<void> fetchPregledi() async {
    pregledi = [];
    doktorId = await doktorProvider.getDoktorIdByKorisnikId(widget.userId);
    if (doktorId != null) {
      var result = await doktorProvider.getPreglediByDoktorId(doktorId!);
      setState(() {
        pregledi = result;
      });
      if (pregledi == null) {
        print("Nema pregleda za ovog doktora");
      }
    } else {
      print("Nije pronadjen doktor");
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
        userType: "doktor",
        nazivOdjela: widget.nazivOdjela,
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
                      onPressed: () {},
                    ))
                  ],
                ),
              )
              .toList(),
        ),
      ),
    ));
  }
}
