import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_mobile/models/pacijent_model.dart';
import 'package:ebolnica_mobile/providers/vitalni_parametri_provider.dart';
import 'package:ebolnica_mobile/utils/utils.dart';
import 'package:flutter/material.dart';

class VitalniParametriScreen extends StatefulWidget {
  final Pacijent? pacijent;
  final int userId;
  final String? userType;

  const VitalniParametriScreen(
      {super.key, required this.userId, this.pacijent, this.userType});
  @override
  _VitalniParametriScreenState createState() => _VitalniParametriScreenState();
}

class _VitalniParametriScreenState extends State<VitalniParametriScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController otkucajSrcaController = TextEditingController();
  final TextEditingController saturacijaController = TextEditingController();
  final TextEditingController secerController = TextEditingController();
  late VitalniParametriProvider vitalniParametriProvider;
  @override
  void initState() {
    super.initState();
    vitalniParametriProvider = VitalniParametriProvider();
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Otkucaj Srca',
                    hintText: 'Unesite broj otkucaja srca',
                    border: OutlineInputBorder(),
                  ),
                  controller: otkucajSrcaController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Molimo unesite otkucaje srca';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Saturacija',
                    hintText: 'Unesite razinu saturacije',
                    border: OutlineInputBorder(),
                  ),
                  controller: saturacijaController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Molimo unesite vrijednost saturacije';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Šećer',
                    hintText: 'Unesite razinu šećera',
                    border: OutlineInputBorder(),
                  ),
                  controller: secerController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Molimo unesite razinu secera';
                    }
                    return null;
                  },
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Odustani"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            var vitalniParametri = {
                              "pacijentId": widget.pacijent!.pacijentId,
                              "otkucajSrca": otkucajSrcaController.text,
                              "saturacija": saturacijaController.text,
                              "secer": secerController.text,
                              "datumMjerenja": DateTime.now().toIso8601String()
                            };
                            try {
                              await vitalniParametriProvider
                                  .insert(vitalniParametri);
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );
                              await Future.delayed(const Duration(seconds: 1));
                              if (mounted) {
                                Navigator.pop(context);
                              }
                              showCustomDialog(
                                  context: context,
                                  title: "",
                                  message:
                                      "Uspješno uneseni vitalni parametri za ${widget.pacijent!.korisnik!.ime} ${widget.pacijent!.korisnik!.prezime}",
                                  imagePath: "assets/images/success.png");
                              await Future.delayed(const Duration(seconds: 2));
                              if (mounted) {
                                Navigator.pop(context);
                              }
                            } catch (e) {
                              await Flushbar(
                                message:
                                    "Došlo je do greške. Pokušajte ponovo.",
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 2),
                              ).show(context);
                            }
                            if (mounted) {
                              Navigator.pop(context);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Spremi'),
                      )
                    ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
