import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/models/pacijent_model.dart';
import 'package:ebolnica_desktop/models/search_result.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';
import 'package:ebolnica_desktop/screens/pacijent_list_screen.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoviPacijentScreen extends StatefulWidget {
  final int userId;

  const NoviPacijentScreen({super.key, required this.userId});

  @override
  _NoviPacijentScreenState createState() => _NoviPacijentScreenState();
}

class _NoviPacijentScreenState extends State<NoviPacijentScreen> {
  final _formKey = GlobalKey<FormState>();
  final imeController = TextEditingController();
  final prezimeController = TextEditingController();
  final emailController = TextEditingController();
  final telefonController = TextEditingController();
  final adresaController = TextEditingController();
  final datumController = TextEditingController();
  SearchResult<Pacijent>? result;

  String spol = '';
  DateTime? datumRodjenja;
  String lozinkaPotvrda = '';
  late PacijentProvider provider;

  @override
  void initState() {
    super.initState();
    provider = PacijentProvider();
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

  int _generateHealthCardNumber() {
    Random random = Random();
    return 10000 + random.nextInt(90000);
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: adresaController,
                    decoration: InputDecoration(
                      labelText: 'Adresa',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: const Icon(Icons.home),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Molimo unesite adresu';
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
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      String korisnickoIme =
                          imeController.text.trim().toLowerCase();
                      String lozinka = '${imeController.text.trim()}123!';
                      lozinkaPotvrda = lozinka;
                      int? dob = _calculateAge(datumRodjenja!);
                      var noviPacijent = {
                        "ime": imeController.text.trim(),
                        "prezime": prezimeController.text.trim(),
                        "email": emailController.text.trim(),
                        "telefon": telefonController.text
                            .replaceAll(RegExp(r'[^0-9]'), '')
                            .trim(),
                        "adresa": adresaController.text.trim(),
                        "spol": spol,
                        "datumRodjenja": datumRodjenja?.toIso8601String(),
                        "korisnickoIme": korisnickoIme,
                        "lozinka": lozinka,
                        "lozinkaPotvrda": lozinkaPotvrda,
                        "brojZdravstveneKartice": _generateHealthCardNumber(),
                        "dob": dob
                      };
                      try {
                        await provider.insert(noviPacijent);
                        await Flushbar(
                                message: "Pacijent je uspješno dodan",
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
                                builder: (context) => PacijentListScreen(
                                      userId: widget.userId,
                                    )),
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
                  child: const SizedBox(
                    width: 140,
                    child: Center(
                      child: Text(
                        'Dodaj Pacijenta',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
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
