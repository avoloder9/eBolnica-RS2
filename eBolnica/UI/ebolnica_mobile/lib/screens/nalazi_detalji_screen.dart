import 'package:ebolnica_mobile/models/bolnica_model.dart';
import 'package:ebolnica_mobile/models/hospitalizacija_model.dart';
import 'package:ebolnica_mobile/models/laboratorijski_nalaz_model.dart';
import 'package:ebolnica_mobile/models/nalaz_parametar_model.dart';
import 'package:ebolnica_mobile/providers/bolnica_provider.dart';
import 'package:ebolnica_mobile/providers/nalaz_parametar_provider.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class NalazDetaljiScreen extends StatefulWidget {
  final LaboratorijskiNalaz? laboratorijskiNalaz;
  final Hospitalizacija? hospizalizacija;
  const NalazDetaljiScreen(
      {super.key, this.laboratorijskiNalaz, this.hospizalizacija});

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
    int? laboratorijskiNalazId =
        widget.laboratorijskiNalaz?.laboratorijskiNalazId;
    int? hospitalizacijaId = widget.hospizalizacija?.hospitalizacijaId;

    if (laboratorijskiNalazId == null && hospitalizacijaId == null) {
      throw Exception("Mora biti proslijeđen barem jedan parametar!");
    }

    var result = await nalazParametarProvider.getNalazParametarValues(
      laboratorijskiNalazId: laboratorijskiNalazId,
      hospitalizacijaId: hospitalizacijaId,
    );

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalji", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        toolbarHeight: 60,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: buildParametriList(),
            ),
    );
  }

  Widget buildParametriList() {
    if (parametri == null || parametri!.isEmpty) {
      return const Center(child: Text("Nema podataka"));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: parametri!.length,
      itemBuilder: (context, index) {
        final param = parametri![index];
        double? value = param.vrijednost;
        double? min = param.parametar?.minVrijednost;
        double? max = param.parametar?.maxVrijednost;
        bool isIzdvojeni = false;
        String displayValue = "";
        if (value != null && min != null && max != null) {
          if (value >= min && value <= max) {
            displayValue = value.toString();
          } else {
            displayValue = value.toString();
            isIzdvojeni = true;
          }
        }
        String refInterval =
            "${param.parametar?.minVrijednost ?? "N/A"} - ${param.parametar?.maxVrijednost ?? "N/A"}";

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                param.parametar?.naziv ?? "N/A",
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    "Vrijednost: ",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    displayValue,
                    style: TextStyle(
                      color: isIzdvojeni ? Colors.red : Colors.black,
                      fontSize: 16,
                      fontWeight:
                          isIzdvojeni ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.info_outline, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    "Ref. interval: $refInterval",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
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
