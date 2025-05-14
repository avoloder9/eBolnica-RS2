import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/models/doktor_model.dart';
import 'package:ebolnica_desktop/models/odjel_model.dart';
import 'package:ebolnica_desktop/models/search_result.dart';
import 'package:ebolnica_desktop/providers/doktor_provider.dart';
import 'package:ebolnica_desktop/providers/korisnik_provider.dart';
import 'package:ebolnica_desktop/providers/odjel_provider.dart';
import 'package:ebolnica_desktop/screens/doktor_list_screen.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
import 'package:ebolnica_desktop/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoviDoktorScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  const NoviDoktorScreen({super.key, required this.userId, this.userType});
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
  final korisnickoImeController = TextEditingController();
  final specijalizacijaController = TextEditingController();
  SearchResult<Doktor>? resultDoktor;
  SearchResult<Odjel>? resultOdjel;
  late KorisnikProvider korisnikProvider;
  String? _emailError;
  String? _korisnickoImeError;

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
    korisnikProvider = KorisnikProvider();
    odjelProvider = OdjelProvider();
    fetchOdjeli();
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

  void _onEmailChanged(String value) async {
    _emailError = await validirajEmail(value, korisnikProvider);
    setState(() {});
  }

  void _onKorisnickoImeChanged(String value) async {
    _korisnickoImeError = await validirajKorisnickoIme(value, korisnikProvider);
    setState(() {});
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
      setState(() {
        resultOdjel = fetchedResult;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Greška pri učitavanju odjela')),
      );
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
                          borderRadius: BorderRadius.circular(10.0)),
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
                          borderRadius: BorderRadius.circular(10.0)),
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
                          borderRadius: BorderRadius.circular(10.0)),
                      prefixIcon: const Icon(Icons.phone),
                      counterText: '',
                    ),
                    keyboardType: TextInputType.phone,
                    maxLength: 11,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      PhoneNumberFormatter()
                    ],
                    validator: (value) =>
                        generalValidator(value, 'telefon', [notEmpty]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<String>(
                    value: spol.isEmpty ? null : spol,
                    decoration: InputDecoration(
                      labelText: 'Spol',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
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
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        controller: datumController,
                        validator: (value) =>
                            dateValidator(datumRodjenja, 'datum rođenja'),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: specijalizacijaController,
                    decoration: InputDecoration(
                      labelText: 'Specijalizacija',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      prefixIcon: const Icon(Icons.medical_services_outlined),
                    ),
                    validator: (value) => generalValidator(value,
                        'specijalizaciju', [notEmpty, startsWithCapital]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<Odjel>(
                    value: odabraniOdjel,
                    decoration: InputDecoration(
                      labelText: 'Odjel',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
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
                    validator: (value) =>
                        dropdownValidator(value?.naziv, 'odjel'),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      String lozinka = 'Doktor123!';
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
                        "korisnickoIme": korisnickoImeController.text.trim(),
                        "lozinka": lozinka,
                        "lozinkaPotvrda": lozinkaPotvrda,
                        "dob": dob,
                        "specijalizacija": specijalizacijaController.text,
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
                                builder: (context) => DoktorListScreen(
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
