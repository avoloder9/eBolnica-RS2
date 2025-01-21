import 'dart:async';
import 'package:ebolnica_desktop/models/pacijent_model.dart';
import 'package:ebolnica_desktop/models/search_result.dart';
import 'package:ebolnica_desktop/screens/edit_pacijent_screen.dart';
import 'package:ebolnica_desktop/screens/novi_pacijent_screen.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:flutter/material.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';
import 'package:intl/intl.dart';

class PacijentListScreen extends StatefulWidget {
  const PacijentListScreen({super.key});

  @override
  State<PacijentListScreen> createState() => _PacijentListScreenState();
}

class _PacijentListScreenState extends State<PacijentListScreen> {
  late PacijentProvider provider;
  int pageSize = 15;
  int page = 0;

  final TextEditingController _imeEditingController = TextEditingController();
  final TextEditingController _prezimeEditingController =
      TextEditingController();
  final TextEditingController _brojKarticeController = TextEditingController();

  SearchResult<Pacijent>? result;

  @override
  void initState() {
    super.initState();
    provider = PacijentProvider();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    result = await provider.get(filter: {}, page: page, pageSize: pageSize);
    setState(() {});
  }

  String formattedDate(date) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista pacijenata"),
      ),
      drawer: const SideBar(userType: 'administrator'),
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
              controller: _imeEditingController,
              decoration: const InputDecoration(labelText: "Ime"),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _prezimeEditingController,
              decoration: const InputDecoration(labelText: "Prezime"),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: TextField(
              controller: _brojKarticeController,
              decoration:
                  const InputDecoration(labelText: "Broj zdravstvene kartice"),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              var filter = <String, dynamic>{
                'imeGTE': _imeEditingController.text.isNotEmpty
                    ? _imeEditingController.text
                    : null,
                'prezimeGTE': _prezimeEditingController.text.isNotEmpty
                    ? _prezimeEditingController.text
                    : null,
                'brojZdravstveneKartice': _brojKarticeController.text.isNotEmpty
                    ? int.tryParse(_brojKarticeController.text)
                    : null,
              };

              result = await provider.get(
                  filter: filter, page: page, pageSize: pageSize);
              setState(() {});
            },
            child: const Text("Pretraga"),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return const NoviPacijentScreen();
                },
              );
            },
            child: const Text("Dodaj"),
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
              DataColumn(
                  label: SizedBox(
                      width: 160,
                      child: Center(child: Text("Broj zdravstvene kartice")))),
              DataColumn(label: Text("Telefon")),
              DataColumn(label: SizedBox(width: 60, child: Text("Adresa"))),
              DataColumn(
                  label: SizedBox(width: 100, child: Text("Datum rodjenja"))),
              DataColumn(label: Text("Spol")),
              DataColumn(label: Text("Status")),
              DataColumn(label: Text("")),
            ],
            rows: result?.result
                    .map<DataRow>(
                      (e) => DataRow(
                        cells: [
                          DataCell(Text(e.korisnik!.ime)),
                          DataCell(Text(e.korisnik!.prezime)),
                          DataCell(Text(e.korisnik!.email)),
                          DataCell(SizedBox(
                              width: 160,
                              child: Center(
                                  child: Text(
                                      e.brojZdravstveneKartice.toString())))),
                          DataCell(Text(e.korisnik!.telefon ?? "-")),
                          DataCell(Text(e.adresa ?? "-")),
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
                          DataCell(Text(e.korisnik!.status == true
                              ? "Aktivan"
                              : "Neaktivan")),
                          DataCell(ElevatedButton(
                            child: const Text("Ažuriraj podatke"),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => EditPacijentScreen(
                                  pacijentId: e.pacijentId!,
                                  onSave: () {
                                    _loadInitialData();
                                  },
                                ),
                              );
                            },
                          ))
                        ],
                      ),
                    )
                    .toList() ??
                [],
          ),
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
                  setState(() {});
                }
              : null,
        ),
        Text("Strana ${page + 1}"),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: result != null && result!.result.length == pageSize
              ? () async {
                  page++;
                  result = await provider
                      .get(filter: {}, page: page, pageSize: pageSize);
                  setState(() {});
                }
              : null,
        ),
      ],
    );
  }
}
