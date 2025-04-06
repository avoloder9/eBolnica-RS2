import 'package:ebolnica_desktop/models/laboratorijski_nalaz_model.dart';
import 'package:ebolnica_desktop/providers/laboratorijski_nalaz_provider.dart';
import 'package:ebolnica_desktop/screens/nalaz_detalji_screen.dart';
import 'package:ebolnica_desktop/screens/novi_nalaz_screen.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
import 'package:flutter/material.dart';

class NalaziScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  const NalaziScreen({super.key, required this.userId, this.userType});

  @override
  _NalaziScreenState createState() => _NalaziScreenState();
}

class _NalaziScreenState extends State<NalaziScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista nalaza"),
        actions: [
          ElevatedButton.icon(
            onPressed: () async {
              bool? rezultat = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return NoviNalazScreen(
                    userId: widget.userId,
                    userType: widget.userType,
                  );
                },
                barrierDismissible: false,
              );
              if (rezultat == true) {
                fetchNalaz();
              }
            },
            icon: const Icon(Icons.add),
            label: const Text("Dodaj nalaz"),
          )
        ],
      ),
      drawer: SideBar(
        userId: widget.userId,
        userType: widget.userType!,
      ),
      body: nalazi == null || nalazi!.isEmpty
          ? buildEmptyView(
              context: context,
              screen: NoviNalazScreen(
                userId: widget.userId,
                userType: widget.userType,
              ),
              message: "Nema kreiranih nalaza")
          : _buildResultView(),
    );
  }

  List<LaboratorijskiNalaz>? nalazi = [];
  late LaboratorijskiNalazProvider nalazProvider;
  @override
  void initState() {
    super.initState();
    nalazProvider = LaboratorijskiNalazProvider();
    fetchNalaz();
  }

  Future<void> fetchNalaz() async {
    nalazi = [];
    var result = await nalazProvider.get();
    setState(() {
      nalazi = result.result;
    });
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
              DataColumn(label: Text("Datum nalaza")),
              DataColumn(label: Text("")),
            ],
            rows: nalazi!
                .map<DataRow>(
                  (e) => DataRow(
                    cells: [
                      DataCell(Text(
                          "${e.pacijent!.korisnik!.ime} ${e.pacijent!.korisnik!.prezime}")),
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
