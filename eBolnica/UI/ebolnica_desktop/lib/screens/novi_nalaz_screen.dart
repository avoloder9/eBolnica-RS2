import 'package:ebolnica_desktop/models/doktor_model.dart';
import 'package:ebolnica_desktop/models/laboratorijski_nalaz_model.dart';
import 'package:ebolnica_desktop/models/pacijent_model.dart';
import 'package:ebolnica_desktop/providers/doktor_provider.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';
import 'package:ebolnica_desktop/screens/nalaz_parametar_screen.dart';
import 'package:ebolnica_desktop/utils/validator.dart';
import 'package:flutter/material.dart';

class NoviNalazScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  const NoviNalazScreen({super.key, required this.userId, this.userType});
  @override
  _NoviNalazScreenState createState() => _NoviNalazScreenState();
}

class _NoviNalazScreenState extends State<NoviNalazScreen> {
  final _formKey = GlobalKey<FormState>();
  late DoktorProvider doktorProvider;
  late PacijentProvider pacijentProvider;
  Doktor? odabraniDoktor;
  List<Doktor> doktori = [];
  Pacijent? odabraniPacijent;
  List<Pacijent> pacijenti = [];

  Future<void> fetchDoktori() async {
    doktori = [];
    var result = await doktorProvider.get();
    setState(() {
      doktori = result.result;
    });
  }

  Future<void> fetchPacijenti() async {
    pacijenti = [];
    var result = await pacijentProvider.getPacijentSaDokumentacijom();
    setState(() {
      pacijenti = result;
    });
  }

  @override
  void initState() {
    super.initState();
    doktorProvider = DoktorProvider();
    pacijentProvider = PacijentProvider();
    fetchPacijenti();
    fetchDoktori();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      title: const Center(
        child: Text(
          "Kreiraj novi nalaz",
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<Doktor>(
                    value: odabraniDoktor,
                    decoration: InputDecoration(
                      labelText: 'Doktor',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    items: doktori
                        .map((doktor) => DropdownMenuItem(
                              value: doktor,
                              child: Text(
                                  "${doktor.korisnik!.ime} ${doktor.korisnik!.prezime}"),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        odabraniDoktor = value;
                      });
                    },
                    validator: (value) => dropdownValidator(
                      value?.korisnik != null
                          ? "${value!.korisnik!.ime} ${value.korisnik!.prezime}"
                          : null,
                      'doktora',
                    ),
                  ),
                ),
                Padding(
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
                            if (_formKey.currentState!.validate()) {
                              var noviNalaz = LaboratorijskiNalaz(
                                pacijentId: odabraniPacijent!.pacijentId,
                                doktorId: odabraniDoktor!.doktorId,
                                datumNalaza: DateTime.now(),
                              );
                              bool? rezultat = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NalazParametarScreen(
                                    laboratorijskiNalaz: noviNalaz,
                                  ),
                                ),
                              );
                              if (rezultat == true) {
                                Navigator.pop(context, true);
                              }
                            }
                          },
                          child: const Text("Dalje")),
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
