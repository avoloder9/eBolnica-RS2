import 'package:ebolnica_desktop/models/doktor_model.dart';
import 'package:ebolnica_desktop/models/search_result.dart';
import 'package:ebolnica_desktop/providers/doktor_provider.dart';
import 'package:ebolnica_desktop/screens/novi_doktor_screen.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoktorListScreen extends StatefulWidget {
  const DoktorListScreen({super.key});
  @override
  State<DoktorListScreen> createState() => _DoktorListScreenState();
}

class _DoktorListScreenState extends State<DoktorListScreen> {
  late DoktorProvider provider;
  int pageSize = 15;
  int page = 0;
  final TextEditingController _imeEditingController = TextEditingController();
  final TextEditingController _prezimeEditingController =
      TextEditingController();

  SearchResult<Doktor>? result;

  @override
  void initState() {
    super.initState();
    provider = DoktorProvider();
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
        title: const Text("Lista doktora"),
      ),
      drawer: const SideBar(userType: 'administrator'),
      body: Column(
        children: [
          _buildSearch(),
          _buildResultView(),
          _buildPaginationControls()
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
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _prezimeEditingController,
              decoration: const InputDecoration(labelText: "Prezime"),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () async {
              var filter = <String, dynamic>{
                'imeGTE': _imeEditingController.text.isNotEmpty
                    ? _imeEditingController.text
                    : null,
                'prezimeGTE': _prezimeEditingController.text.isNotEmpty
                    ? _prezimeEditingController.text
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
                  return const NoviDoktorScreen();
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
          columns: const <DataColumn>[
            DataColumn(label: Text("Ime")),
            DataColumn(label: Text("Prezime")),
            DataColumn(label: Text("Email")),
            DataColumn(label: Text("Telefon")),
            DataColumn(label: Text("Datum rodjenja")),
            DataColumn(label: Text("Status")),
            DataColumn(label: Text("Odjel")),
            DataColumn(label: Text("Specijalizacija")),
          ],
          rows: result?.result
                  .map<DataRow>((e) => DataRow(cells: <DataCell>[
                        DataCell(Text(e.korisnik!.ime)),
                        DataCell(Text(e.korisnik!.prezime)),
                        DataCell(Text(e.korisnik!.email)),
                        DataCell(Text(e.korisnik!.telefon ?? "-")),
                        DataCell(
                            Text(formattedDate(e.korisnik!.datumRodjenja))),
                        DataCell(Text(e.korisnik!.status == true
                            ? "Aktivan"
                            : "Neaktivan")),
                        DataCell(Text(e.odjel!.naziv ?? "-")),
                        DataCell(Text(e.specijalizacija ?? "-")),
                      ]))
                  .toList() ??
              [],
        ),
      ),
    ));
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
