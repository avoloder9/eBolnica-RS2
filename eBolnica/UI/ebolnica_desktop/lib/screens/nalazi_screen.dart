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
          columnSpacing: 32,
          dataRowHeight: 55,
          headingRowColor: MaterialStateProperty.all(Colors.blue.shade50),
          headingTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
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
                      "${e.pacijent!.korisnik!.ime} ${e.pacijent!.korisnik!.prezime}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15),
                    )),
                    DataCell(Text(
                      "${e.doktor!.korisnik!.ime} ${e.doktor!.korisnik!.prezime}",
                      style: const TextStyle(fontSize: 15),
                    )),
                    DataCell(Text(
                      formattedDate(e.datumNalaza),
                      style: const TextStyle(color: Colors.black87),
                    )),
                    DataCell(
                      ElevatedButton.icon(
                        icon: const Icon(Icons.description_outlined, size: 18),
                        label: const Text("Prikaži"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                NalazDetaljiScreen(laboratorijskiNalaz: e),
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
    );
  }
}
