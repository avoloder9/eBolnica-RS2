import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/providers/otpusno_pismo_provider.dart';
import 'package:ebolnica_desktop/providers/terapija_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NovoOtpusnoPismoScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  final String? nazivOdjela;
  final int hospitalizacijaId;
  const NovoOtpusnoPismoScreen(
      {super.key,
      required this.userId,
      this.userType,
      this.nazivOdjela,
      required this.hospitalizacijaId});

  _NovoOtpusnoPismoScreenState createState() => _NovoOtpusnoPismoScreenState();
}

class _NovoOtpusnoPismoScreenState extends State<NovoOtpusnoPismoScreen> {
  late OtpusnoPismoProvider otpusnoPismoProvider;
  late TerapijaProvider terapijaProvider;

  TextEditingController dijagnozaController = TextEditingController();
  TextEditingController anamnezaController = TextEditingController();
  TextEditingController zakljucakController = TextEditingController();
  TextEditingController nazivTerapijeController = TextEditingController();
  TextEditingController opisTerapijeController = TextEditingController();

  bool prikaziTerapiju = false;
  DateTime? datumPocetka;
  DateTime? datumZavrsetka;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    otpusnoPismoProvider = OtpusnoPismoProvider();
    terapijaProvider = TerapijaProvider();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      title: const Center(
        child: Text(
          "Novo otpusno pismo",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField(dijagnozaController, "Dijagnoza"),
                    const SizedBox(height: 16),
                    _buildTextField(anamnezaController, "Anamneza"),
                    const SizedBox(height: 16),
                    _buildTextField(zakljucakController, "Zaključak"),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            prikaziTerapiju = !prikaziTerapiju;
                          });
                        },
                        icon: Icon(
                          prikaziTerapiju
                              ? Icons.remove_circle
                              : Icons.add_circle,
                          color: Colors.blueAccent,
                        ),
                        label: Text(
                          prikaziTerapiju
                              ? "Sakrij terapiju"
                              : "Dodaj terapiju",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    if (prikaziTerapiju) ...[
                      const SizedBox(height: 16),
                      _buildTextField(
                          nazivTerapijeController, "Naziv terapije"),
                      const SizedBox(height: 16),
                      _buildTextField(opisTerapijeController, "Opis terapije"),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDateSelector(
                              label: "Datum početka",
                              selectedDate: datumPocetka,
                              onTap: () async {
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2026),
                                );
                                if (picked != null) {
                                  setState(() {
                                    datumPocetka = picked;
                                    if (datumZavrsetka != null &&
                                        !datumZavrsetka!.isAfter(picked)) {
                                      datumZavrsetka = null;
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDateSelector(
                              label: "Datum završetka",
                              selectedDate: datumZavrsetka,
                              onTap: () async {
                                if (datumPocetka == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text("Prvo odaberite datum početka."),
                                    ),
                                  );
                                  return;
                                }
                                DateTime initialDate =
                                    datumPocetka!.add(const Duration(days: 1));
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: initialDate,
                                  firstDate: initialDate,
                                  lastDate: DateTime(2026),
                                );
                                if (picked != null) {
                                  setState(() {
                                    datumZavrsetka = picked;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Odustani")),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              try {
                int? terapijaId;
                if (prikaziTerapiju) {
                  var terapija = await terapijaProvider.insert({
                    "Naziv": nazivTerapijeController.text,
                    "Opis": opisTerapijeController.text,
                    "DatumPocetka": datumPocetka!.toIso8601String(),
                    "DatumZavrsetka": datumZavrsetka!.toIso8601String(),
                  });
                  terapijaId = terapija.terapijaId;
                }

                var otpusnoPismo = {
                  "HospitalizacijaId": widget.hospitalizacijaId,
                  "Dijagnoza": dijagnozaController.text,
                  "Anamneza": anamnezaController.text,
                  "Zakljucak": zakljucakController.text,
                  if (terapijaId != null) "TerapijaId": terapijaId
                };
                await otpusnoPismoProvider.insert(otpusnoPismo);

                await Flushbar(
                  message: "Otpusno pismo je uspješno kreirano",
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 3),
                ).show(context);
                await Future.delayed(const Duration(seconds: 1));
                Navigator.pop(context);
              } catch (e) {
                await Flushbar(
                  message: "Došlo je do greške. Pokušajte ponovo.",
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 2),
                ).show(context);
              }
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: const Text(
            "Sačuvaj",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}

Widget _buildTextField(TextEditingController controller, String label) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Ovo polje je obavezno';
      }
      return null;
    },
  );
}

Widget _buildDateSelector({
  required String label,
  required DateTime? selectedDate,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            selectedDate == null
                ? label
                : DateFormat('dd.MM.yyyy').format(selectedDate),
            style: TextStyle(
              fontSize: 16,
              color: selectedDate == null ? Colors.grey : Colors.black,
            ),
          ),
          const Icon(Icons.calendar_today, size: 20, color: Colors.blueGrey),
        ],
      ),
    ),
  );
}
