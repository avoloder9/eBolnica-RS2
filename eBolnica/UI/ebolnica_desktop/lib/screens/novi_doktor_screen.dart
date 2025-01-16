import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/models/doktor_model.dart';
import 'package:ebolnica_desktop/models/odjel_model.dart';
import 'package:ebolnica_desktop/models/search_result.dart';
import 'package:ebolnica_desktop/providers/doktor_provider.dart';
import 'package:ebolnica_desktop/providers/odjel_provider.dart';
import 'package:ebolnica_desktop/screens/doktor_list_screen.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoviDoktorScreen extends StatefulWidget {
  const NoviDoktorScreen({super.key});
  @override
  _NoviDoktorScreenState createState() => _NoviDoktorScreenState();
}

class _NoviDoktorScreenState extends State<NoviDoktorScreen> {
  final _formKey = GlobalKey<FormState>();
  final imeController = TextEditingController();
  final prezimeController = TextEditingController();
  final emailController = TextEditingController();
  final telefonController = TextEditingController();
  final datumController = TextEditingController();
  final odjelController = TextEditingController();
  final specijalizacijaController = TextEditingController();
  String specijalizacija = '';
  SearchResult<Doktor>? resultDoktor;
  SearchResult<Odjel>? resultOdjel;

  late DoktorProvider doktorProvider;
  late OdjelProvider odjelProvider;
  String spol = '';
  DateTime? datumRodjenja;
  String lozinkaPotvrda = '';
  Odjel? odabraniOdjel;
  List<String> odjeli = [];
  @override
  void initState() {
    super.initState();
    doktorProvider = DoktorProvider();
    odjelProvider = OdjelProvider();
    fetchOdjeli();
  }

  int _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Future<void> fetchOdjeli() async {
    try {
      SearchResult<Odjel> fetchedResult = await odjelProvider.get();
      debugPrint('Fetched Odjeli: ${fetchedResult.result}');
      setState(() {
        resultOdjel = fetchedResult;
      });
    } catch (e) {
      debugPrint('Error fetching odjeli: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      title: const Center(
        child: Text(
          'Dodaj novog pacijenta',
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
                  child: TextFormField(
                    controller: imeController,
                    decoration: InputDecoration(
                      labelText: 'Ime',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Molimo unesite ime';
                      }
                      if (value[0] != value[0].toUpperCase()) {
                        return 'Ime mora početi sa velikim slovom';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: prezimeController,
                    decoration: InputDecoration(
                      labelText: 'Prezime',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Molimo unesite prezime';
                      }
                      if (value[0] != value[0].toUpperCase()) {
                        return 'Prezime mora početi sa velikim slovom';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: const Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Molimo unesite validan email';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: telefonController,
                    decoration: InputDecoration(
                      labelText: 'Telefon',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: const Icon(Icons.phone),
                      counterText: '',
                    ),
                    keyboardType: TextInputType.phone,
                    maxLength: 12,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      PhoneNumberFormatter()
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Molimo unesite broj telefona';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<String>(
                    value: spol.isEmpty ? null : spol,
                    decoration: InputDecoration(
                      labelText: 'Spol',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: const Icon(Icons.transgender),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Muški', child: Text('Muški')),
                      DropdownMenuItem(value: 'Ženski', child: Text('Ženski')),
                    ],
                    onChanged: (value) {
                      spol = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Molimo odaberite spol';
                      }
                      return null;
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: datumRodjenja ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null && pickedDate != datumRodjenja) {
                      datumRodjenja = pickedDate;
                      datumController.text =
                          '${datumRodjenja!.day}/${datumRodjenja!.month}/${datumRodjenja!.year}';
                    }
                  },
                  child: AbsorbPointer(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Datum Rođenja',
                          suffixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        controller: datumController,
                        validator: (value) {
                          if (datumRodjenja == null) {
                            return 'Molimo unesite datum rođenja';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<String>(
                    value: specijalizacija.isEmpty ? null : specijalizacija,
                    decoration: InputDecoration(
                      labelText: 'Specijalizacija',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: const Icon(Icons.healing),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'Specijalista opće medicine',
                          child: Text('Opća medicina')),
                      DropdownMenuItem(
                          value: 'Specijalista pedijatrije',
                          child: Text('Pedijatrija')),
                      DropdownMenuItem(
                          value: 'Specijalista ginekologije',
                          child: Text('Ginekologija')),
                      DropdownMenuItem(
                          value: 'Specijalista hirurgije',
                          child: Text('Hirurgija')),
                      DropdownMenuItem(
                          value: 'Specijalista ortopedije',
                          child: Text('Ortopedija')),
                      DropdownMenuItem(
                          value: 'Specijalista kardiologije',
                          child: Text('Kardiologija')),
                      DropdownMenuItem(
                          value: 'Specijalista pulmologije',
                          child: Text('Pulmologija')),
                      DropdownMenuItem(
                          value: 'Specijalista psihijatrije',
                          child: Text('Psihijatrija')),
                      DropdownMenuItem(
                          value: 'Specijalista dermatologije',
                          child: Text('Dermatologija')),
                      DropdownMenuItem(
                          value: 'Specijalista oftamologije',
                          child: Text('Oftamologija')),
                      DropdownMenuItem(
                          value: 'Specijalista gastroenterologije',
                          child: Text('Gastroenterologija')),
                      DropdownMenuItem(
                          value: 'Specijalista radiologije',
                          child: Text('Radiologija')),
                    ],
                    onChanged: (value) {
                      specijalizacija = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Molimo odaberite specijalizaciju';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<Odjel>(
                    value: odabraniOdjel,
                    decoration: InputDecoration(
                      labelText: 'Odjel',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: const Icon(Icons.business),
                    ),
                    items: resultOdjel?.result
                        .map((odjel) => DropdownMenuItem(
                              value: odjel,
                              child: Text(odjel.naziv.toString()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        odabraniOdjel = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.naziv == "") {
                        return 'Molimo odaberite odjel';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      String korisnickoIme =
                          imeController.text.trim().toLowerCase();
                      String lozinka = '${imeController.text.trim()}123!';
                      lozinkaPotvrda = lozinka;
                      int? dob = _calculateAge(datumRodjenja!);
                      var noviDoktor = {
                        "ime": imeController.text.trim(),
                        "prezime": prezimeController.text.trim(),
                        "email": emailController.text.trim(),
                        "telefon": telefonController.text
                            .replaceAll(RegExp(r'[^0-9]'), '')
                            .trim(),
                        "spol": spol,
                        "datumRodjenja": datumRodjenja?.toIso8601String(),
                        "korisnickoIme": korisnickoIme,
                        "lozinka": lozinka,
                        "lozinkaPotvrda": lozinkaPotvrda,
                        "dob": dob,
                        "specijalizacija": specijalizacija,
                        "odjelId": odabraniOdjel!.odjelId
                      };

                      try {
                        await doktorProvider.insert(noviDoktor);
                        await Flushbar(
                                message: "Doktor je uspješno dodan",
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 3))
                            .show(context);
                        setState(() {});
                        _formKey.currentState?.reset();
                        await Future.wait([
                          Future.delayed(const Duration(seconds: 1)),
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DoktorListScreen()),
                          ),
                        ]);
                      } catch (e) {
                        await Flushbar(
                                message:
                                    "Došlo je do greške. Pokušajte ponovo.",
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 2))
                            .show(context);
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    "Dodaj doktora",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Zatvori'))
      ],
    );
  }
}
