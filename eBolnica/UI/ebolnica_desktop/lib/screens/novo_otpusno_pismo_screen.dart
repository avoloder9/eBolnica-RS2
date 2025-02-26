import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/providers/otpusno_pismo_provider.dart';
import 'package:ebolnica_desktop/providers/terapija_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NovoOtpusnoPismoScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  final String? nazivOdjela;
  final int hospitalizacijaId;
  const NovoOtpusnoPismoScreen(
      {super.key,
      required this.userId,
      this.userType,
      this.nazivOdjela,
      required this.hospitalizacijaId});

  _NovoOtpusnoPismoScreenState createState() => _NovoOtpusnoPismoScreenState();
}

class _NovoOtpusnoPismoScreenState extends State<NovoOtpusnoPismoScreen> {
  late OtpusnoPismoProvider otpusnoPismoProvider;
  late TerapijaProvider terapijaProvider;

  TextEditingController dijagnozaController = TextEditingController();
  TextEditingController anamnezaController = TextEditingController();
  TextEditingController zakljucakController = TextEditingController();
  TextEditingController nazivTerapijeController = TextEditingController();
  TextEditingController opisTerapijeController = TextEditingController();

  bool prikaziTerapiju = false;
  DateTime? datumPocetka;
  DateTime? datumZavrsetka;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    otpusnoPismoProvider = OtpusnoPismoProvider();
    terapijaProvider = TerapijaProvider();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      title: const Center(
        child: Text(
          "Novo otpusno pismo",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: dijagnozaController,
                  decoration: const InputDecoration(labelText: "Dijagnoza"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ovo polje je obavezno';
                    }
                    return null;
                  },
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
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      prikaziTerapiju = !prikaziTerapiju;
                    });
                  },
                  child: Text(
                      prikaziTerapiju ? "Sakrij terapiju" : "Dodaj terapiju"),
                ),
                if (prikaziTerapiju) ...[
                  TextFormField(
                    controller: nazivTerapijeController,
                    decoration:
                        const InputDecoration(labelText: "Naziv terapije"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ovo polje je obavezno';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: opisTerapijeController,
                    decoration:
                        const InputDecoration(labelText: "Opis terapije"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ovo polje je obavezno';
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(
                            datumPocetka == null
                                ? "Odaberite datum početka"
                                : DateFormat('dd.MM.yyyy')
                                    .format(datumPocetka!),
                          ),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2026),
                            );
                            if (picked != null) {
                              setState(() {
                                datumPocetka = picked;
                                if (datumZavrsetka != null &&
                                    !datumZavrsetka!.isAfter(datumPocetka!)) {
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
                          ),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () async {
                            if (datumPocetka == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Prvo odaberite datum početka."),
                                ),
                              );
                              return;
                            }
                            DateTime initialDate =
                                datumPocetka!.add(const Duration(days: 1));
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: initialDate,
                              firstDate: initialDate,
                              lastDate: DateTime(2026),
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
                ]
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Odustani")),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              try {
                int? terapijaId;
                if (prikaziTerapiju) {
                  var terapija = await terapijaProvider.insert({
                    "Naziv": nazivTerapijeController.text,
                    "Opis": opisTerapijeController.text,
                    "DatumPocetka": datumPocetka!.toIso8601String(),
                    "DatumZavrsetka": datumZavrsetka!.toIso8601String(),
                  });
                  terapijaId = terapija.terapijaId;
                }

                var otpusnoPismo = {
                  "HospitalizacijaId": widget.hospitalizacijaId,
                  "Dijagnoza": dijagnozaController.text,
                  "Anamneza": anamnezaController.text,
                  "Zakljucak": zakljucakController.text,
                  if (terapijaId != null) "TerapijaId": terapijaId
                };
                await otpusnoPismoProvider.insert(otpusnoPismo);

                await Flushbar(
                  message: "Otpusno pismo je uspješno kreirano",
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 3),
                ).show(context);
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
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: const Text(
            "Sacuvaj",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}
