import 'dart:io';
import 'package:ebolnica_desktop/models/Response/broj_pacijenata_response.dart';
import 'package:ebolnica_desktop/models/Response/broj_zaposlenih_po_odjelu_response.dart';
import 'package:ebolnica_desktop/models/Response/dashboard_response.dart';
import 'package:ebolnica_desktop/models/termin_model.dart';
import 'package:ebolnica_desktop/providers/administrator_provider.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';
import 'package:ebolnica_desktop/providers/termin_provider.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:ebolnica_desktop/models/Response/popunjenost_bolnice_response.dart';
import 'package:ebolnica_desktop/providers/krevet_provider.dart';
import 'package:ebolnica_desktop/providers/odjel_provider.dart';
import 'side_bar.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

class DashboardAdmin extends StatefulWidget {
  final int userId;
  final String? userType;

  const DashboardAdmin({super.key, required this.userId, this.userType});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  late TerminProvider terminProvider;
  List<Termin>? termini;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Administrator')),
      drawer: SideBar(userType: widget.userType!, userId: widget.userId),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final popunjenost =
                            await KrevetProvider().getPopunjenostBolnice();
                        final zaposleni = await OdjelProvider()
                            .getUkupanBrojZaposlenihPoOdjelima();
                        final pacijenti =
                            await PacijentProvider().getBrojPacijenata();
                        final dashboardData =
                            await AdministratorProvider().getDashboardData();
                        _generateAndPrintReport(popunjenost, zaposleni,
                            pacijenti, dashboardData[0]);
                      } catch (e) {
                        print("Greška prilikom generisanja izvještaja: $e");
                      }
                    },
                    child: const Text(
                      "Generiši izvještaj",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildAdminDashboard(),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      height: 450,
                      margin: const EdgeInsets.only(right: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _buildTerminiStackedBarChart(),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 450,
                      margin: const EdgeInsets.only(left: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _buildTermini(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    terminProvider = TerminProvider();
    fetchTermini();
  }

  Future<void> fetchTermini() async {
    setState(() {
      termini = [];
    });
    var result = await terminProvider.get();
    setState(() {
      termini = result.result;
    });
  }

  Widget _buildTermini() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Center(
            child: Text(
              'Zakazani termini',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.blueGrey[600],
              ),
            ),
          ),
        ),
        Container(
          color: Colors.blueGrey[50],
          child: Table(
            border: TableBorder.symmetric(
              inside: BorderSide(color: Colors.grey.shade300, width: 0.5),
              outside: BorderSide(color: Colors.grey.shade300, width: 0.5),
            ),
            children: [
              TableRow(
                children: [
                  _tableHeader("Pacijent"),
                  _tableHeader("Doktor"),
                  _tableHeader("Datum"),
                  _tableHeader("Vrijeme"),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...termini?.map((termin) {
                      return Container(
                        color: Colors.white,
                        child: Table(
                          border: TableBorder.symmetric(
                            inside: BorderSide(
                                color: Colors.grey.shade300, width: 0.5),
                            outside: BorderSide(
                                color: Colors.grey.shade300, width: 0.5),
                          ),
                          children: [
                            TableRow(
                              children: [
                                _tableCell(
                                    "${termin.pacijent?.korisnik?.ime ?? ''} ${termin.pacijent?.korisnik?.prezime ?? ''}"),
                                _tableCell(
                                    "${termin.doktor?.korisnik?.ime ?? ''} ${termin.doktor?.korisnik?.prezime ?? ''}"),
                                _tableCell(formattedDate(termin.datumTermina)),
                                _tableCell(
                                    formattedTime(termin.vrijemeTermina!)),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList() ??
                    [],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _tableHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey[700],
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _tableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blueGrey[800],
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildAdminDashboard() {
    return FutureBuilder<List<DashboardResponse>>(
      future: AdministratorProvider().getDashboardData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Greška pri učitavanju podataka.",
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "Nema podataka.",
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          );
        }
        var data = snapshot.data!;
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDashboardCard(
                  context,
                  title: 'Broj Korisnika',
                  value: data[0].brojKorisnika.toString(),
                  color: Colors.blueAccent,
                  icon: Icons.people,
                ),
                _buildDashboardCard(
                  context,
                  title: 'Broj pacijenata',
                  value: data[0].ukupanBrojPacijenata.toString(),
                  color: Colors.blueAccent,
                  icon: Icons.local_hospital,
                ),
                _buildDashboardCard(
                  context,
                  title: 'Broj doktora',
                  value: data[0].brojDoktora.toString(),
                  color: Colors.greenAccent,
                  icon: Icons.person_outline,
                ),
                _buildDashboardCard(
                  context,
                  title: 'Broj hospitalizovanih',
                  value: data[0].brojHospitalizovanih.toString(),
                  color: Colors.orangeAccent,
                  icon: Icons.hotel,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDashboardCard(
                  context,
                  title: 'Broj pregleda',
                  value: data[0].brojPregleda.toString(),
                  color: Colors.purpleAccent,
                  icon: Icons.assignment,
                ),
                _buildDashboardCard(
                  context,
                  title: 'Broj odjela',
                  value: data[0].brojOdjela.toString(),
                  color: Colors.tealAccent,
                  icon: Icons.account_balance,
                ),
                _buildDashboardCard(
                  context,
                  title: 'Broj soba',
                  value: data[0].brojSoba.toString(),
                  color: Colors.orangeAccent,
                  icon: Icons.meeting_room,
                ),
                _buildDashboardCard(
                  context,
                  title: 'Broj kreveta',
                  value: data[0].brojKreveta.toString(),
                  color: Colors.orangeAccent,
                  icon: Icons.bed,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildTerminiStackedBarChart() {
    return FutureBuilder<List<DashboardResponse>>(
      future: AdministratorProvider().getDashboardData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Greška pri učitavanju podataka.",
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "Nema podataka.",
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          );
        }

        var termini = snapshot.data!;
        List<TerminiPoMjesecima> terminiPoMjesecima = [];
        for (var dashboard in termini) {
          terminiPoMjesecima.addAll(dashboard.terminiPoMjesecima);
        }

        return TerminiStackedBarChart(
          terminiPoMesecima: terminiPoMjesecima,
        );
      },
    );
  }

  Widget _buildDashboardCard(BuildContext context,
      {required String title,
      required String value,
      required Color color,
      required IconData icon}) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        shadowColor: Colors.grey.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _generateAndPrintReport(
      PopunjenostBolniceResponse popunjenost,
      List<BrojZaposlenihPoOdjeluResponse> zaposleni,
      List<BrojPacijenataResponse> pacijenti,
      DashboardResponse dashboardData) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Izvjestaj o bolnici',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Popunjenost bolnice:',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Text('Zauzeti kreveti: ${popunjenost.zauzetiKreveta}'),
              pw.Text('Slobodni kreveti: ${popunjenost.slobodniKreveta}'),
              pw.SizedBox(height: 10),
              pw.Divider(),
              pw.Text('Osnovni podaci:',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Row(
                children: [
                  pw.Text('Broj Korisnika: ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('${dashboardData.brojKorisnika}')
                ],
              ),
              pw.Row(
                children: [
                  pw.Text('Broj pacijenata: ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('${dashboardData.ukupanBrojPacijenata}')
                ],
              ),
              pw.Row(
                children: [
                  pw.Text('Broj doktora: ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('${dashboardData.brojDoktora}')
                ],
              ),
              pw.Row(
                children: [
                  pw.Text('Broj hospitalizovanih: ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('${dashboardData.brojHospitalizovanih}')
                ],
              ),
              pw.Row(
                children: [
                  pw.Text('Broj pregleda: ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('${dashboardData.brojPregleda}')
                ],
              ),
              pw.Row(
                children: [
                  pw.Text('Broj odjela: ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('${dashboardData.brojOdjela}')
                ],
              ),
              pw.Row(
                children: [
                  pw.Text('Broj soba: ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('${dashboardData.brojSoba}')
                ],
              ),
              pw.Row(
                children: [
                  pw.Text('Broj kreveta: ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('${dashboardData.brojKreveta}')
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Divider(),
              pw.Text('Broj zaposlenih po odjelima:',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              ...zaposleni.map((e) => pw.Row(
                    children: [
                      pw.Text('${e.nazivOdjela}: ',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('${e.ukupanBrojZaposlenih}')
                    ],
                  )),
              pw.SizedBox(height: 10),
            ],
          );
        },
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/izvjestaj.pdf");
    await file.writeAsBytes(await pdf.save());
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'izvjestaj.pdf');
  }
}
