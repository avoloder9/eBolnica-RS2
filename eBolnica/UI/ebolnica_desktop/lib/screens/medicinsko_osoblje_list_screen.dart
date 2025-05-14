import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/models/medicinsko_osoblje_model.dart';
import 'package:ebolnica_desktop/models/search_result.dart';
import 'package:ebolnica_desktop/providers/medicinsko_osoblje_provider.dart';
import 'package:ebolnica_desktop/screens/edit_medicinsko_osoblje_screen.dart';
import 'package:ebolnica_desktop/screens/novi_medicinsko_osoblje_screen.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
import 'package:flutter/material.dart';

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
  List<String> odjeli = [];
  String? selectedOdjel = '';
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();
  int pageSize = 15;
  int page = 0;
  final TextEditingController _imeEditingController = TextEditingController();
  final TextEditingController _prezimeEditingController =
      TextEditingController();
  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    provider = MedicinskoOsobljeProvider();
    fetchOsoblje();
  }

  Future<void> fetchOsoblje({bool useFilters = false}) async {
    var filter = <String, dynamic>{};

    if (useFilters) {
      if (_imeEditingController.text.isNotEmpty) {
        filter['imeGTE'] = _imeEditingController.text;
      }
      if (_prezimeEditingController.text.isNotEmpty) {
        filter['prezimeGTE'] = _prezimeEditingController.text;
      }
    }
    result = await provider.get(
      filter: filter,
      page: page,
      pageSize: pageSize,
    );
    setState(() {});
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
              controller: _imeEditingController,
              decoration: const InputDecoration(labelText: "Ime"),
              onChanged: (value) async {
                await fetchOsoblje(useFilters: true);
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _prezimeEditingController,
              decoration: const InputDecoration(labelText: "Prezime"),
              onChanged: (value) async {
                await fetchOsoblje(useFilters: true);
              },
            ),
          ),
          const SizedBox(width: 20),
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
            child: const Text(
              "Dodaj novo osoblje",
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultView() {
    return Expanded(
      child: Scrollbar(
          trackVisibility: true,
          controller: _horizontalController,
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _horizontalController,
              child: Scrollbar(
                  thumbVisibility: true,
                  controller: _verticalController,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    controller: _verticalController,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width,
                      ),
                      child: DataTable(
                          columns: const [
                            DataColumn(label: Text("Ime")),
                            DataColumn(label: Text("Prezime")),
                            DataColumn(label: Text("E-mail")),
                            DataColumn(label: Text("Telefon")),
                            DataColumn(
                                label: SizedBox(
                                    width: 100, child: Text("Datum rodjenja"))),
                            DataColumn(label: Text("Spol")),
                            DataColumn(label: Text("Odjel")),
                            DataColumn(label: Text("Status")),
                            DataColumn(label: Text("")),
                            DataColumn(label: Text("")),
                          ],
                          rows: result?.result
                                  .map<DataRow>(
                                    (e) => DataRow(
                                      cells: [
                                        DataCell(Text(e.korisnik!.ime!)),
                                        DataCell(Text(e.korisnik!.prezime!)),
                                        DataCell(Text(e.korisnik!.email!)),
                                        DataCell(
                                            Text(e.korisnik!.telefon ?? "-")),
                                        DataCell(
                                          SizedBox(
                                            width: 100,
                                            child: Center(
                                              child: Text(
                                                formattedDate(
                                                    e.korisnik!.datumRodjenja),
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
                                          ElevatedButton.icon(
                                            icon: const Icon(Icons.edit),
                                            label:
                                                const Text("Ažuriraj podatke"),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    EditMedicinskoOsobljeScreen(
                                                  medicinskoOsobljeId:
                                                      e.medicinskoOsobljeId!,
                                                  onSave: () {
                                                    fetchOsoblje();
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        DataCell(ElevatedButton.icon(
                                          icon: const Icon(Icons.delete),
                                          label: const Text("Ukloni osoblje"),
                                          onPressed: () async {
                                            showCustomDialog(
                                              context: context,
                                              title:
                                                  "Obrisati medicinsko osoblje?",
                                              message:
                                                  "Da li ste sigurni da želite ukloniti odabrano osoblje?",
                                              confirmText: "Da",
                                              isWarning: true,
                                              onConfirm: () async {
                                                try {
                                                  await provider.delete(
                                                      e.medicinskoOsobljeId!);
                                                  await Flushbar(
                                                    message:
                                                        "Osoblje je uspješno uklonjeno!",
                                                    duration: const Duration(
                                                        seconds: 3),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ).show(context);
                                                } catch (error) {
                                                  await Flushbar(
                                                    message:
                                                        "Došlo je do greške prilikom uklanjanja osoblja.",
                                                    duration: const Duration(
                                                        seconds: 3),
                                                    backgroundColor: Colors.red,
                                                  ).show(context);
                                                }
                                                fetchOsoblje();
                                              },
                                            );
                                          },
                                        )),
                                      ],
                                    ),
                                  )
                                  .toList() ??
                              []),
                    ),
                  )))),
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
