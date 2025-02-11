import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/models/termin_model.dart';
import 'package:ebolnica_desktop/models/uputnica_model.dart';
import 'package:ebolnica_desktop/providers/doktor_provider.dart';
import 'package:ebolnica_desktop/providers/medicinska_dokumentacija_provider.dart';
import 'package:ebolnica_desktop/providers/pregled_provider.dart';
import 'package:ebolnica_desktop/providers/termin_provider.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoktorTerminiScreen extends StatefulWidget {
  final int userId;
  const DoktorTerminiScreen({super.key, required this.userId});
  @override
  State<DoktorTerminiScreen> createState() => _DoktorTerminiScreenState();
}

class _DoktorTerminiScreenState extends State<DoktorTerminiScreen> {
  late DoktorProvider doktorProvider;
  late TerminProvider terminProvider;
  late PregledProvider pregledProvider;
  late MedicinskaDokumentacijaProvider dokumentacijaProvider;
  List<Termin>? termini = [];
  int? doktorId;
  List<Uputnica>? uputnica = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    doktorProvider = DoktorProvider();
    terminProvider = TerminProvider();
    pregledProvider = PregledProvider();
    dokumentacijaProvider = MedicinskaDokumentacijaProvider();
    fetchTermini();
  }

  String formattedDate(date) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  String formattedTime(Duration time) {
    final hours = time.inHours.toString().padLeft(2, '0');
    final minutes = (time.inMinutes % 60).toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  Future<void> fetchTermini() async {
    termini = [];
    doktorId = await doktorProvider.getDoktorIdByKorisnikId(widget.userId);
    if (doktorId != null) {
      var result = await doktorProvider.getTerminByDoktorId(doktorId!);
      setState(() {
        termini = result;
      });
      if (termini == null) {
        print("Nema termina za ovog doktora");
      }
    } else {
      print("Nije pronadjen doktor");
    }
  }

  Future<bool> isUputnicaAktivna(int terminId) async {
    Uputnica? uputnica = await terminProvider.getUputnicaByTerminId(terminId);
    return uputnica.stateMachine == "active";
  }

  Future<int?> getUputnicaIdByTerminId(int terminId) async {
    try {
      Uputnica? uputnica = await terminProvider.getUputnicaByTerminId(terminId);
      return uputnica.uputnicaId;
    } catch (e) {
      return null;
    }
  }

  void pregledDijalog(int terminId, int pacijentId) async {
    int? uputnicaId = await getUputnicaIdByTerminId(terminId);
    if (uputnicaId == null) {
      await Flushbar(
        message:
            "Pregled nije moguć jer uputnica ne postoji za odabrani termin.",
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ).show(context);
      return;
    }
    bool aktivnaUputnica = await isUputnicaAktivna(terminId);
    if (!aktivnaUputnica) {
      await Flushbar(
        message:
            "Pregled nije moguć jer uputnica nije aktivna za odabrani termin.",
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ).show(context);
      return;
    }
    TextEditingController dijagnozaController = TextEditingController();
    TextEditingController anamnezaController = TextEditingController();
    TextEditingController zakljucakController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Kreiranje pregleda"),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            // height: MediaQuery.of(context).size.height * 0.4,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: dijagnozaController,
                    decoration:
                        const InputDecoration(labelText: "Glavna dijagnoza"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ovo polje je obavezno';
                      }
                      return null;
                    },
                    maxLines: 2,
                    keyboardType: TextInputType.multiline,
                  ),
                  TextFormField(
                    controller: anamnezaController,
                    decoration: const InputDecoration(labelText: "Anamneza"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ovo polje je obavezno';
                      }
                      return null;
                    },
                    maxLines: 2,
                    //   keyboardType: TextInputType.multiline,
                  ),
                  TextFormField(
                    controller: zakljucakController,
                    decoration: const InputDecoration(labelText: "Zakljucak"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ovo polje je obavezno';
                      }
                      return null;
                    },
                    maxLines: 2,
                    keyboardType: TextInputType.multiline,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Odustani"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  var dokumentacija = await dokumentacijaProvider
                      .getMedicinskaDokumentacijaByPacijentId(pacijentId);
                  try {
                    await pregledProvider.insert({
                      "UputnicaId": uputnicaId,
                      "MedicinskaDokumentacijaId":
                          dokumentacija.medicinskaDokumentacijaId,
                      "GlavnaDijagnoza": dijagnozaController.text,
                      "Anamneza": anamnezaController.text,
                      "Zakljucak": zakljucakController.text,
                    });
                    await Flushbar(
                      message: "Pregled je uspješno dodan",
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 3),
                    ).show(context);
                    setState(() {});
                    await Future.delayed(const Duration(seconds: 1));
                    Navigator.pop(context);
                  } catch (e) {
                    await Flushbar(
                      message: "Došlo je do greške. Pokušajte ponovo.",
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 2),
                    ).show(context);
                  }
                }
              },
              child: const Text("Sacuvaj"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Zakazani termini"),
      ),
      drawer: SideBar(
        userType: "doktor",
        userId: widget.userId,
      ),
      body: Column(
        children: [_buildResultView()],
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
              DataColumn(label: Text("Pacijent")),
              DataColumn(label: Text("Datum termin")),
              DataColumn(label: Text("Vrijeme termina")),
              DataColumn(label: Text("Uputnica")),
              DataColumn(label: Text("")),
            ],
            rows: termini!
                .map<DataRow>(
                  (e) => DataRow(
                    cells: [
                      DataCell(Text(
                          "${e.pacijent!.korisnik!.ime} ${e.pacijent!.korisnik!.prezime}")),
                      DataCell(Text(formattedDate(e.datumTermina))),
                      DataCell(Text(formattedTime(e.vrijemeTermina!))),
                      DataCell(
                        FutureBuilder<Uputnica>(
                          future:
                              terminProvider.getUputnicaByTerminId(e.terminId!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return const Text("Uputnica nije poslana");
                            } else if (snapshot.hasData) {
                              return Text(snapshot.data!.stateMachine ?? "N/A");
                            } else {
                              return const Text("N/A");
                            }
                          },
                        ),
                      ),
                      DataCell(
                        ElevatedButton(
                          child: const Text("Obavi pregled"),
                          onPressed: () =>
                              pregledDijalog(e.terminId!, e.pacijentId!),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
