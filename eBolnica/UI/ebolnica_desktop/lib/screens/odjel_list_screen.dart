import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/models/doktor_model.dart';
import 'package:ebolnica_desktop/models/odjel_model.dart';
import 'package:ebolnica_desktop/models/search_result.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';
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
    _loadInitialData();
  }

  Future<void> _loadDoktori(int odjelId) async {
    try {
      final doktori = await provider.getDoktorByOdjelId(odjelId);
      setState(() {
        _doktori = doktori;
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
      print("Greska prilikom ucitavanja doktora");
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
        title: const Text("Lista odjela"),
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
                          DataCell(Text(
                            (e.glavniDoktor?.korisnik?.ime != null &&
                                    e.glavniDoktor?.korisnik?.prezime != null)
                                ? '${e.glavniDoktor?.korisnik?.ime ?? ""} ${e.glavniDoktor?.korisnik?.prezime ?? ""}'
                                : "Nije određen glavni doktor",
                          )),
                          DataCell(
                            widget.userType == "administrator"
                                ? ElevatedButton(
                                    child: const Text("Odredi glavnog doktora"),
                                    onPressed: () {
                                      _loadDoktori(e.odjelId!);
                                      showDialog(
                                          context: context,
                                          builder: (context) => setGlavniDoktor(
                                              e.odjelId!,
                                              e.naziv!,
                                              (e.glavniDoktor?.korisnik?.ime !=
                                                          null &&
                                                      e.glavniDoktor?.korisnik
                                                              ?.prezime !=
                                                          null)
                                                  ? '${e.glavniDoktor?.korisnik?.ime ?? ""} ${e.glavniDoktor?.korisnik?.prezime ?? ""}'
                                                  : ""));
                                    },
                                  )
                                : const SizedBox.shrink(),
                          ),
                          DataCell(
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SobaListScreen(
                                                odjelId: e.odjelId!,
                                                userId: widget.userId,
                                                userType: widget.userType,
                                              )));
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

  Widget setGlavniDoktor(int odjelId, String nazivOdjela, String nazivDoktora) {
    final TextEditingController _nazivOdjelaController =
        TextEditingController(text: nazivOdjela);

    return Dialog(
      child: Container(
        width: 400,
        height: 260,
        child: FutureBuilder<List<Doktor>>(
          future: provider.getDoktorByOdjelId(odjelId),
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
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Nema dostupnih doktora."));
            } else {
              final doktori = snapshot.data!;

              final glavniDoktor = doktori.firstWhere(
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
                  children: [
                    const Text(
                      "Odaberi glavnog doktora",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _nazivOdjelaController,
                      decoration: const InputDecoration(labelText: "Naziv"),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<int>(
                      decoration:
                          const InputDecoration(labelText: "Glavni doktor"),
                      items: doktori
                          .map<DropdownMenuItem<int>>(
                            (doktor) => DropdownMenuItem<int>(
                              value: doktor.doktorId!,
                              child: Text(
                                  "${doktor.korisnik!.ime} ${doktor.korisnik!.prezime}"),
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
                                "Naziv": _nazivOdjelaController.text,
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
