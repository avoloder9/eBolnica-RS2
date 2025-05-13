import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/models/doktor_model.dart';
import 'package:ebolnica_desktop/models/odjel_model.dart';
import 'package:ebolnica_desktop/models/search_result.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';
import 'package:ebolnica_desktop/providers/doktor_provider.dart';
import 'package:ebolnica_desktop/providers/odjel_provider.dart';
import 'package:ebolnica_desktop/screens/novi_odjel_screen.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:ebolnica_desktop/screens/soba_list_screen.dart';
import 'package:flutter/material.dart';

class OdjelListScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  const OdjelListScreen({super.key, required this.userId, this.userType});
  @override
  State<OdjelListScreen> createState() => _OdjelListScreenState();
}

class _OdjelListScreenState extends State<OdjelListScreen> {
  late OdjelProvider provider;
  late DoktorProvider doktorProvider;
  SearchResult<Odjel>? result;

  final TextEditingController _nazivEditingController = TextEditingController();
  final TextEditingController _doktorEditingController =
      TextEditingController();
  List<dynamic> _doktori = [];
  int? _selectedDoktorId;
  @override
  void initState() {
    super.initState();
    provider = OdjelProvider();
    doktorProvider = DoktorProvider();
    _loadInitialData();
  }

  Future<void> _loadDoktori(int odjelId) async {
    try {
      final doktori = await doktorProvider.get(filter: {"OdjelId": odjelId});
      setState(() {
        _doktori = doktori.result;
        final odjel = result?.result.firstWhere(
          (odjel) => odjel.odjelId == odjelId,
          orElse: () => Odjel(),
        );

        final glavniDoktorId = odjel?.glavniDoktor?.doktorId;
        if (glavniDoktorId != null) {
          _selectedDoktorId = glavniDoktorId;
          final glavniDoktor = _doktori.firstWhere(
              (doktor) => doktor.doktorId == glavniDoktorId,
              orElse: () => Doktor());
          _doktorEditingController.text =
              '${glavniDoktor.korisnik?.ime ?? ""} ${glavniDoktor.korisnik?.prezime ?? ""}';
        } else {
          _selectedDoktorId = null;
        }
        setState(() {});
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Greška pri učitavanju doktora')),
      );
    }
  }

  Future<void> _loadInitialData() async {
    result = await provider.get(filter: {});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Odjeli"),
      ),
      drawer: SideBar(
        userType: widget.userType!,
        userId: widget.userId,
      ),
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
              onChanged: (value) async {
                await _performSearch();
              },
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          if (widget.userType == "administrator")
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return NoviOdjelScreen(
                      userId: widget.userId,
                      userType: widget.userType,
                    );
                  },
                );
              },
              child: const Text("Dodaj novi odjel"),
            ),
        ],
      ),
    );
  }

  Future<void> _performSearch() async {
    var filter = <String, dynamic>{
      'nazivGTE': _nazivEditingController.text.isNotEmpty
          ? _nazivEditingController.text
          : null
    };
    result = await provider.get(
      filter: filter,
    );
    setState(() {});
  }

  Widget _buildResultView() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: DataTable(
            columns: const [
              DataColumn(
                  label: Text("Naziv",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black))),
              DataColumn(
                  label: Text("Broj soba",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black))),
              DataColumn(
                  label: Text("Broj kreveta",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black))),
              DataColumn(
                  label: Text("Broj slobodnih kreveta",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black))),
              DataColumn(
                  label: Text("Glavni doktor",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black))),
              DataColumn(
                  label: Text("Akcije",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black))),
            ],
            rows: result?.result
                    .map<DataRow>(
                      (e) => DataRow(
                        cells: [
                          DataCell(Text(e.naziv.toString(),
                              style: const TextStyle(fontSize: 16))),
                          DataCell(SizedBox(
                            width: 50,
                            child: Center(
                              child: Text(e.brojSoba.toString(),
                                  style: const TextStyle(fontSize: 16)),
                            ),
                          )),
                          DataCell(SizedBox(
                              width: 70,
                              child: Center(
                                  child: Text(e.brojKreveta.toString(),
                                      style: const TextStyle(fontSize: 16))))),
                          DataCell(SizedBox(
                              width: 130,
                              child: Center(
                                  child: Text(e.brojSlobodnihKreveta.toString(),
                                      style: const TextStyle(fontSize: 16))))),
                          DataCell(
                            Text(
                              (e.glavniDoktor?.korisnik?.ime != null &&
                                      e.glavniDoktor?.korisnik?.prezime != null)
                                  ? '${e.glavniDoktor?.korisnik?.ime ?? ""} ${e.glavniDoktor?.korisnik?.prezime ?? ""}'
                                  : "Nema glavnog doktora",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                widget.userType == "administrator"
                                    ? ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.teal,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () {
                                          if (e.odjelId != null) {
                                            _loadDoktori(e.odjelId!);
                                          }
                                          showDialog(
                                            context: context,
                                            builder: (context) => setGlavniDoktor(
                                                e.odjelId!,
                                                e.naziv!,
                                                (e.glavniDoktor?.korisnik
                                                                ?.ime !=
                                                            null &&
                                                        e.glavniDoktor?.korisnik
                                                                ?.prezime !=
                                                            null)
                                                    ? '${e.glavniDoktor?.korisnik?.ime ?? ""} ${e.glavniDoktor?.korisnik?.prezime ?? ""}'
                                                    : ""),
                                          );
                                        },
                                        icon: Icon(e.glavniDoktor != null
                                            ? Icons.update
                                            : Icons.person_add),
                                        label: Text(e.glavniDoktor != null
                                            ? "Ažuriraj glavnog doktora"
                                            : "Postavi doktora"),
                                      )
                                    : const SizedBox.shrink(),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.lightBlueAccent,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SobaListScreen(
                                          odjelId: e.odjelId!,
                                          userId: widget.userId,
                                          userType: widget.userType,
                                        ),
                                      ),
                                    ).then((refresh) {
                                      if (refresh == true) {
                                        _loadInitialData();
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.visibility),
                                  label: const Text("Detalji"),
                                ),
                              ],
                            ),
                          ),
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

  Widget setGlavniDoktor(int odjelId, String nazivOdjela, String nazivDoktora) {
    final TextEditingController nazivOdjelaController =
        TextEditingController(text: nazivOdjela);

    return Dialog(
      child: SizedBox(
        width: 400,
        height: 260,
        child: FutureBuilder<SearchResult<Doktor>>(
          future: doktorProvider.get(filter: {"OdjelId": odjelId}),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              if (snapshot.error is UserFriendlyException) {
                const errorMessage =
                    "Trenutno nije zaposlen nijedan doktor na ovom odjelu.";
                return const Center(child: Text(errorMessage));
              }

              return Center(child: Text("Greška: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.count == 0) {
              return const Center(child: Text("Nema dostupnih doktora."));
            } else {
              final doktori = snapshot.data!;

              final glavniDoktor = doktori.result.firstWhere(
                  (doktor) => doktor.doktorId == _selectedDoktorId,
                  orElse: () => Doktor());

              if (glavniDoktor.korisnik != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _doktorEditingController.text =
                          '${glavniDoktor.korisnik?.ime ?? ""} ${glavniDoktor.korisnik?.prezime ?? ""}';
                      _selectedDoktorId = glavniDoktor.doktorId;
                    });
                  }
                });
              }
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Odaberi glavnog doktora",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nazivOdjelaController,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: "Naziv",
                        labelStyle: const TextStyle(color: Colors.teal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: "Glavni doktor",
                        labelStyle: const TextStyle(color: Colors.teal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Colors.teal, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Colors.teal, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                      ),
                      items: doktori.result
                          .map<DropdownMenuItem<int>>(
                            (doktor) => DropdownMenuItem<int>(
                              value: doktor.doktorId!,
                              child: Text(
                                "${doktor.korisnik!.ime} ${doktor.korisnik!.prezime}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          )
                          .toList(),
                      value: _selectedDoktorId,
                      onChanged: (value) {
                        setState(() {
                          _selectedDoktorId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Odustani"),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            if (_selectedDoktorId != null) {
                              final updateRequest = {
                                "Naziv": nazivOdjelaController.text,
                                "GlavniDoktorId": _selectedDoktorId
                              };

                              await provider.update(odjelId, updateRequest);

                              _loadInitialData();
                              Navigator.pop(context);
                              Flushbar(
                                message: "Podaci su uspješno ažurirani!",
                                duration: const Duration(seconds: 3),
                                backgroundColor: Colors.green,
                              ).show(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Odaberite doktora!")),
                              );
                            }
                          },
                          child: const Text("Sačuvaj"),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
