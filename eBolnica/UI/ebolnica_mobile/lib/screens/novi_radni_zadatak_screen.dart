import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_mobile/models/hospitalizacija_model.dart';
import 'package:ebolnica_mobile/models/medicinsko_osoblje_model.dart';
import 'package:ebolnica_mobile/models/pacijent_model.dart';
import 'package:ebolnica_mobile/models/search_result.dart';
import 'package:ebolnica_mobile/providers/hospitalizacija_provider.dart';
import 'package:ebolnica_mobile/providers/medicinsko_osoblje_provider.dart';
import 'package:ebolnica_mobile/providers/pacijent_provider.dart';
import 'package:ebolnica_mobile/providers/radni_zadatak_provider.dart';

import 'package:ebolnica_mobile/utils/utils.dart';
import 'package:flutter/material.dart';

class NoviRadniZadatakScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  final int doktorId;
  final String? nazivOdjela;
  const NoviRadniZadatakScreen(
      {super.key,
      required this.userId,
      required this.doktorId,
      this.userType,
      this.nazivOdjela});

  @override
  _NoviRadniZadatakScreenState createState() => _NoviRadniZadatakScreenState();
}

class _NoviRadniZadatakScreenState extends State<NoviRadniZadatakScreen> {
  final _formKey = GlobalKey<FormState>();
  late PacijentProvider pacijentProvider;
  late HospitalizacijaProvider hospitalizacijaProvider;
  late RadniZadatakProvider radniZadatakProvider;
  SearchResult<Hospitalizacija>? hospitalizacije;
  late MedicinskoOsobljeProvider medicinskoOsobljeProvider;
  List<Pacijent> pacijenti = [];
  List<MedicinskoOsoblje> medicinskoOsoblje = [];
  Pacijent? odabraniPacijent;
  MedicinskoOsoblje? odabranoOsoblje;
  TextEditingController opisController = TextEditingController();
  void fetchPacijente() async {
    try {
      var result = await hospitalizacijaProvider
          .get(filter: {'nazivOdjela': widget.nazivOdjela});

      setState(() {
        hospitalizacije = result;
        pacijenti = hospitalizacije?.result
                .map((hospitalizacija) => hospitalizacija.pacijent)
                .where((pacijent) => pacijent != null)
                .cast<Pacijent>()
                .toList() ??
            [];
      });
    } catch (e) {
      print("Greška prilikom dohvaćanja pacijenata: $e");
    }
  }

  void fetchOsoblje() async {
    var result = await medicinskoOsobljeProvider
        .get(filter: {'nazivOdjela': widget.nazivOdjela});
    setState(() {
      medicinskoOsoblje = result.result;
    });
  }

  @override
  void initState() {
    super.initState();
    pacijentProvider = PacijentProvider();
    hospitalizacijaProvider = HospitalizacijaProvider();
    medicinskoOsobljeProvider = MedicinskoOsobljeProvider();
    radniZadatakProvider = RadniZadatakProvider();
    fetchPacijente();
    fetchOsoblje();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
              child: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text(
                "Novi termin",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildDropdown<Pacijent>(
                label: "Pacijent",
                icon: Icons.person,
                value: odabraniPacijent,
                items: pacijenti
                    .map((pacijent) => DropdownMenuItem(
                          value: pacijent,
                          child: Text(
                              "${pacijent.korisnik!.ime} ${pacijent.korisnik!.prezime}"),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => odabraniPacijent = value),
              ),
              _buildDropdown<MedicinskoOsoblje>(
                label: "Medicinsko osoblje",
                icon: Icons.person,
                value: odabranoOsoblje,
                items: medicinskoOsoblje
                    .map((osoblje) => DropdownMenuItem(
                          value: osoblje,
                          child: Text(
                              "${osoblje.korisnik!.ime} ${osoblje.korisnik!.prezime}"),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => odabranoOsoblje = value),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Opis',
                  hintText: 'Unesite opis zadatka',
                  border: OutlineInputBorder(),
                ),
                controller: opisController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Molimo unesite opis zadatka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Odustani"),
                  ),
                  ElevatedButton(
                    onPressed: _dodajZadatak,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text("Sačuvaj",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              )
            ]),
          )),
        ));
  }

  Widget _buildDropdown<T>({
    required String label,
    required IconData icon,
    required T? value,
    required List<DropdownMenuItem<T>>? items,
    required void Function(T?)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: _inputDecoration(label, icon),
        items: items,
        onChanged: onChanged,
        validator: (value) => value == null ? 'Odaberite $label' : null,
      ),
    );
  }

  Future<void> _dodajZadatak() async {
    if (_formKey.currentState?.validate() ?? false) {
      var noviZadatak = {
        "doktorId": widget.doktorId,
        "pacijentId": odabraniPacijent!.pacijentId,
        "medicinskoOsobljeId": odabranoOsoblje!.medicinskoOsobljeId,
        "opis": opisController.text,
        "datumZadatka": DateTime.now().toIso8601String(),
        "status": true
      };

      try {
        await radniZadatakProvider.insert(noviZadatak);
        if (!mounted) return;
        showCustomDialog(
            context: context,
            title: "",
            message: "Uspješno kreiran novi radni zadatak",
            imagePath: "assets/images/success.png");
        await Future.delayed(const Duration(seconds: 2));
      } catch (e) {
        await Flushbar(
          message: "Došlo je do greške. Pokušajte ponovo.",
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ).show(context);
      } finally {
        if (mounted) {
          Navigator.pop(context, true);
        }
      }
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      prefixIcon: Icon(icon),
    );
  }
}
