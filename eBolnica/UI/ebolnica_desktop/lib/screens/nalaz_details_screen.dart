import 'package:ebolnica_desktop/models/bolnica_model.dart';
import 'package:ebolnica_desktop/models/laboratorijski_nalaz_model.dart';
import 'package:ebolnica_desktop/models/nalaz_parametar_model.dart';
import 'package:ebolnica_desktop/providers/bolnica_provider.dart';
import 'package:ebolnica_desktop/providers/nalaz_parametar_provider.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class NalazDetaljiScreen extends StatefulWidget {
  final LaboratorijskiNalaz laboratorijskiNalaz;
  const NalazDetaljiScreen({super.key, required this.laboratorijskiNalaz});

  @override
  _NalazDetaljiScreenState createState() => _NalazDetaljiScreenState();
}

class _NalazDetaljiScreenState extends State<NalazDetaljiScreen> {
  String formattedDate(date) {
    final formatter = DateFormat('dd.MM.yyyy');
    return formatter.format(date);
  }

  List<NalazParametar>? parametri;
  late BolnicaProvider bolnicaProvider;
  late NalazParametarProvider nalazParametarProvider;
  Bolnica? bolnica;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    bolnicaProvider = BolnicaProvider();
    nalazParametarProvider = NalazParametarProvider();
    getBolnicaData();
    getNalazParametri();
  }

  Future<void> getNalazParametri() async {
    var result = await nalazParametarProvider.getNalazParametarValues(
        laboratorijskiNalazId:
            widget.laboratorijskiNalaz.laboratorijskiNalazId!);
    setState(() {
      parametri = result;
      isLoading = false;
    });
  }

  Future<void> getBolnicaData() async {
    var result = await bolnicaProvider.get();
    setState(() {
      bolnica = result.result.isNotEmpty ? result.result.first : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double dialogWidth = constraints.maxWidth * 0.95;

        return AlertDialog(
          contentPadding: const EdgeInsets.all(10.0),
          content: SizedBox(
            width: dialogWidth.clamp(400.0, 600.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Pacijent: ${widget.laboratorijskiNalaz.pacijent?.korisnik?.ime} "
                        "${widget.laboratorijskiNalaz.pacijent?.korisnik?.prezime} "
                        "(${formattedDate(widget.laboratorijskiNalaz.pacijent?.korisnik?.datumRodjenja)}, "
                        "${widget.laboratorijskiNalaz.pacijent?.korisnik?.spol})",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  buildRichText(
                      "Narucio",
                      "${widget.laboratorijskiNalaz.doktor?.korisnik?.ime} "
                          "${widget.laboratorijskiNalaz.doktor?.korisnik?.prezime}"),
                  buildRichText("Lokacija", "${bolnica?.adresa}"),
                  Row(
                    children: [
                      buildRichText("Ustanova", "${bolnica?.naziv}"),
                      const Spacer(),
                      buildRichText(
                          "Datum",
                          formattedDate(
                              widget.laboratorijskiNalaz.datumNalaza)),
                    ],
                  ),
                  const Divider(),
                  buildParametriTable(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildRichText(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "$label: ",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: value ?? "N/A",
                style: const TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildParametriTable() {
    if (parametri == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (parametri!.isEmpty) {
      return const Text("Nema podataka");
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(const Color(0xFFECEFF1)),
        columns: const [
          DataColumn(label: Text("Parametar")),
          DataColumn(label: Text("U ref. intervalu")),
          DataColumn(label: Text("Izdvojeni rezultat")),
          DataColumn(label: Text("Ref. interval")),
        ],
        rows: parametri!.map((parametar) {
          String refInterval =
              "${parametar.parametar?.minVrijednost ?? "N/A"} - ${parametar.parametar?.maxVrijednost ?? "N/A"}";
          String uRefIntervalu = "";
          String izdvojeniRezultat = "";
          bool isIzdvojeni = false;
          if (parametar.vrijednost != null &&
              parametar.parametar?.minVrijednost != null &&
              parametar.parametar?.maxVrijednost != null) {
            double vrijednost = parametar.vrijednost!;
            double min = parametar.parametar!.minVrijednost!;
            double max = parametar.parametar!.maxVrijednost!;

            if (vrijednost >= min && vrijednost <= max) {
              uRefIntervalu = vrijednost.toString();
            } else {
              izdvojeniRezultat = vrijednost.toString();
              isIzdvojeni = true;
            }
          }
          return DataRow(cells: [
            DataCell(Text(parametar.parametar?.naziv ?? "N/A")),
            DataCell(Center(child: Text(uRefIntervalu))),
            DataCell(
              Center(
                child: Text(
                  izdvojeniRezultat,
                  style: TextStyle(
                    color: isIzdvojeni ? Colors.red : Colors.black,
                    fontWeight:
                        isIzdvojeni ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
            DataCell(Center(child: Text(refInterval))),
          ]);
        }).toList(),
      ),
    );
  }
}
