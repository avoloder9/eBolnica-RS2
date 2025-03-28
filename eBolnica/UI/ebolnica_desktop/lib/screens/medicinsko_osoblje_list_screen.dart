import 'package:ebolnica_desktop/models/medicinsko_osoblje_model.dart';
import 'package:ebolnica_desktop/models/search_result.dart';
import 'package:ebolnica_desktop/providers/medicinsko_osoblje_provider.dart';
import 'package:ebolnica_desktop/screens/edit_medicinsko_osoblje_screen.dart';
import 'package:ebolnica_desktop/screens/novi_medicinsko_osoblje_screen.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicinskoOsobljeListScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  const MedicinskoOsobljeListScreen(
      {super.key, required this.userId, this.userType});
  @override
  State<MedicinskoOsobljeListScreen> createState() =>
      _MedicinskoOsobljeListScreenState();
}

class _MedicinskoOsobljeListScreenState
    extends State<MedicinskoOsobljeListScreen> {
  late MedicinskoOsobljeProvider provider;
  SearchResult<MedicinskoOsoblje>? result;
  List<MedicinskoOsoblje> osoblje = [];
  List<MedicinskoOsoblje> filteredOsoblje = [];

  int pageSize = 15;
  int page = 0;
  @override
  void initState() {
    super.initState();
    provider = MedicinskoOsobljeProvider();
    fetchOsoblje();
  }

  String formattedDate(date) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  Future<void> fetchOsoblje() async {
    result = await provider.get(filter: {}, page: page, pageSize: pageSize);
    setState(() {
      osoblje = result!.result;
      filteredOsoblje = result!.result;
    });
  }

  void filterOsoblje(String query) async {
    final results = osoblje.where((osoblje) {
      final ime = osoblje.korisnik?.ime!.toLowerCase();
      final prezime = osoblje.korisnik?.prezime!.toLowerCase();

      final matchesSearchQuery =
          ('$ime $prezime'.contains(query.toLowerCase()) ||
              '$prezime $ime'.contains(query.toLowerCase()));

      return matchesSearchQuery;
    }).toList();
    setState(() {
      filteredOsoblje = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medicinsko osoblje"),
      ),
      drawer: SideBar(
        userType: widget.userType!,
        userId: widget.userId,
      ),
      body: Column(
        children: [
          _buildSearch(),
          _buildResultView(),
          _buildPaginationControls(),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) => filterOsoblje(value),
              decoration: const InputDecoration(labelText: "Pretraga"),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return NoviMedicinskoOsobljeScreen(
                      userId: widget.userId, userType: widget.userType);
                },
              );
            },
            child: const Text("Dodaj novo osoblje"),
          ),
        ],
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
                DataColumn(label: Text("Ime")),
                DataColumn(label: Text("Prezime")),
                DataColumn(label: Text("E-mail")),
                DataColumn(label: Text("Telefon")),
                DataColumn(
                    label: SizedBox(width: 100, child: Text("Datum rodjenja"))),
                DataColumn(label: Text("Spol")),
                DataColumn(label: Text("Odjel")),
                DataColumn(label: Text("Status")),
                DataColumn(label: Text("")),
              ],
              rows: filteredOsoblje
                  .map<DataRow>(
                    (e) => DataRow(
                      cells: [
                        DataCell(Text(e.korisnik!.ime!)),
                        DataCell(Text(e.korisnik!.prezime!)),
                        DataCell(Text(e.korisnik!.email!)),
                        DataCell(Text(e.korisnik!.telefon ?? "-")),
                        DataCell(
                          SizedBox(
                            width: 100,
                            child: Center(
                              child: Text(
                                formattedDate(e.korisnik!.datumRodjenja),
                              ),
                            ),
                          ),
                        ),
                        DataCell(Text(e.korisnik!.spol ?? "-")),
                        DataCell(Text(e.odjel?.naziv ?? "-")),
                        DataCell(Text(e.korisnik!.status == true
                            ? "Aktivan"
                            : "Neaktivan")),
                        DataCell(
                          ElevatedButton(
                            child: const Text("Ažuriraj podatke"),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    EditMedicinskoOsobljeScreen(
                                  medicinskoOsobljeId: e.medicinskoOsobljeId!,
                                  onSave: () {
                                    fetchOsoblje();
                                  },
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  )
                  .toList()),
        ),
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
                  result = await provider
                      .get(filter: {}, page: page, pageSize: pageSize);
                  setState(() {
                    osoblje = result!.result;
                    filteredOsoblje = result!.result;
                  });
                }
              : null,
        ),
        Text("Strana ${page + 1}"),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: result != null && result!.result.length == pageSize
              ? () async {
                  page++;
                  await fetchOsoblje();
                  setState(() {});
                }
              : null,
        ),
      ],
    );
  }
}
