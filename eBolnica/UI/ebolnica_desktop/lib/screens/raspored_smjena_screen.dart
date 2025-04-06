import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/models/odjel_model.dart';
import 'package:ebolnica_desktop/models/radni_sati_model.dart';
import 'package:ebolnica_desktop/models/raspored_smjena_model.dart';
import 'package:ebolnica_desktop/models/search_result.dart';
import 'package:ebolnica_desktop/models/slobodan_dan_model.dart';
import 'package:ebolnica_desktop/providers/medicinsko_osoblje_provider.dart';
import 'package:ebolnica_desktop/providers/odjel_provider.dart';
import 'package:ebolnica_desktop/providers/radni_sati_provider.dart';
import 'package:ebolnica_desktop/providers/raspored_smjena_provider.dart';
import 'package:ebolnica_desktop/providers/slobodan_dan_provider.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
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
  DateTime? startDate;
  DateTime? endDate;
  late RasporedSmjenaProvider rasporedSmjenaProvider;
  late SlobodniDanProvider slobodanDanProvider;
  late OdjelProvider odjelProvider;
  late RadniSatiProvider radniSatiProvider;
  List<Odjel>? odjeli = [];
  int? selectedOdjelId;
  DateTime selectedDate = DateTime.now();
  late MedicinskoOsobljeProvider medicinskoOsobljeProvider;
  int? radniSatiId;
  @override
  void initState() {
    super.initState();
    rasporedSmjenaProvider = RasporedSmjenaProvider();
    odjelProvider = OdjelProvider();
    slobodanDanProvider = SlobodniDanProvider();
    radniSatiProvider = RadniSatiProvider();
    medicinskoOsobljeProvider = MedicinskoOsobljeProvider();
    if (widget.userType == "administrator") {
      fetchOdjeli();
    }
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

  Future<void> showPrijavaDialog(
      int rasporedSmjenaId, bool isDolazak, RadniSati? radniSati) async {
    DateTime now = DateTime.now();
    Duration duration = Duration(hours: now.hour, minutes: now.minute);

    final bool? confirmed = await showCustomDialog(
      context: context,
      title: isDolazak ? 'Prijava dolaska' : 'Prijava odlaska',
      message: isDolazak
          ? 'Želite li prijaviti dolazak na smjenu?'
          : 'Želite li prijaviti odlazak sa smjene?',
      confirmText: 'Potvrdi',
      onConfirm: () {},
    );

    if (confirmed == true) {
      var osobljeId =
          await medicinskoOsobljeProvider.getOsobljeByKorisnikId(widget.userId);

      var request;

      if (isDolazak) {
        request = {
          'medicinskoOsobljeId': osobljeId,
          'rasporedSmjenaId': rasporedSmjenaId,
          'vrijemeDolaska': duration.toString(),
          'vrijemeOdlaska': null,
        };
        var response = await radniSatiProvider.insert(request);

        if (response.radniSatiId != null) {
          radniSatiId = response.radniSatiId;
          await Flushbar(
                  message: "Uspjesno prijavljen dolazak na smjenu",
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 3))
              .show(context);
          setState(() {});
        } else {
          Flushbar(
              message: "Greška pri unosu prijave na smjenu",
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3));
        }
      } else {
        if (radniSatiId != null) {
          request = {
            'vrijemeOdlaska': duration.toString(),
          };
          await radniSatiProvider.update(radniSatiId!, request);
          await Flushbar(
                  message: "Uspjesno prijavljen odlazak sa smjene",
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 3))
              .show(context);
          setState(() {});
        } else {
          Flushbar(
              message: "Greška pri odjavi sa smjene",
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3));
        }
      }
    }
  }

  void _showDateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Odaberite vremenski period"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () async {
                        await pickStartDate(setDialogState);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              startDate != null
                                  ? DateFormat('yyyy-MM-dd').format(startDate!)
                                  : "Odaberite početni datum",
                              style: const TextStyle(fontSize: 18),
                            ),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () async {
                        await pickEndDate(setDialogState);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              endDate != null
                                  ? DateFormat('yyyy-MM-dd').format(endDate!)
                                  : "Odaberite krajnji datum",
                              style: const TextStyle(fontSize: 18),
                            ),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Odustani"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (startDate != null && endDate != null) {
                      _showFullScreenLoading();

                      await _submitRaspored();

                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Molimo odaberite datume!")),
                        );
                      }
                    }
                  },
                  child: const Text("Sačuvaj"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> pickStartDate(Function setDialogState) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != startDate) {
      if (mounted) {
        setState(() {
          startDate = picked;
        });
        setDialogState(() {});
      }
    }
  }

  Future<void> pickEndDate(Function setDialogState) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? (startDate ?? DateTime.now()),
      firstDate: startDate ?? DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != endDate) {
      if (mounted) {
        setState(() {
          endDate = picked;
        });
        setDialogState(() {});
      }
    }
  }

  Future<void> _submitRaspored() async {
    if (startDate != null && endDate != null) {
      try {
        await rasporedSmjenaProvider.generisiRaspored(startDate!, endDate!);
        await Flushbar(
                message: "Raspored je uspješno dodan",
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3))
            .show(context);
        Navigator.pop(context);
        fetchRaspored();
      } catch (e) {
        await Flushbar(
                message: "Došlo je do greške",
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3))
            .show(context);
      }
    }
  }

  Future<List<RasporedSmjena>> fetchRaspored() async {
    var filter = {
      "datum": DateFormat('yyyy-MM-dd').format(_selectedDay),
    };
    if (selectedOdjelId != null) {
      filter["odjelId"] = selectedOdjelId.toString();
    }
    if (widget.userType == "medicinsko osoblje") {
      filter["korisnikId"] = widget.userId.toString();
    }
    var result = await rasporedSmjenaProvider.get(filter: filter);
    return result.result;
  }

  String formatTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return "--:--";

    List<String> parts = timeString.split(":");
    if (parts.length < 2) return "--:--";

    return "${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}";
  }

  void _showFullScreenLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Container(
          color: Colors.white,
          child: const Center(
            child: SizedBox(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                strokeWidth: 8,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Raspored Smjena')),
      drawer: SideBar(
        userId: widget.userId,
        userType: widget.userType!,
      ),
      body: Column(children: [
        if (widget.userType != "medicinsko osoblje")
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: DropdownButtonFormField<int>(
                    value: selectedOdjelId,
                    decoration: InputDecoration(
                      labelText: "Odjel",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        selectedOdjelId = newValue;
                      });
                    },
                    items: (odjeli ?? []).map((odjel) {
                      return DropdownMenuItem<int>(
                        value: odjel.odjelId,
                        child: Text(
                          odjel.naziv ?? "Nepoznato",
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
                    hint: const Text("Odaberite odjel"),
                    isExpanded: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _showDateDialog,
                      child: const Text("Generiši raspored"),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _showRadniSatiDialog(context),
                      child: const Text("Prikazi radne sate osoblja"),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => _showZahtjeviDialog(context),
                child: const Text("Prikaži zahtjeve za slobodne dane"),
              ),
            ],
          ),
        Column(
          children: [
            if (widget.userType == "medicinsko osoblje") ...[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          _showZahtjevFormDialog(context, widget.userId),
                      child: const Text("Zahtjev za slobodan dan"),
                    ),
                  ],
                ),
              ),
            ]
          ],
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
              var filter = {
                "rasporedSmjenaId": rasporedi[0].rasporedSmjenaId,
              };

              Future<RadniSati?> getRadniSati() async {
                var result = await radniSatiProvider.get(filter: filter);
                return result.result.isNotEmpty ? result.result.first : null;
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
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: widget.userType == "medicinsko osoblje"
                        ? FutureBuilder<RadniSati?>(
                            future: getRadniSati(),
                            builder: (context, radniSatiSnapshot) {
                              if (radniSatiSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              RadniSati? radniSati = radniSatiSnapshot.data;
                              bool isDolazak =
                                  radniSati?.vrijemeDolaska == null;

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Card(
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  shadowColor: Colors.black.withOpacity(0.2),
                                  color: isDolazak
                                      ? Colors.green[100]
                                      : Colors.white,
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.schedule,
                                      color: Colors.blueAccent,
                                      size: 30,
                                    ),
                                    title: Text(
                                      "${smjena?.nazivSmjene ?? "Nepoznata smjena"} smjena",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${formattedTime(smjena!.vrijemePocetka!)} - ${formattedTime(smjena.vrijemeZavrsetka!)}',
                                            style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        isDolazak
                                            ? Icons.check_circle
                                            : Icons.circle,
                                        color: isDolazak
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                      onPressed: () {
                                        showPrijavaDialog(
                                          rasporedi[0].rasporedSmjenaId!,
                                          isDolazak,
                                          radniSati,
                                        );
                                      },
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 16),
                                  ),
                                ),
                              );
                            },
                          )
                        : ExpansionTile(
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
                                        '${korisnik!.ime ?? "Nepoznato"} ${korisnik.prezime ?? "Nepoznato"}',
                                      ),
                                    );
                                  }).toList()
                                : [
                                    const Padding(
                                      padding: EdgeInsets.all(16),
                                      child:
                                          Text('Nema korisnika za ovu smjenu'),
                                    ),
                                  ],
                          ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ]),
    );
  }

  void _showRadniSatiDialog(BuildContext context) async {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(child: Text("Radni sati medicinskog osoblja")),
            content: SizedBox(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * 0.6,
              child: FutureBuilder<SearchResult<RadniSati>>(
                future: radniSatiProvider.get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text("Greška prilikom dohvatanja zahtjeva."));
                  } else if (!snapshot.hasData ||
                      snapshot.data!.result.isEmpty) {
                    return const Center(
                        child: Text("Nema radnih sati za osoblje.",
                            style: TextStyle(fontSize: 22)));
                  }

                  final radniSati = snapshot.data!.result;

                  return ListView.builder(
                    itemCount: radniSati.length,
                    itemBuilder: (context, index) {
                      final request = radniSati[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadowColor: Colors.black.withOpacity(0.1),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 16.0),
                          title: Text(
                            "${request.medicinskoOsoblje!.korisnik!.ime} ${request.medicinskoOsoblje!.korisnik!.prezime}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Dolazak: ${formattedTime(request.vrijemeDolaska!)}",
                                    style: TextStyle(
                                      color: Colors.green[700],
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Odlazak: ${formattedTime(request.vrijemeOdlaska!)}",
                                    style: TextStyle(
                                      color: Colors.red[700],
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: const Icon(
                            Icons.access_time,
                            color: Colors.blueAccent,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Zatvori"),
              ),
            ],
          );
        },
      );
    } catch (error) {
      await Flushbar(
        message: "Greška prilikom dohvatanja zahtjeva.",
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
      ).show(context);
    }
  }

  void _showZahtjeviDialog(BuildContext context) async {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Zahtjevi za slobodne dane"),
            content: SizedBox(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * 0.6,
              child: FutureBuilder<SearchResult<SlobodniDan>>(
                future: slobodanDanProvider.get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text("Greška prilikom dohvatanja zahtjeva."));
                  } else if (!snapshot.hasData ||
                      snapshot.data!.result.isEmpty) {
                    return const Center(
                        child: Text("Nema zahtjeva za slobodne dane.",
                            style: TextStyle(fontSize: 22)));
                  }

                  final zahtjevi = snapshot.data!.result;

                  return ListView.builder(
                    itemCount: zahtjevi.length,
                    itemBuilder: (context, index) {
                      final request = zahtjevi[index];
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(
                              "${request.korisnik!.ime} - ${request.korisnik!.prezime}"),
                          subtitle: Text("Razlog: ${request.razlog}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check,
                                    color: Colors.green),
                                onPressed: () async {
                                  await showCustomDialog(
                                    context: context,
                                    title: "Prihvati zahtjev",
                                    message:
                                        "Da li ste sigurni da želite prihvatiti ovaj zahtjev?",
                                    confirmText: "Prihvati",
                                    onConfirm: () async {
                                      await slobodanDanProvider.update(
                                          request.slobodniDanId!,
                                          {"status": true});
                                      Navigator.pop(context);
                                      await Flushbar(
                                        message: "Zahtjev je uspješno odobren!",
                                        duration: const Duration(seconds: 3),
                                        backgroundColor: Colors.green,
                                      ).show(context);
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.close, color: Colors.red),
                                onPressed: () async {
                                  await showCustomDialog(
                                    context: context,
                                    title: "Odbij zahtjev",
                                    message:
                                        "Da li ste sigurni da želite odbiti ovaj zahtjev?",
                                    confirmText: "Odbij",
                                    onConfirm: () async {
                                      await slobodanDanProvider.update(
                                          request.slobodniDanId!,
                                          {"status": false});
                                      Navigator.pop(context);
                                      await Flushbar(
                                        message: "Zahtjev je uspješno odbijen!",
                                        duration: const Duration(seconds: 3),
                                        backgroundColor: Colors.green,
                                      ).show(context);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Zatvori"),
              ),
            ],
          );
        },
      );
    } catch (error) {
      await Flushbar(
        message: "Greška prilikom dohvatanja zahtjeva.",
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
      ).show(context);
    }
  }

  void _showZahtjevFormDialog(BuildContext context, int korisnikId) {
    DateTime? _selectedDate;
    final TextEditingController razlogController = TextEditingController();
    final TextEditingController datumController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Zahtjev za slobodan dan",
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 400,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: datumController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Odaberi datum",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (pickedDate != null) {
                          _selectedDate = pickedDate;
                          datumController.text =
                              "${pickedDate.day}.${pickedDate.month}.${pickedDate.year}";
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: razlogController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Razlog",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Unesite razlog zahtjeva";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Otkaži", style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate() &&
                    _selectedDate != null) {
                  var slobodanDan = {
                    "korisnikId": korisnikId,
                    "datum": DateFormat('yyyy-MM-dd').format(_selectedDate!),
                    "razlog": razlogController.text
                  };
                  try {
                    await slobodanDanProvider.insert(slobodanDan);
                    await Flushbar(
                      message: "Zahtjev za slobodan dan je uspješno poslan",
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 3),
                    ).show(context);
                  } catch (e) {
                    await Flushbar(
                      message: "Došlo je do greške. Pokušajte ponovo.",
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 2),
                    ).show(context);
                  }
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Pošalji zahtjev"),
            ),
          ],
        );
      },
    );
  }
}
