import 'package:ebolnica_desktop/providers/laboratorijski_nalaz_provider.dart';
import 'package:flutter/material.dart';
import 'package:ebolnica_desktop/models/laboratorijski_nalaz_model.dart';
import 'package:ebolnica_desktop/models/parametar_model.dart';
import 'package:ebolnica_desktop/models/nalaz_parametar_model.dart';
import 'package:ebolnica_desktop/providers/parametar_provider.dart';
import 'package:ebolnica_desktop/providers/nalaz_parametar_provider.dart';
import 'package:another_flushbar/flushbar.dart';

class NalazParametarScreen extends StatefulWidget {
  final LaboratorijskiNalaz laboratorijskiNalaz;

  const NalazParametarScreen({super.key, required this.laboratorijskiNalaz});

  @override
  _NalazParametarScreenState createState() => _NalazParametarScreenState();
}

class _NalazParametarScreenState extends State<NalazParametarScreen> {
  late ParametarProvider parametarProvider;
  late NalazParametarProvider nalazParametarProvider;
  late LaboratorijskiNalazProvider laboratorijskiNalazProvider;
  List<Parametar> parametri = [];
  List<NalazParametar> dodaniParametri = [];

  @override
  void initState() {
    super.initState();
    parametarProvider = ParametarProvider();
    nalazParametarProvider = NalazParametarProvider();
    laboratorijskiNalazProvider = LaboratorijskiNalazProvider();
    fetchParametri();
  }

  Future<void> fetchParametri() async {
    var result = await parametarProvider.get();
    setState(() {
      parametri = result.result;
    });
  }

  void dodajParametar() {
    var preostaliParametri = dostupniParametri();
    if (preostaliParametri.isEmpty) return;

    setState(() {
      dodaniParametri.add(NalazParametar(
        laboratorijskiNalazId: widget.laboratorijskiNalaz.laboratorijskiNalazId,
        parametarId: null,
        vrijednost: null,
      ));
    });
  }

  Future<void> sacuvajNalaz() async {
    if (!isValid()) {
      await Flushbar(
        message: "Molimo popunite sva dostupna polja!",
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.grey,
      ).show(context);
      return;
    }
    try {
      if (widget.laboratorijskiNalaz.laboratorijskiNalazId == null ||
          widget.laboratorijskiNalaz.laboratorijskiNalazId == 0) {
        var nalaz = await laboratorijskiNalazProvider
            .insert(widget.laboratorijskiNalaz);
        widget.laboratorijskiNalaz.laboratorijskiNalazId =
            nalaz.laboratorijskiNalazId;
      }

      for (var nalazParametar in dodaniParametri) {
        nalazParametar.laboratorijskiNalazId =
            widget.laboratorijskiNalaz.laboratorijskiNalazId;
        await nalazParametarProvider.insert(nalazParametar);
      }
      await Flushbar(
        message: "Nalaz uspješno sačuvan!",
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green,
      ).show(context).then((_) {
        Navigator.pop(context, true);
      });
    } catch (e) {
      await Flushbar(
        message: "Došlo je do greške pri spašavanju podataka",
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
      ).show(context);
    }
  }

  bool isValid() {
    for (var parametar in dodaniParametri) {
      if (parametar.parametarId == null || parametar.vrijednost == null) {
        return false;
      }
    }
    return dodaniParametri.isNotEmpty;
  }

  List<Parametar> dostupniParametri() {
    return parametri
        .where((p) =>
            !dodaniParametri.any((dp) => dp.parametarId == p.parametarId))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dodaj parametre"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: dodaniParametri.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              value: dodaniParametri[index].parametarId,
                              decoration: const InputDecoration(
                                labelText: "Parametar",
                                border: OutlineInputBorder(),
                              ),
                              items: [
                                if (dodaniParametri[index].parametarId != null)
                                  DropdownMenuItem<int>(
                                    value: dodaniParametri[index].parametarId!,
                                    child: Text(
                                      parametri
                                          .firstWhere(
                                            (p) =>
                                                p.parametarId ==
                                                dodaniParametri[index]
                                                    .parametarId,
                                            orElse: () => Parametar(
                                                parametarId: 0,
                                                naziv: "Nepoznato"),
                                          )
                                          .naziv!,
                                    ),
                                  ),
                                ...dostupniParametri().map((parametar) {
                                  return DropdownMenuItem<int>(
                                    value: parametar.parametarId,
                                    child: Text(parametar.naziv!),
                                  );
                                }),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  dodaniParametri[index].parametarId = value;
                                });
                              },
                              validator: (value) =>
                                  value == null ? "Odaberite parametar" : null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Vrijednost",
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  dodaniParametri[index].vrijednost =
                                      double.tryParse(value);
                                });
                              },
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? "Unesite vrijednost"
                                      : null,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                dodaniParametri.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: dodajParametar,
                  icon: const Icon(Icons.add),
                  label: const Text("Dodaj parametar"),
                ),
                ElevatedButton(
                  onPressed: isValid() ? sacuvajNalaz : null,
                  child: const Text("Sačuvaj"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
