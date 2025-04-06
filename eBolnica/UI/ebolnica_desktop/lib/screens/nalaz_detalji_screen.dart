import 'package:ebolnica_desktop/models/bolnica_model.dart';
import 'package:ebolnica_desktop/models/laboratorijski_nalaz_model.dart';
import 'package:ebolnica_desktop/models/nalaz_parametar_model.dart';
import 'package:ebolnica_desktop/providers/bolnica_provider.dart';
import 'package:ebolnica_desktop/providers/nalaz_parametar_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
                  ElevatedButton.icon(
                    onPressed: isLoading ? null : _printNalaz,
                    icon: const Icon(Icons.print),
                    label: const Text("Printaj i preuzmi"),
                  ),
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

  Future<void> _printNalaz() async {
    final pdf = pw.Document();

    final pacijent = widget.laboratorijskiNalaz.pacijent?.korisnik;
    final doktor = widget.laboratorijskiNalaz.doktor?.korisnik;

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Text('Laboratorijski nalaz', style: pw.TextStyle(fontSize: 24)),
          pw.SizedBox(height: 16),
          pw.Text(
            'Pacijent: ${pacijent?.ime ?? ""} ${pacijent?.prezime ?? ""} '
            '(${formattedDate(pacijent?.datumRodjenja)}, ${pacijent?.spol})',
          ),
          pw.Text(
            'Doktor: ${doktor?.ime ?? ""} ${doktor?.prezime ?? ""}',
          ),
          pw.Text(
              'Datum nalaza: ${formattedDate(widget.laboratorijskiNalaz.datumNalaza)}'),
          if (bolnica != null) ...[
            pw.Text('Ustanova: ${bolnica!.naziv}'),
            pw.Text('Adresa: ${bolnica!.adresa}'),
          ],
          pw.SizedBox(height: 16),
          pw.Table.fromTextArray(
            headers: [
              'Parametar',
              'U ref. intervalu',
              'Izdvojeni rezultat',
              'Ref. interval'
            ],
            data: parametri?.map((parametar) {
                  final vrijednost = parametar.vrijednost;
                  final min = parametar.parametar?.minVrijednost;
                  final max = parametar.parametar?.maxVrijednost;
                  String refInterval = "${min ?? "N/A"} - ${max ?? "N/A"}";
                  String uRefIntervalu = "";
                  String izdvojeniRezultat = "";

                  if (vrijednost != null && min != null && max != null) {
                    if (vrijednost >= min && vrijednost <= max) {
                      uRefIntervalu = vrijednost.toString();
                    } else {
                      izdvojeniRezultat = vrijednost.toString();
                    }
                  }

                  return [
                    parametar.parametar?.naziv ?? "N/A",
                    uRefIntervalu,
                    izdvojeniRezultat,
                    refInterval,
                  ];
                }).toList() ??
                [],
          )
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
