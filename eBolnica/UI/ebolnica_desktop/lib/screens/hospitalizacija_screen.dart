import 'package:ebolnica_desktop/models/hospitalizacija_model.dart';
import 'package:ebolnica_desktop/models/search_result.dart';
import 'package:ebolnica_desktop/providers/doktor_provider.dart';
import 'package:ebolnica_desktop/providers/hospitalizacija_provider.dart';
import 'package:ebolnica_desktop/screens/nova_hospitalizacija_screen.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
import 'package:flutter/material.dart';

class HospitalizacijaScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  final String? nazivOdjela;

  const HospitalizacijaScreen(
      {super.key, required this.userId, this.userType, this.nazivOdjela});
  @override
  _HospitalizacijaScreenState createState() => _HospitalizacijaScreenState();
}

class _HospitalizacijaScreenState extends State<HospitalizacijaScreen> {
  late HospitalizacijaProvider hospitalizacijaProvider;
  late DoktorProvider doktorProvider;
  SearchResult<Hospitalizacija>? hospitalizacije;
  int? doktorId;

  @override
  void initState() {
    super.initState();
    doktorProvider = DoktorProvider();
    hospitalizacijaProvider = HospitalizacijaProvider();
    fetchDoktorId();
    fetchHospitalizacije();
  }

  Future<void> fetchHospitalizacije() async {
    hospitalizacije = await hospitalizacijaProvider.get();
    setState(() {});
  }

  Future<int?> fetchDoktorId() async {
    doktorId = await doktorProvider.getDoktorIdByKorisnikId(widget.userId);
    return doktorId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Lista hospitalizovanih pacijentata"),
          actions: [
            ElevatedButton.icon(
                onPressed: () => showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return NovaHospitalizacijaScreen(
                                  userId: widget.userId,
                                  userType: widget.userType,
                                  doktorId: doktorId,
                                  nazivOdjela: widget.nazivOdjela);
                            },
                            barrierDismissible: false)
                        .then((value) {
                      fetchHospitalizacije();
                    }),
                icon: const Icon(Icons.add),
                label: const Text("Kreiraj hospitalizaciju"))
          ],
        ),
        drawer: SideBar(
          userId: widget.userId,
          userType: widget.userType!,
        ),
        body: hospitalizacije == null || hospitalizacije!.count == 0
            ? buildEmptyView(
                context: context,
                screen: NovaHospitalizacijaScreen(
                  userId: widget.userId,
                  userType: widget.userType,
                  doktorId: doktorId,
                  nazivOdjela: widget.nazivOdjela,
                ),
                message: "Nema trenutno hospitalizovanih pacijenata")
            : _buildResultView());
  }

  Widget _buildResultView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          columns: const [
            DataColumn(label: Text("Pacijent")),
            DataColumn(label: Text("Doktor")),
            DataColumn(label: Text("Datum prijema")),
            DataColumn(label: Text("Odjel")),
            DataColumn(label: Text("Soba")),
            DataColumn(label: Text("Krevet")),
          ],
          rows: hospitalizacije?.result
                  .map<DataRow>(
                    (e) => DataRow(
                      cells: [
                        DataCell(Text(
                            "${e.pacijent!.korisnik!.ime} ${e.pacijent!.korisnik!.prezime}")),
                        DataCell(Text(
                            "${e.doktor!.korisnik!.ime} ${e.doktor!.korisnik!.prezime}")),
                        DataCell(Text(formattedDate(e.datumPrijema))),
                        DataCell(Text(e.odjel!.naziv.toString())),
                        DataCell(Text(e.soba!.naziv.toString())),
                        DataCell(Text(e.krevet!.krevetId.toString())),
                      ],
                    ),
                  )
                  .toList() ??
              [],
        ),
      ),
    );
  }
}
