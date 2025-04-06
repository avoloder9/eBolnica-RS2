import 'dart:convert';
import 'package:ebolnica_desktop/models/pacijent_model.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

late PacijentProvider pacijentProvider;
String formatNumber(dynamic) {
  var f = NumberFormat('###,00');
  if (dynamic == null) {
    return "";
  }
  return f.format(dynamic);
}

Image imageFromString(String input) {
  return Image.memory(base64Decode(input));
}

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;
    text = text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.length <= 9) {
      text = text.replaceAllMapped(RegExp(r"(\d{3})(\d{3})(\d{3})"), (match) {
        return "${match[1]}/${match[2]}-${match[3]}";
      });
    } else if (text.length == 10) {
      text = text.replaceAllMapped(RegExp(r"(\d{3})(\d{3})(\d{4})"), (match) {
        return "${match[1]}/${match[2]}-${match[3]}";
      });
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

int? getPacijentIdByUserId(int? userId, List<Pacijent> pacijenti) {
  if (userId == null) return null;

  final pacijent = pacijenti.firstWhere(
    (pacijent) => pacijent.korisnikId == userId,
    orElse: () => Pacijent(),
  );

  return pacijent.pacijentId;
}

Future<List<Pacijent>> fetchPacijenti() async {
  final response = await pacijentProvider.get();
  return response.result;
}

String formattedDate(date) {
  final formatter = DateFormat('dd/MM/yyyy');
  return formatter.format(date);
}

String formattedTime(Duration time) {
  final hours = time.inHours.toString().padLeft(2, '0');
  final minutes = (time.inMinutes % 60).toString().padLeft(2, '0');
  return '$hours:$minutes';
}

Widget buildEmptyView(
    {required BuildContext context,
    required Widget screen,
    required String message}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.add_circle, size: 80, color: Colors.blue),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return screen;
              },
              barrierDismissible: false,
            );
          },
        ),
        const SizedBox(height: 10),
        Text(
          message,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

class DurationConverter implements JsonConverter<Duration?, String?> {
  const DurationConverter();

  @override
  Duration? fromJson(String? json) {
    if (json == null) return null;
    List<String> parts = json.split(':');
    if (parts.length != 3) return null; // Ako format nije HH:mm:ss

    int hours = int.tryParse(parts[0]) ?? 0;
    int minutes = int.tryParse(parts[1]) ?? 0;
    int seconds = int.tryParse(parts[2]) ?? 0;

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  @override
  String? toJson(Duration? duration) {
    if (duration == null) return null;
    return "${duration.inHours.toString().padLeft(2, '0')}:"
        "${(duration.inMinutes % 60).toString().padLeft(2, '0')}:"
        "${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }
}

Duration? parseDuration(String? timeString) {
  if (timeString == null) return null;
  List<String> parts = timeString.split(':');
  if (parts.length < 2) return null;

  int hours = int.tryParse(parts[0]) ?? 0;
  int minutes = int.tryParse(parts[1]) ?? 0;

  return Duration(hours: hours, minutes: minutes);
}

Future<bool?> showCustomDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmText,
  required VoidCallback onConfirm,
  String cancelText = "Odustani",
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white.withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60,
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(cancelText),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                        onConfirm();
                      },
                      child: Text(confirmText),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

class TerminiStackedBarChart extends StatelessWidget {
  final List<TerminiPoMjesecima> terminiPoMesecima;

  TerminiStackedBarChart({required this.terminiPoMesecima});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Broj zakazanih termina po mjesecima',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Transform.rotate(
                            angle: -0.4,
                            child: Text(
                              _getMonthName(value.toInt()),
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return const Text(
                          '',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: _buildStackedBarGroups(),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()}',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          backgroundColor: Colors.transparent,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildStackedBarGroups() {
    return terminiPoMesecima.map((termin) {
      return BarChartGroupData(
        x: termin.mjesec,
        barRods: [
          BarChartRodData(
            toY: termin.brojTermina.toDouble(),
            width: 20,
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue,
            rodStackItems: [
              BarChartRodStackItem(
                0,
                termin.brojTermina.toDouble(),
                Colors.blue,
              ),
            ],
          ),
        ],
      );
    }).toList();
  }

  String _getMonthName(int month) {
    const months = [
      'Januar',
      'Februar',
      'Mart',
      'April',
      'Maj',
      'Juni',
      'Juli',
      'August',
      'Septembar',
      'Oktobar',
      'Novembar',
      'Decembar'
    ];
    return months[month - 1];
  }
}

class TerminiPoMjesecima {
  int godina;
  int mjesec;
  int brojTermina;

  TerminiPoMjesecima({
    required this.godina,
    required this.mjesec,
    required this.brojTermina,
  });

  factory TerminiPoMjesecima.fromJson(Map<String, dynamic> json) {
    return TerminiPoMjesecima(
      godina: json['godina'],
      mjesec: json['mjesec'],
      brojTermina: json['brojTermina'],
    );
  }
}
