import 'dart:async';
import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/models/medicinska_dokumentacija_model.dart';
import 'package:ebolnica_desktop/models/pacijent_model.dart';
import 'package:ebolnica_desktop/models/search_result.dart';
import 'package:ebolnica_desktop/providers/medicinska_dokumentacija_provider.dart';
import 'package:ebolnica_desktop/screens/edit_pacijent_screen.dart';
import 'package:ebolnica_desktop/screens/medicinska_dokumentacija_screen.dart';
import 'package:ebolnica_desktop/screens/novi_pacijent_screen.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';
import 'package:intl/intl.dart';

class PacijentListScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  final String? nazivOdjela;
  const PacijentListScreen(
      {super.key, required this.userId, this.userType, this.nazivOdjela});

  @override
  State<PacijentListScreen> createState() => _PacijentListScreenState();
}

class _PacijentListScreenState extends State<PacijentListScreen> {
  late PacijentProvider provider;
  late MedicinskaDokumentacijaProvider dokumentacijaProvider;
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
    dokumentacijaProvider = MedicinskaDokumentacijaProvider();
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
        title: const Text("Pacijenti"),
      ),
      drawer: SideBar(
        userType: widget.userType!,
        userId: widget.userId,
        nazivOdjela: widget.nazivOdjela,
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
                await _performSearch();
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _prezimeEditingController,
              decoration: const InputDecoration(labelText: "Prezime"),
              onChanged: (value) async {
                await _performSearch();
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _brojKarticeController,
              decoration:
                  const InputDecoration(labelText: "Broj zdravstvene kartice"),
              onChanged: (value) async {
                await _performSearch();
              },
            ),
          ),
          const SizedBox(width: 8),
          if (widget.userType == "administrator" ||
              widget.userType == "medicinsko osoblje")
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return NoviPacijentScreen(
                      userId: widget.userId,
                    );
                  },
                );
              },
              child: const Text("Dodaj novog pacijenta"),
            ),
        ],
      ),
    );
  }

  Future<void> _performSearch() async {
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
      filter: filter,
      page: page,
      pageSize: pageSize,
    );
    setState(() {});
  }

  Widget _buildResultView() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
            ),
            child: DataTable(
              showCheckboxColumn: false,
              columns: [
                const DataColumn(label: Text("Ime")),
                const DataColumn(label: Text("Prezime")),
                const DataColumn(label: Text("E-mail")),
                const DataColumn(
                    label: SizedBox(
                        width: 160,
                        child:
                            Center(child: Text("Broj zdravstvene kartice")))),
                const DataColumn(label: Text("Telefon")),
                const DataColumn(
                    label: SizedBox(width: 60, child: Text("Adresa"))),
                const DataColumn(
                    label: SizedBox(width: 100, child: Text("Datum rodjenja"))),
                const DataColumn(label: Text("Status")),
                if (widget.userType == "medicinsko osoblje")
                  const DataColumn(label: Text("Medicinska dokumentacija")),
                const DataColumn(label: Text("")),
                const DataColumn(label: Text("")),
              ],
              rows: result?.result
                      .map<DataRow>(
                        (e) => DataRow(
                            cells: [
                              DataCell(Text(e.korisnik!.ime!)),
                              DataCell(Text(e.korisnik!.prezime!)),
                              DataCell(Text(e.korisnik!.email!)),
                              DataCell(SizedBox(
                                  width: 160,
                                  child: Center(
                                      child: Text(e.brojZdravstveneKartice
                                          .toString())))),
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
                              DataCell(Text(e.korisnik!.status == true
                                  ? "Aktivan"
                                  : "Neaktivan")),
                              if (widget.userType == "medicinsko osoblje")
                                DataCell(
                                  FutureBuilder<MedicinskaDokumentacija?>(
                                    future: dokumentacijaProvider
                                        .getMedicinskaDokumentacijaByPacijentId(
                                            e.pacijentId!),
                                    builder: (context,
                                        AsyncSnapshot<MedicinskaDokumentacija?>
                                            snapshot) {
                                      if (!snapshot.hasData) {
                                        return ElevatedButton(
                                          child: const Text(
                                              "Kreiraj dokumentaciju"),
                                          onPressed: () {
                                            kreirajMedicinskuDokumentaciju(
                                              context,
                                              MedicinskaDokumentacija(
                                                  pacijentId: e.pacijentId!),
                                            );
                                          },
                                        );
                                      } else {
                                        return ElevatedButton(
                                          child: const Text(
                                              "Prikaži dokumentaciju"),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  MedicinskaDokumentacijaScreen(
                                                pacijentId: e.pacijentId!,
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                              DataCell(
                                widget.userType == "administrator"
                                    ? ElevatedButton.icon(
                                        icon: const Icon(Icons.edit),
                                        label: const Text("Ažuriraj podatke"),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                EditPacijentScreen(
                                              pacijentId: e.pacijentId!,
                                              onSave: () {
                                                _loadInitialData();
                                              },
                                            ),
                                          );
                                        },
                                      )
                                    : const SizedBox.shrink(),
                              ),
                              DataCell(
                                widget.userType == "administrator"
                                    ? ElevatedButton.icon(
                                        icon: const Icon(Icons.delete),
                                        label: const Text("Ukloni pacijenta"),
                                        onPressed: () async {
                                          showCustomDialog(
                                            context: context,
                                            title: "Obrisati pacijenta?",
                                            message:
                                                "Da li ste sigurni da zelite ukloniti pacijenta",
                                            confirmText: "Da",
                                            onConfirm: () async {
                                              try {
                                                await provider
                                                    .delete(e.pacijentId!);
                                                await Flushbar(
                                                  message:
                                                      "Pacijent je uspješno uklonjen!",
                                                  duration: const Duration(
                                                      seconds: 3),
                                                  backgroundColor: Colors.green,
                                                ).show(context);
                                              } catch (error) {
                                                await Flushbar(
                                                  message:
                                                      "Došlo je do greške prilikom uklanjanja pacijenta.",
                                                  duration: const Duration(
                                                      seconds: 3),
                                                  backgroundColor: Colors.red,
                                                ).show(context);
                                              }
                                              _loadInitialData();
                                            },
                                          );
                                        },
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                            onSelectChanged:
                                widget.userType == "administrator" ||
                                        widget.userType == "doktor"
                                    ? (selected) async {
                                        if (selected != null && selected) {
                                          final dokumentacija =
                                              await dokumentacijaProvider
                                                  .getMedicinskaDokumentacijaByPacijentId(
                                                      e.pacijentId!);
                                          if (dokumentacija == null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "Ovaj pacijent nema medicinsku dokumentaciju."),
                                              ),
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  MedicinskaDokumentacijaScreen(
                                                pacijentId: e.pacijentId!,
                                              ),
                                            );
                                          }
                                        }
                                      }
                                    : null),
                      )
                      .toList() ??
                  [],
            ),
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

  Future<void> kreirajMedicinskuDokumentaciju(
      BuildContext context, MedicinskaDokumentacija dokumentacija) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white.withOpacity(0.9),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 60,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    "Kreiranje dokumentacije?",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Da li ste sigurni da želite kreirati dokumentaciju za odabranog pacijenta?",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Odustani"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          var request = {
                            "PacijentId": dokumentacija.pacijentId,
                            "DatumKreiranja": DateTime.now().toIso8601String(),
                            "Hospitalizovan": false,
                            "Napomena": ""
                          };

                          try {
                            await dokumentacijaProvider.insert(request);
                            Navigator.of(context).pop();
                            await Flushbar(
                                    message:
                                        "Medicinska dokumentacija uspješno kreirana",
                                    backgroundColor: Colors.green,
                                    duration: const Duration(seconds: 3))
                                .show(context);
                            setState(() {});
                          } catch (error) {
                            await Flushbar(
                                    message:
                                        "Došlo je do greške. Pokušajte ponovo.",
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 3))
                                .show(context);
                          }
                        },
                        child: const Text("Da"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
