import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/models/parametar_model.dart';
import 'package:ebolnica_desktop/models/search_result.dart';
import 'package:ebolnica_desktop/providers/parametar_provider.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
import 'package:ebolnica_desktop/utils/validator.dart';
import 'package:flutter/material.dart';

class ParametriListScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  const ParametriListScreen({super.key, required this.userId, this.userType});

  @override
  _ParametriListScreenState createState() => _ParametriListScreenState();
}

class _ParametriListScreenState extends State<ParametriListScreen> {
  SearchResult<Parametar>? parametri;
  late ParametarProvider parametarProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parametri"),
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            onPressed: () {
              addParametarDialog();
            },
            label: const Text("Dodaj novi parametar",
                style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      drawer: SideBar(userType: widget.userType!, userId: widget.userId),
      body: Column(
        children: [_buildResultView()],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    parametarProvider = ParametarProvider();
    fetchParametri();
  }

  Future<void> fetchParametri() async {
    parametri = await parametarProvider.get();
    setState(() {});
  }

  Widget _buildResultView() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: DataTable(
            columns: const [
              DataColumn(
                  label: Text("Naziv",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black))),
              DataColumn(
                  label: Text("Minimalna vrijednost",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black))),
              DataColumn(
                  label: Text("Maksimalna vrijednost",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black))),
              DataColumn(label: Text("")),
            ],
            rows: parametri?.result
                    .map<DataRow>((e) => DataRow(
                          cells: [
                            DataCell(Text(e.naziv.toString(),
                                style: const TextStyle(fontSize: 16))),
                            DataCell(Text(e.minVrijednost.toString(),
                                style: const TextStyle(fontSize: 16))),
                            DataCell(Text(e.maxVrijednost.toString(),
                                style: const TextStyle(fontSize: 16))),
                            DataCell(ElevatedButton.icon(
                              icon: const Icon(Icons.delete),
                              label: const Text("Ukloni parametar"),
                              onPressed: () async {
                                showCustomDialog(
                                  context: context,
                                  title: "Obrisati parametar?",
                                  message:
                                      "Da li ste sigurni da želite ukloniti parametar",
                                  confirmText: "Da",
                                  onConfirm: () async {
                                    try {
                                      await parametarProvider
                                          .delete(e.parametarId!);
                                      await Flushbar(
                                        message:
                                            "Parametar je uspješno uklonjen!",
                                        duration: const Duration(seconds: 3),
                                        backgroundColor: Colors.green,
                                      ).show(context);
                                    } catch (error) {
                                      await Flushbar(
                                        message:
                                            "Došlo je do greške prilikom uklanjanja parametra.",
                                        duration: const Duration(seconds: 3),
                                        backgroundColor: Colors.red,
                                      ).show(context);
                                    }
                                    fetchParametri();
                                  },
                                );
                              },
                            )),
                          ],
                        ))
                    .toList() ??
                [],
          ),
        ),
      ),
    );
  }

  final TextEditingController _nazivController = TextEditingController();
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();

  void addParametarDialog() {
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Dodaj novi parametar",
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nazivController,
                    decoration: InputDecoration(
                      labelText: "Naziv",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) =>
                        generalValidator(value, 'naziv', [notEmpty]),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _minController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: "Minimalna vrijednost",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) {
                      final number = double.tryParse(value ?? "");
                      if (value == null || value.isEmpty) {
                        return "Unesite vrijednost";
                      }
                      if (number == null) return "Unesite broj (npr. 3.5)";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _maxController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: "Maksimalna vrijednost",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) {
                      final number = double.tryParse(value ?? "");
                      if (value == null || value.isEmpty) {
                        return "Unesite vrijednost";
                      }
                      if (number == null) return "Unesite broj (npr. 7.8)";
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          actions: [
            TextButton(
              onPressed: () {
                _nazivController.text = "";
                _minController.text = "";
                _maxController.text = "";
                Navigator.pop(context);
              },
              child: const Text("Odustani"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text("Spremi"),
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                final naziv = _nazivController.text.trim();
                final min = double.parse(_minController.text.trim());
                final max = double.parse(_maxController.text.trim());

                if (min > max) {
                  Navigator.pop(context);
                  await Flushbar(
                    message:
                        "Minimalna vrijednost ne može biti veća od maksimalne.",
                    duration: const Duration(seconds: 3),
                    backgroundColor: Colors.red.shade400,
                    icon: const Icon(Icons.error_outline, color: Colors.white),
                  ).show(context);
                  return;
                }

                try {
                  await parametarProvider.insert({
                    'naziv': naziv,
                    'minVrijednost': min,
                    'maxVrijednost': max,
                  });
                  Navigator.pop(context);
                  await Flushbar(
                    message: "Parametar uspješno dodan!",
                    duration: const Duration(seconds: 3),
                    backgroundColor: Colors.green.shade600,
                  ).show(context);

                  fetchParametri();

                  _nazivController.clear();
                  _minController.clear();
                  _maxController.clear();
                } catch (e) {
                  Navigator.pop(context);

                  await Flushbar(
                    message: "Greška pri dodavanju parametra.",
                    duration: const Duration(seconds: 3),
                    backgroundColor: Colors.red.shade600,
                    icon: const Icon(Icons.error, color: Colors.white),
                  ).show(context);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
