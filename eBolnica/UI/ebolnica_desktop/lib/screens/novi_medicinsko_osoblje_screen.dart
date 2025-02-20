import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/models/odjel_model.dart';
import 'package:ebolnica_desktop/models/pacijent_model.dart';
import 'package:ebolnica_desktop/models/search_result.dart';
import 'package:ebolnica_desktop/providers/medicinsko_osoblje_provider.dart';
import 'package:ebolnica_desktop/providers/odjel_provider.dart';
import 'package:ebolnica_desktop/screens/medicinsko_osoblje_list_screen.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
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

  @override
  void initState() {
    super.initState();
    provider = MedicinskoOsobljeProvider();
    odjelProvider = OdjelProvider();
    fetchOdjeli();
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
                      var novoOsoblje = {
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
                        "odjelId": odabraniOdjel!.odjelId
                      };
                      print(novoOsoblje);
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
