import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/models/bolnica_model.dart';
import 'package:ebolnica_desktop/models/odjel_model.dart';
import 'package:ebolnica_desktop/models/search_result.dart';
import 'package:ebolnica_desktop/providers/bolnica_provider.dart';
import 'package:ebolnica_desktop/providers/odjel_provider.dart';
import 'package:ebolnica_desktop/screens/odjel_list_screen.dart';
import 'package:flutter/material.dart';

class NoviOdjelScreen extends StatefulWidget {
  const NoviOdjelScreen({super.key});

  @override
  _NoviOdjelScreenState createState() => _NoviOdjelScreenState();
}

class _NoviOdjelScreenState extends State<NoviOdjelScreen> {
  late OdjelProvider odjelProvider;
  late BolnicaProvider bolnicaProvider;
  SearchResult<Bolnica>? resultBolnica;
  SearchResult<Odjel>? resultOdjel;
  Bolnica? odabranaBolnica;
  final _formKey = GlobalKey<FormState>();
  final nazivController = TextEditingController();
  final bolnicaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    odjelProvider = OdjelProvider();
    bolnicaProvider = BolnicaProvider();
    fetchBolnicu();
  }

  Future<void> fetchBolnicu() async {
    try {
      SearchResult<Bolnica> fetchedResult = await bolnicaProvider.get();
      setState(() {
        resultBolnica = fetchedResult;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      title: const Center(
        child: Text(
          'Dodaj novi odjel',
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
                    controller: nazivController,
                    decoration: InputDecoration(
                      labelText: 'Naziv',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Molimo unesite naziv';
                      }
                      if (value[0] != value[0].toUpperCase()) {
                        return 'Naziv mora početi sa velikim slovom';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<Bolnica>(
                    value: odabranaBolnica,
                    decoration: InputDecoration(
                      labelText: 'Bolnica',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: const Icon(Icons.local_hospital),
                    ),
                    items: resultBolnica?.result
                        .map((bolnica) => DropdownMenuItem(
                              value: bolnica,
                              child: Text(bolnica.naziv.toString()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        odabranaBolnica = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.naziv == "") {
                        return 'Molimo odaberite bolnicu';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      var noviOdjel = {
                        "naziv": nazivController.text.trim(),
                        "bolnicaId": odabranaBolnica!.bolnicaId
                      };

                      try {
                        await odjelProvider.insert(noviOdjel);
                        await Flushbar(
                                message: "Odjel je uspješno dodan",
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
                                builder: (context) => const OdjelListScreen()),
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
                    "Dodaj odjel",
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
