import 'package:ebolnica_desktop/models/odjel_model.dart';
import 'package:ebolnica_desktop/models/raspored_smjena_model.dart';
import 'package:ebolnica_desktop/providers/odjel_provider.dart';
import 'package:ebolnica_desktop/providers/raspored_smjena_provider.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class RasporedSmjenaScreen extends StatefulWidget {
  final String? userType;
  final int userId;
  const RasporedSmjenaScreen({super.key, required this.userId, this.userType});

  @override
  _RasporedSmjenaScreenState createState() => _RasporedSmjenaScreenState();
}

class _RasporedSmjenaScreenState extends State<RasporedSmjenaScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  late RasporedSmjenaProvider rasporedSmjenaProvider;
  late OdjelProvider odjelProvider;
  List<Odjel>? odjeli = [];
  int? selectedOdjelId;
  @override
  void initState() {
    super.initState();
    rasporedSmjenaProvider = RasporedSmjenaProvider();
    odjelProvider = OdjelProvider();
    fetchOdjeli();
  }

  Future<void> fetchOdjeli() async {
    try {
      final result = await odjelProvider.get();
      setState(() {
        odjeli = result.result;
        if (odjeli!.isNotEmpty) {
          selectedOdjelId = odjeli!.first.odjelId;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Greška pri dohvaćanju odjela: $e')),
      );
    }
  }

  Future<List<RasporedSmjena>> fetchRaspored() async {
    var filter = {
      "datum": DateFormat('yyyy-MM-dd').format(_selectedDay),
    };
    if (selectedOdjelId != null) {
      filter["odjelId"] = selectedOdjelId.toString();
    }
    var result = await rasporedSmjenaProvider.get(filter: filter);
    return result.result;
  }

  String formatTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return "--:--";

    List<String> parts = timeString.split(":");
    if (parts.length < 2) return "--:--"; // Provjera ako format nije ispravan

    return "${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Raspored Smjena')),
      drawer: SideBar(
        userId: widget.userId,
        userType: widget.userType!,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: DropdownButtonFormField<int>(
              value: selectedOdjelId,
              decoration: InputDecoration(
                labelText: "Odjel",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (newValue) {
                setState(() {
                  selectedOdjelId = newValue;
                });
              },
              items: odjeli?.map((odjel) {
                return DropdownMenuItem<int>(
                  value: odjel.odjelId,
                  child: Text(
                    odjel.naziv ?? "Nepoznato",
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }).toList(),
              hint: const Text("Odaberite odjel"),
              isExpanded: true, // Osigurava da dug tekst ne prelomi
            ),
          ),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _selectedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: isSameDay(_selectedDay, DateTime.now())
                    ? Colors.orange
                    : Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<RasporedSmjena>>(
              future: fetchRaspored(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text('Greška pri učitavanju podataka'));
                }

                List<RasporedSmjena> rasporedi = snapshot.data ?? [];

                List<RasporedSmjena> filteredRasporedi = rasporedi.where((r) {
                  DateTime datum = DateTime.parse(r.datum.toString());
                  return DateFormat('yyyy-MM-dd').format(datum) ==
                      DateFormat('yyyy-MM-dd').format(_selectedDay);
                }).toList();

                if (filteredRasporedi.isEmpty) {
                  return const Center(
                      child: Text('Nema smjena za odabrani datum'));
                }

                var groupedShifts =
                    groupBy(filteredRasporedi, (r) => r.smjena?.smjenaId);

                return ListView(
                  children: groupedShifts.entries.map((entry) {
                    var smjena = entry.value.first.smjena;
                    var korisnici = entry.value
                        .map((r) => r.korisnik)
                        .where((k) => k != null)
                        .toList();

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ExpansionTile(
                        leading: const Icon(Icons.schedule),
                        title: Text(
                            "${smjena?.nazivSmjene ?? "Nepoznata smjena"} smjena"),
                        subtitle: Text(
                          '${formatTime(smjena?.vrijemePocetka.toString())} - ${formatTime(smjena?.vrijemeZavrsetka.toString())}',
                        ),
                        children: korisnici.isNotEmpty
                            ? korisnici.map((korisnik) {
                                return ListTile(
                                  leading: const Icon(Icons.person),
                                  title: Text(
                                      '${korisnik!.ime ?? "Nepoznato"} ${korisnik.prezime ?? "Nepoznato"}'),
                                );
                              }).toList()
                            : [
                                const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text('Nema korisnika za ovu smjenu'),
                                ),
                              ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
