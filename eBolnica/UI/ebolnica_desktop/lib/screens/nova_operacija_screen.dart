import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/models/pacijent_model.dart';
import 'package:ebolnica_desktop/providers/doktor_provider.dart';
import 'package:ebolnica_desktop/providers/operacija_provider.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';
import 'package:ebolnica_desktop/screens/operacije_screen.dart';
import 'package:ebolnica_desktop/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NovaOperacijaScreen extends StatefulWidget {
  final int userId;
  final int? doktorId;
  final String? userType;
  final String? nazivOdjela;
  const NovaOperacijaScreen(
      {super.key,
      required this.userId,
      this.doktorId,
      this.userType,
      this.nazivOdjela});

  _NovaOperacijaScreenState createState() => _NovaOperacijaScreenState();
}

class _NovaOperacijaScreenState extends State<NovaOperacijaScreen> {
  final _formKey = GlobalKey<FormState>();

  int? pacijentId;
  Pacijent? odabraniPacijent;
  List<Pacijent> pacijenti = [];
  final tipOperacijeController = TextEditingController();
  final komentarController = TextEditingController();
  late PacijentProvider pacijentProvider;
  late OperacijaProvider operacijaProvider;
  late DoktorProvider doktorProvider;
  DateTime? datumOperacije;
  DateTime selectedDate = DateTime.now();
  List<String> zauzetiTermini = [];

  @override
  void initState() {
    super.initState();
    pacijentProvider = PacijentProvider();
    operacijaProvider = OperacijaProvider();
    doktorProvider = DoktorProvider();
    fetchPacijenti();
    loadZauzetiTermini();
  }

  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      selectableDayPredicate: (DateTime day) {
        String formattedDay = DateFormat('yyyy-MM-dd').format(day);
        return !zauzetiTermini.contains(formattedDay);
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        zauzetiTermini = [];
      });
      loadZauzetiTermini();
    }
  }

  Future<void> loadZauzetiTermini() async {
    try {
      var result = await operacijaProvider.getZauzetiTermini(
          widget.doktorId!, selectedDate);
      setState(() {
        zauzetiTermini = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Greška pri učitavanju zauzetih termina $e')),
      );
    }
  }

  Future<void> fetchPacijenti() async {
    try {
      var result = await pacijentProvider.getPacijentSaDokumentacijom();
      setState(() {
        pacijenti = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Greška pri dohvaćanju pacijenata')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(20.0),
      title: const Center(
        child: Text(
          "Nova operacija",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                pacijentId != null
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: DropdownButtonFormField<Pacijent>(
                          value: odabraniPacijent,
                          decoration: InputDecoration(
                            labelText: 'Pacijent',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            prefixIcon: const Icon(Icons.person),
                          ),
                          items: pacijenti.map((pacijent) {
                            return DropdownMenuItem(
                              value: pacijent,
                              child: Text(
                                  "${pacijent.korisnik!.ime} ${pacijent.korisnik!.prezime}"),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              odabraniPacijent = value;
                            });
                          },
                          validator: (value) => dropdownValidator(
                            value?.korisnik != null
                                ? "${value!.korisnik!.ime} ${value.korisnik!.prezime}"
                                : null,
                            'pacijenta',
                          ),
                        ),
                      ),
                GestureDetector(
                  onTap: pickDate,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('dd.MM.yyyy').format(selectedDate),
                          style: const TextStyle(fontSize: 18),
                        ),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    controller: tipOperacijeController,
                    decoration: InputDecoration(
                      labelText: 'Tip operacije',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: const Icon(Icons.medical_services),
                    ),
                    validator: (value) => generalValidator(
                        value,
                        'tip operacije',
                        [notEmpty, startsWithCapital, maxLength(100)]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    controller: komentarController,
                    decoration: InputDecoration(
                      labelText: 'Komentar',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: const Icon(Icons.comment),
                    ),
                    validator: (value) => generalValidator(value, 'komentar',
                        [notEmpty, startsWithCapital, maxLength(100)]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Odustani")),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            var novaOperacija = {
                              "pacijentId":
                                  pacijentId ?? odabraniPacijent?.pacijentId,
                              "doktorId": widget.doktorId,
                              "datumOperacije":
                                  DateFormat('yyyy-MM-dd').format(selectedDate),
                              "tipOperacije": tipOperacijeController.text,
                              "komentar": komentarController.text,
                              "stateMachine": "draft"
                            };
                            try {
                              await operacijaProvider.insert(novaOperacija);
                              await Flushbar(
                                      message: "Operacija je uspješno zakazana",
                                      backgroundColor: Colors.green,
                                      duration: const Duration(seconds: 3))
                                  .show(context);

                              if (mounted) {
                                setState(() {
                                  odabraniPacijent = null;
                                });
                              }
                              _formKey.currentState?.reset();
                              if (mounted) {
                                await Future.wait([
                                  Future.delayed(const Duration(seconds: 1)),
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return OperacijaScreen(
                                        userId: widget.userId,
                                        nazivOdjela: widget.nazivOdjela,
                                        userType: widget.userType,
                                      );
                                    }),
                                  )
                                ]);
                                return;
                              }
                            } catch (e) {
                              await Flushbar(
                                      message:
                                          "Došlo je do greške. Pokušajte ponovo.",
                                      backgroundColor: Colors.red,
                                      duration: const Duration(seconds: 2))
                                  .show(context);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        child: const Text(
                          "Zakaži operaciju",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
