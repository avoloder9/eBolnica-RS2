import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/models/odjel_model.dart';
import 'package:ebolnica_desktop/models/pacijent_model.dart';
import 'package:ebolnica_desktop/models/search_result.dart';
import 'package:ebolnica_desktop/providers/korisnik_provider.dart';
import 'package:ebolnica_desktop/providers/medicinsko_osoblje_provider.dart';
import 'package:ebolnica_desktop/providers/odjel_provider.dart';
import 'package:ebolnica_desktop/screens/medicinsko_osoblje_list_screen.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
import 'package:ebolnica_desktop/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoviMedicinskoOsobljeScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  const NoviMedicinskoOsobljeScreen(
      {super.key, required this.userId, this.userType});

  @override
  _NoviMedicinskoOsobljeScreenState createState() =>
      _NoviMedicinskoOsobljeScreenState();
}

class _NoviMedicinskoOsobljeScreenState
    extends State<NoviMedicinskoOsobljeScreen> {
  final _formKey = GlobalKey<FormState>();
  final imeController = TextEditingController();
  final prezimeController = TextEditingController();
  final emailController = TextEditingController();
  final telefonController = TextEditingController();
  final odjelController = TextEditingController();
  final korisnickoImeController = TextEditingController();
  final datumController = TextEditingController();
  SearchResult<Pacijent>? result;
  SearchResult<Odjel>? resultOdjel;
  Odjel? odabraniOdjel;
  List<String> odjeli = [];
  String spol = '';
  DateTime? datumRodjenja;
  String lozinkaPotvrda = '';
  late MedicinskoOsobljeProvider provider;
  late OdjelProvider odjelProvider;
  String? _emailError;
  String? _korisnickoImeError;
  late KorisnikProvider korisnikProvider;
  @override
  void initState() {
    super.initState();
    provider = MedicinskoOsobljeProvider();
    odjelProvider = OdjelProvider();
    korisnikProvider = KorisnikProvider();
    fetchOdjeli();
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

  Future<void> fetchOdjeli() async {
    try {
      SearchResult<Odjel> fetchedResult = await odjelProvider.get();
      setState(() {
        resultOdjel = fetchedResult;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Greška pri dohvaćanju odjela')),
      );
    }
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
          'Novo medicinsko osoblje',
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
                    validator: (value) =>
                        dropdownValidator(value?.naziv, 'odjel'),
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
                      String lozinka = 'Osoblje123!';
                      lozinkaPotvrda = lozinka;
                      var novoOsoblje = {
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
                        "odjelId": odabraniOdjel!.odjelId
                      };
                      try {
                        await provider.insert(novoOsoblje);
                        await Flushbar(
                                message:
                                    "Medicinsko osoblje je uspješno dodano",
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
                                builder: (context) =>
                                    MedicinskoOsobljeListScreen(
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
                    width: 240,
                    child: Center(
                      child: Text(
                        'Dodaj medicinsko osoblje',
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
