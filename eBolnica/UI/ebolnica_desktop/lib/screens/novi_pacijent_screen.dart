import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/models/pacijent_model.dart';
import 'package:ebolnica_desktop/models/search_result.dart';
import 'package:ebolnica_desktop/providers/korisnik_provider.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';
import 'package:ebolnica_desktop/screens/pacijent_list_screen.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
import 'package:ebolnica_desktop/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoviPacijentScreen extends StatefulWidget {
  final int userId;
  final String? userType;

  const NoviPacijentScreen({super.key, required this.userId, this.userType});

  @override
  _NoviPacijentScreenState createState() => _NoviPacijentScreenState();
}

class _NoviPacijentScreenState extends State<NoviPacijentScreen> {
  final _formKey = GlobalKey<FormState>();
  final imeController = TextEditingController();
  final prezimeController = TextEditingController();
  final emailController = TextEditingController();
  final korisnickoImeController = TextEditingController();
  final telefonController = TextEditingController();
  final adresaController = TextEditingController();
  final datumController = TextEditingController();
  SearchResult<Pacijent>? result;
  late KorisnikProvider korisnikProvider;
  String? _emailError;
  String? _korisnickoImeError;

  String spol = '';
  DateTime? datumRodjenja;
  String lozinkaPotvrda = '';
  late PacijentProvider provider;

  @override
  void initState() {
    super.initState();
    provider = PacijentProvider();
    korisnikProvider = KorisnikProvider();
  }

  Future<String?> validirajEmail(
      String? value, KorisnikProvider korisnikProvider) async {
    if (value == null || value.isEmpty) {
      return 'Email je obavezan';
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value)) {
      return 'Molimo unesite validan email';
    }
    try {
      bool postoji = await korisnikProvider.provjeriEmail(value);
      if (postoji) {
        return 'Email je već u upotrebi';
      }
    } catch (e) {
      return 'Greška pri provjeri emaila: ${e.toString()}';
    }

    return null;
  }

  Future<String?> validirajKorisnickoIme(
      String? value, KorisnikProvider korisnikProvider) async {
    if (value == null || value.isEmpty) {
      return 'Korisničko ime je obavezno';
    }

    try {
      bool postoji = await korisnikProvider.provjeriKorisnickoIme(value);
      if (postoji) {
        return 'Korisničko ime je već zauzeto';
      }
    } catch (e) {
      return 'Greška pri provjeri korisničkog imena: ${e.toString()}';
    }

    return null;
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

  void _onEmailChanged(String value) async {
    _emailError = await validirajEmail(value, korisnikProvider);
    setState(() {});
  }

  void _onKorisnickoImeChanged(String value) async {
    _korisnickoImeError = await validirajKorisnickoIme(value, korisnikProvider);
    setState(() {});
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
                    validator: (value) => generalValidator(
                        value, 'ime', [notEmpty, startsWithCapital]),
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
                    validator: (value) => generalValidator(
                        value, 'prezime', [notEmpty, startsWithCapital]),
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
                        errorText: _emailError),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Molimo unesite email';
                      }
                      return _emailError;
                    },
                    onChanged: _onEmailChanged,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: korisnickoImeController,
                    decoration: InputDecoration(
                        labelText: 'Korisnicko ime',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: const Icon(Icons.account_circle),
                        errorText: _korisnickoImeError),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Molimo unesite korisnicko ime';
                      }
                      return _korisnickoImeError;
                    },
                    onChanged: _onKorisnickoImeChanged,
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
                    maxLength: 11,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      PhoneNumberFormatter()
                    ],
                    validator: (value) => generalValidator(value, 'telefon', [
                      notEmpty,
                    ]),
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
                    validator: (value) => dropdownValidator(value, 'spol'),
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
                    validator: (value) =>
                        generalValidator(value, 'adresu', [notEmpty]),
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
                        validator: (value) =>
                            dateValidator(datumRodjenja, 'datum rođenja'),
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
                      String lozinka = 'Pacijent123!';
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
                        "korisnickoIme": korisnickoImeController.text.trim(),
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
                                      userType: widget.userType,
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
