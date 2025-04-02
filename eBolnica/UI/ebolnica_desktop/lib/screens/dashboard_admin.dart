import 'package:ebolnica_desktop/models/Response/broj_zaposlenih_po_odjelu_response.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ebolnica_desktop/models/Response/broj_pregleda_po_danu_response.dart';
import 'package:ebolnica_desktop/models/Response/popunjenost_bolnice_response.dart';
import 'package:ebolnica_desktop/providers/krevet_provider.dart';
import 'package:ebolnica_desktop/providers/pregled_provider.dart';
import 'package:ebolnica_desktop/providers/odjel_provider.dart';
import 'side_bar.dart';

class DashboardAdmin extends StatefulWidget {
  final int userId;
  final String? userType;

  const DashboardAdmin({super.key, required this.userId, this.userType});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  int _selectedDays = 7;
  final List<int> availableDays = [7, 14, 30, 60, 120];
  void _onDaysChanged(int newValue) {
    setState(() {
      _selectedDays = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Administrator')),
      drawer: SideBar(userType: widget.userType!, userId: widget.userId),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 24,
                    height: 350,
                    child: _buildPopunjenostGrafikon(),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 24,
                    height: 350,
                    child: _buildBrojPregledaGrafikon(
                      selectedDays: _selectedDays,
                      onDaysChanged: _onDaysChanged,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 350,
                child: _buildBrojZaposlenihPoOdjelu(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopunjenostGrafikon() {
    return FutureBuilder<PopunjenostBolniceResponse>(
      future: KrevetProvider().getPopunjenostBolnice(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Greška pri učitavanju podataka."));
        } else if (!snapshot.hasData) {
          return const Center(child: Text("Nema podataka."));
        }

        var popunjenost = snapshot.data!;
        return Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Broj kreveta',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 250,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: popunjenost.zauzetiKreveta.toDouble(),
                          color: Colors.red,
                          title: 'Zauzeti: ${popunjenost.zauzetiKreveta}',
                          radius: 60,
                        ),
                        PieChartSectionData(
                          value: popunjenost.slobodniKreveta.toDouble(),
                          color: Colors.green,
                          title: 'Slobodni: ${popunjenost.slobodniKreveta}',
                          radius: 60,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBrojPregledaGrafikon({
    required int selectedDays,
    required Function(int) onDaysChanged,
  }) {
    return FutureBuilder<List<BrojPregledaPoDanuResponse>>(
      future: PregledProvider().getBrojPregledaPoDanu(selectedDays),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Greška pri učitavanju podataka."));
        }

        var hasData = snapshot.hasData && snapshot.data!.isNotEmpty;
        var data = snapshot.data ?? [];

        return Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Broj Pregleda u zadnjih:',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 10),
                DropdownButton<int>(
                  value: availableDays.contains(selectedDays)
                      ? selectedDays
                      : availableDays[0],
                  items: availableDays.map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value dana'),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      onDaysChanged(newValue);
                    }
                  },
                ),
                const SizedBox(height: 20),
                if (!hasData)
                  const Center(
                      child: Text("Nema podataka za selektovani period.")),
                if (hasData)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            gridData: const FlGridData(show: true),
                            titlesData: FlTitlesData(
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: true),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    var datum =
                                        DateTime.fromMillisecondsSinceEpoch(
                                            value.toInt());
                                    return Text(
                                        "${datum.day}.${datum.month}.${datum.year}");
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: true),
                            barGroups: data
                                .map((e) => BarChartGroupData(
                                      x: e.datum.millisecondsSinceEpoch,
                                      barRods: [
                                        BarChartRodData(
                                          toY: e.brojPregleda.toDouble(),
                                          color: Colors.blue,
                                          width: 10,
                                        ),
                                      ],
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBrojZaposlenihPoOdjelu() {
    return FutureBuilder<List<BrojZaposlenihPoOdjeluResponse>>(
      future: OdjelProvider().getUkupanBrojZaposlenihPoOdjelima(),
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
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          shadowColor: Colors.grey.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Broj Zaposlenih po Odjelu',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                ),
                const Divider(color: Colors.grey, thickness: 0.8),
                const SizedBox(height: 8),
                Flexible(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: BarChart(
                      BarChartData(
                        barGroups: data.map((e) {
                          return BarChartGroupData(
                            x: data.indexOf(e),
                            barRods: [
                              BarChartRodData(
                                toY: e.ukupanBrojZaposlenih.toDouble(),
                                gradient: const LinearGradient(
                                  colors: [Colors.blue, Colors.lightBlueAccent],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ],
                          );
                        }).toList(),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, titleMeta) {
                                return SideTitleWidget(
                                  axisSide: titleMeta.axisSide,
                                  child: Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 60,
                              getTitlesWidget: (value, titleMeta) {
                                int index = value.toInt();
                                return SideTitleWidget(
                                  axisSide: titleMeta.axisSide,
                                  child: Text(
                                    data[index].nazivOdjela,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawHorizontalLine: true,
                          horizontalInterval: 10,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Colors.grey.shade300,
                            strokeWidth: 1,
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.7),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
