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
  List<dynamic> vitalniParametri = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    vitalniParametriProvider = VitalniParametriProvider();
    if (widget.userType == "doktor") {
      _fetchVitalniParametri();
    }
  }

  Future<void> _fetchVitalniParametri() async {
    var filter = {
      "pacijentId": widget.pacijent!.pacijentId.toString(),
    };
    try {
      var data = await vitalniParametriProvider.get(filter: filter);
      setState(() {
        vitalniParametri = data.result;
        isLoading = false;
      });
    } catch (e) {
      print("Greška pri dohvaćanju podataka: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userType == "doktor") {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : vitalniParametri.isEmpty
                ? const Center(
                    child: Text(
                      "Nema dostupnih vitalnih parametara.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: vitalniParametri.length,
                    itemBuilder: (context, index) {
                      var parametar = vitalniParametri[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Datum: ${parametar.datumMjerenja.toString().split(' ')[0]}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    formattedTime(parametar.vrijemeMjerenja),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _parametarItem(Icons.favorite, "Otkucaji",
                                      "${parametar.otkucajSrca}/min"),
                                  _parametarItem(Icons.air, "Saturacija",
                                      "${parametar.saturacija}%"),
                                  _parametarItem(Icons.bloodtype, "Šećer",
                                      "${parametar.secer} mmol/L"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      );
    }
    return Card(
      margin: const EdgeInsets.all(20),
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
                            var now = DateTime.now();
                            var vitalniParametri = {
                              "pacijentId": widget.pacijent!.pacijentId,
                              "otkucajSrca":
                                  int.tryParse(otkucajSrcaController.text) ?? 0,
                              "saturacija":
                                  int.tryParse(saturacijaController.text) ?? 0,
                              "secer":
                                  double.tryParse(secerController.text) ?? 0.0,
                              "datumMjerenja": now.toIso8601String(),
                              "vrijemeMjerenja":
                                  "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}"
                            };
                            try {
                              await vitalniParametriProvider
                                  .insert(vitalniParametri);
                              if (mounted) {
                                Navigator.pop(context);
                              }
                              showCustomDialog(
                                  context: context,
                                  title: "",
                                  message:
                                      "Uspješno uneseni vitalni parametri za ${widget.pacijent!.korisnik!.ime} ${widget.pacijent!.korisnik!.prezime}",
                                  imagePath: "assets/images/success.png");
                            } catch (e) {
                              await Flushbar(
                                message:
                                    "Došlo je do greške. Pokušajte ponovo.",
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 2),
                              ).show(context);
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

  Widget _parametarItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blueGrey),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                )),
            Text(value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
      ],
    );
  }
}
