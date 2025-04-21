import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/models/search_result.dart';
import 'package:ebolnica_desktop/models/termin_model.dart';
import 'package:ebolnica_desktop/models/uputnica_model.dart';
import 'package:ebolnica_desktop/providers/doktor_provider.dart';
import 'package:ebolnica_desktop/providers/medicinska_dokumentacija_provider.dart';
import 'package:ebolnica_desktop/providers/pregled_provider.dart';
import 'package:ebolnica_desktop/providers/terapija_provider.dart';
import 'package:ebolnica_desktop/providers/termin_provider.dart';
import 'package:ebolnica_desktop/providers/uputnica_provider.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoktorTerminiScreen extends StatefulWidget {
  final int userId;
  final String? nazivOdjela;
  const DoktorTerminiScreen(
      {super.key, required this.userId, this.nazivOdjela});
  @override
  State<DoktorTerminiScreen> createState() => _DoktorTerminiScreenState();
}

class _DoktorTerminiScreenState extends State<DoktorTerminiScreen> {
  late DoktorProvider doktorProvider;
  late TerminProvider terminProvider;
  late PregledProvider pregledProvider;
  late MedicinskaDokumentacijaProvider dokumentacijaProvider;
  late TerapijaProvider terapijaProvider;
  late UputnicaProvider uputnicaProvider;
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
    terapijaProvider = TerapijaProvider();
    uputnicaProvider = UputnicaProvider();
    fetchTermini();
  }

  Future<void> fetchTermini() async {
    termini = [];
    doktorId = await doktorProvider.getDoktorIdByKorisnikId(widget.userId);
    if (doktorId != null) {
      var result = await terminProvider.get(filter: {"DoktorId": doktorId});
      setState(() {
        termini = result.result;
      });
      if (termini == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nema termina za ovog doktora')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Nije pronađen doktor')));
    }
  }

  Future<bool> isUputnicaAktivna(int terminId) async {
    SearchResult<Uputnica>? uputnica =
        await uputnicaProvider.get(filter: {"TerminId": terminId});
    return uputnica.result.first.stateMachine == "active";
  }

  Future<int?> getUputnicaIdByTerminId(int terminId) async {
    try {
      SearchResult<Uputnica>? uputnica =
          await uputnicaProvider.get(filter: {"TerminId": terminId});
      return uputnica.result.first.uputnicaId;
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
        bool prikaziTerapiju = false;
        TextEditingController nazivTerapijeController = TextEditingController();
        TextEditingController opisTerapijeController = TextEditingController();
        DateTime? datumPocetka;
        DateTime? datumZavrsetka;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                "Kreiranje pregleda",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: dijagnozaController,
                          decoration: InputDecoration(
                            labelText: "Glavna dijagnoza",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ovo polje je obavezno';
                            }
                            return null;
                          },
                          maxLines: 2,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: anamnezaController,
                          decoration: InputDecoration(
                            labelText: "Anamneza",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ovo polje je obavezno';
                            }
                            return null;
                          },
                          maxLines: 2,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: zakljucakController,
                          decoration: InputDecoration(
                            labelText: "Zaključak",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ovo polje je obavezno';
                            }
                            return null;
                          },
                          maxLines: 2,
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              prikaziTerapiju = !prikaziTerapiju;
                            });
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue,
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          child: Text(
                            prikaziTerapiju
                                ? "Sakrij terapiju"
                                : "Dodaj terapiju",
                          ),
                        ),
                        if (prikaziTerapiju) ...[
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: nazivTerapijeController,
                            decoration: InputDecoration(
                              labelText: "Naziv terapije",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ovo polje je obavezno';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: opisTerapijeController,
                            decoration: InputDecoration(
                              labelText: "Opis terapije",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ovo polje je obavezno';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    datumPocetka == null
                                        ? "Odaberite datum početka"
                                        : DateFormat('dd.MM.yyyy')
                                            .format(datumPocetka!),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  trailing: const Icon(Icons.calendar_today),
                                  onTap: () async {
                                    DateTime? picked = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2100),
                                    );
                                    if (picked != null) {
                                      setState(() {
                                        datumPocetka = picked;
                                        if (datumZavrsetka != null &&
                                            !datumZavrsetka!
                                                .isAfter(datumPocetka!)) {
                                          datumZavrsetka = null;
                                        }
                                      });
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    datumZavrsetka == null
                                        ? "Odaberite datum završetka"
                                        : DateFormat('dd.MM.yyyy')
                                            .format(datumZavrsetka!),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  trailing: const Icon(Icons.calendar_today),
                                  onTap: () async {
                                    if (datumPocetka == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Prvo odaberite datum početka."),
                                        ),
                                      );
                                      return;
                                    }
                                    DateTime initialDate = datumPocetka!
                                        .add(const Duration(days: 1));
                                    DateTime? picked = await showDatePicker(
                                      context: context,
                                      initialDate: initialDate,
                                      firstDate: initialDate,
                                      lastDate: DateTime(2100),
                                    );
                                    if (picked != null) {
                                      setState(() {
                                        datumZavrsetka = picked;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Odustani",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const Dialog(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 6.0,
                                ),
                              ),
                            ),
                          );
                        },
                      );

                      var dokumentacija = await dokumentacijaProvider
                          .getMedicinskaDokumentacijaByPacijentId(pacijentId);
                      try {
                        var pregled = await pregledProvider.insert({
                          "UputnicaId": uputnicaId,
                          "MedicinskaDokumentacijaId":
                              dokumentacija!.medicinskaDokumentacijaId,
                          "GlavnaDijagnoza": dijagnozaController.text,
                          "Anamneza": anamnezaController.text,
                          "Zakljucak": zakljucakController.text,
                        });

                        if (prikaziTerapiju) {
                          await terapijaProvider.insert({
                            "Naziv": nazivTerapijeController.text,
                            "Opis": opisTerapijeController.text,
                            "DatumPocetka": datumPocetka!.toIso8601String(),
                            "DatumZavrsetka": datumZavrsetka!.toIso8601String(),
                            "PregledId": pregled.pregledId
                          });
                        }
                        Navigator.pop(context);
                        await Flushbar(
                          message: "Pregled je uspješno dodan",
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 3),
                        ).show(context);
                        await Future.delayed(const Duration(seconds: 1));
                        Navigator.pop(context);
                        fetchTermini();
                      } catch (e) {
                        await Flushbar(
                          message: "Došlo je do greške. Pokušajte ponovo.",
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 2),
                        ).show(context);
                        Navigator.pop(context);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Sačuvaj",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            );
          },
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
        nazivOdjela: widget.nazivOdjela,
      ),
      body: Column(
        children: [_buildResultView()],
      ),
    );
  }

  Widget _buildResultView() {
    if (termini == null || termini!.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text(
            "Nemate zakazanih termina",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

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
              DataColumn(label: Text("")),
            ],
            rows: termini!.map<DataRow>(
              (e) {
                bool danas = isDanasnjiDan(e.datumTermina!, DateTime.now());

                return DataRow(
                  cells: [
                    DataCell(Text(
                        "${e.pacijent!.korisnik!.ime} ${e.pacijent!.korisnik!.prezime}")),
                    DataCell(Text(formattedDate(e.datumTermina))),
                    DataCell(Text(formattedTime(e.vrijemeTermina!))),
                    DataCell(
                      Tooltip(
                        message: danas
                            ? "Kliknite za obavljanje pregleda"
                            : "Pregled nije moguće obaviti jer datum termina nije današnji",
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: danas ? Colors.blue : Colors.grey,
                          ),
                          onPressed: danas
                              ? () => pregledDijalog(e.terminId!, e.pacijentId!)
                              : null,
                          child: const Text("Obavi pregled"),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }

  bool isDanasnjiDan(DateTime datum1, DateTime datum2) {
    return datum1.year == datum2.year &&
        datum1.month == datum2.month &&
        datum1.day == datum2.day;
  }
}
