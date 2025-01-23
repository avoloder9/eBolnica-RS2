import 'package:ebolnica_desktop/models/odjel_model.dart';
import 'package:ebolnica_desktop/models/search_result.dart';
import 'package:ebolnica_desktop/providers/odjel_provider.dart';
import 'package:ebolnica_desktop/screens/novi_odjel_screen.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:ebolnica_desktop/screens/soba_list_screen.dart';
import 'package:flutter/material.dart';

class OdjelListScreen extends StatefulWidget {
  const OdjelListScreen({super.key});
  @override
  State<OdjelListScreen> createState() => _OdjelListScreenState();
}

class _OdjelListScreenState extends State<OdjelListScreen> {
  late OdjelProvider provider;
  SearchResult<Odjel>? result;
  final TextEditingController _nazivEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    provider = OdjelProvider();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    result = await provider.get(filter: {});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista odjela"),
      ),
      drawer: const SideBar(userType: 'administrator'),
      body: Column(
        children: [
          _buildSearch(),
          _buildResultView(),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(9),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _nazivEditingController,
              decoration: const InputDecoration(labelText: "Naziv odjela"),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          ElevatedButton(
            onPressed: () async {
              var filter = <String, dynamic>{
                'nazivGTE': _nazivEditingController.text.isNotEmpty
                    ? _nazivEditingController.text
                    : null
              };
              result = await provider.get(filter: filter);
              setState(() {});
            },
            child: const Text("Pretraga"),
          ),
          const SizedBox(
            width: 8,
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return const NoviOdjelScreen();
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
              DataColumn(label: Text("Naziv")),
              DataColumn(label: SizedBox(width: 140, child: Text("Broj soba"))),
              DataColumn(
                  label: SizedBox(width: 150, child: Text("Broj kreveta"))),
              DataColumn(
                  label: SizedBox(
                      width: 160,
                      child: Center(child: Text("Broj slobodnih kreveta")))),
              DataColumn(label: Text("Glavni doktor")),
              DataColumn(label: Text("")),
              DataColumn(label: Text("")),
            ],
            rows: result?.result
                    .map<DataRow>(
                      (e) => DataRow(
                        cells: [
                          DataCell(Text(e.naziv.toString())),
                          DataCell(
                            SizedBox(
                              width: 50,
                              child: Center(child: Text(e.brojSoba.toString())),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 90,
                              child:
                                  Center(child: Text(e.brojKreveta.toString())),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 160,
                              child: Center(
                                child: Text(
                                  e.brojSlobodnihKreveta.toString(),
                                ),
                              ),
                            ),
                          ),
                          DataCell(Text(e.glavniDoktor?.korisnik?.ime ??
                              "Nije određen glavni doktor")),
                          DataCell(ElevatedButton(
                            child: const Text("Odredi glavnog doktora"),
                            onPressed: () {},
                          )),
                          DataCell(
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SobaListScreen(
                                              odjelId: e.odjelId!)));
                                },
                                child: const Text("Detalji")),
                          )
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
}
