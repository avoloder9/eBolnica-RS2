import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_mobile/models/operacija_model.dart';
import 'package:ebolnica_mobile/models/pregledi_response.dart';
import 'package:ebolnica_mobile/models/terapija_model.dart';
import 'package:ebolnica_mobile/models/termin_model.dart';
import 'package:ebolnica_mobile/providers/operacija_provider.dart';
import 'package:ebolnica_mobile/providers/pacijent_provider.dart';
import 'package:ebolnica_mobile/providers/terapija_provider.dart';
import 'package:ebolnica_mobile/providers/termin_provider.dart';
import 'package:ebolnica_mobile/screens/novi_termin_screen.dart';
import 'package:ebolnica_mobile/utils/utils.dart';
import 'package:flutter/material.dart';

class PacijentDetaljiScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  const PacijentDetaljiScreen({super.key, required this.userId, this.userType});
  @override
  _PacijentDetaljiScreenState createState() => _PacijentDetaljiScreenState();
}

class _PacijentDetaljiScreenState extends State<PacijentDetaljiScreen> {
  late PacijentProvider pacijentProvider;
  late TerminProvider terminProvider;
  late TerapijaProvider terapijaProvider;
  late OperacijaProvider operacijaProvider;
  List<Termin>? termini = [];
  List<PreglediResponse>? pregledi = [];
  List<Operacija>? operacije = [];
  int? pacijentId;

  @override
  void initState() {
    super.initState();
    pacijentProvider = PacijentProvider();
    terminProvider = TerminProvider();
    terapijaProvider = TerapijaProvider();
    operacijaProvider = OperacijaProvider();
    fetchTermini();
    fetchPregledi();
    fetchOperacije();
  }

  Future<void> fetchTermini() async {
    termini = [];
    pacijentId =
        await pacijentProvider.getPacijentIdByKorisnikId(widget.userId);
    if (pacijentId != null) {
      var result =
          await terminProvider.get(filter: {"PacijentId": pacijentId!});
      setState(() {
        termini = result.result;
      });
    } else {
      termini = [];
    }
  }

  Future<void> fetchPregledi() async {
    pregledi = [];
    pacijentId =
        await pacijentProvider.getPacijentIdByKorisnikId(widget.userId);
    if (pacijentId != null) {
      var result = await pacijentProvider.getPreglediByPacijentId(pacijentId!);
      if (mounted) {
        setState(() {
          pregledi = result;
        });
      }
    } else {
      pregledi = [];
    }
  }

  Future<void> fetchOperacije() async {
    operacije = [];
    pacijentId =
        await pacijentProvider.getPacijentIdByKorisnikId(widget.userId);
    if (pacijentId != null) {
      var result =
          await operacijaProvider.get(filter: {"PacijentId": pacijentId});
      setState(() {
        operacije = result.result;
      });
    } else {
      operacije = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.deepPurple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: pacijentId == null
                    ? null
                    : () async {
                        bool rezultat = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return NoviTerminScreen(
                                    pacijentId: pacijentId!,
                                    userId: widget.userId,
                                    userType: widget.userType,
                                  );
                                },
                                barrierDismissible: false) ??
                            false;
                        if (rezultat == true) {
                          fetchTermini();
                        }
                      },
                style: const ButtonStyle(
                    iconColor: MaterialStatePropertyAll(Colors.white)),
                icon: const Icon(Icons.add),
              ),
            ],
            bottom: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                labelStyle:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                tabs: [
                  Tab(text: "Termini"),
                  Tab(text: "Pregledi"),
                  Tab(text: "Operacije"),
                ]),
          ),
          body: TabBarView(
            children: [
              _buildTerminiTab(),
              _buildPreglediTab(),
              _buildOperacijeTab()
            ],
          ),
        ));
  }

  Widget _buildTerminiTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: termini == null || termini!.isEmpty
          ? const Center(
              child: Text(
                "Nema dostupnih termina.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: termini!.length,
              itemBuilder: (context, index) {
                var e = termini![index];
                var doktor = e.doktor?.korisnik;

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 6,
                  shadowColor: Colors.black12,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.teal,
                      child: Text(
                        doktor?.ime?.isNotEmpty == true ? doktor!.ime![0] : "?",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    title: Text(
                      "${doktor?.ime ?? 'Nepoznato'} ${doktor?.prezime ?? ''}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.event,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(
                              "${formattedDate(e.datumTermina)} u ${formattedTime(e.vrijemeTermina!)}",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.redAccent,
                        size: 28,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Potvrda"),
                              content: const Text(
                                  "Da li ste sigurni da zelite otkazati termin?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Ne"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    var request = {
                                      "DatumTermina":
                                          e.datumTermina!.toIso8601String(),
                                      "VrijemeTermina":
                                          e.vrijemeTermina.toString(),
                                      "Otkazano": true
                                    };

                                    try {
                                      await terminProvider.update(
                                          e.terminId!, request);
                                      if (!mounted) return;

                                      await fetchTermini();
                                      if (!mounted) return;

                                      setState(() {});

                                      Navigator.of(context).pop(true);
                                      if (!mounted) return;

                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext dialogContext) {
                                          Future.delayed(
                                              const Duration(seconds: 2), () {
                                            if (mounted) {
                                              Navigator.of(dialogContext)
                                                  .pop(true);
                                            }
                                          });
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Image.asset(
                                                    "assets/images/success.png",
                                                    height: 80),
                                                const SizedBox(height: 10),
                                                const Text(
                                                    "Termin je uspješno otkazan."),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    } catch (error) {
                                      if (!mounted) return;
                                      await Flushbar(
                                        message:
                                            "Došlo je do greške. Pokušajte ponovo.",
                                        backgroundColor: Colors.red,
                                        duration: const Duration(seconds: 3),
                                      ).show(context);
                                    }
                                  },
                                  child: const Text("Da"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildPreglediTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: pregledi == null || pregledi!.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: pregledi!.length,
              itemBuilder: (context, index) {
                var e = pregledi![index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.white,
                  shadowColor: Colors.black12,
                  elevation: 6,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        e.imeDoktora.isNotEmpty ? e.imeDoktora[0] : "?",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      "${e.imeDoktora} ${e.prezimeDoktora}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          "${formattedDate(e.datumTermina)} u ${formattedTime(e.vrijemeTermina)}",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: Colors.grey, size: 28),
                    onTap: () => showPregledDetailsDialog(context, e),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildOperacijeTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: operacije == null || operacije!.isEmpty
          ? const Center(
              child: Text(
                "Nema dostupnih operacija.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: operacije!.length,
              itemBuilder: (context, index) {
                var e = operacije![index];
                var doktor = e.doktor?.korisnik;
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 6,
                  shadowColor: Colors.black12,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.deepPurpleAccent,
                      child: Text(
                        doktor?.ime?.isNotEmpty == true ? doktor!.ime![0] : "?",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    title: Text(
                      "${doktor?.ime ?? 'Nepoznato'} ${doktor?.prezime ?? ''}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.event,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(
                              formattedDate(e.datumOperacije),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.local_hospital,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                e.tipOperacije ?? "Nepoznat tip",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void showPregledDetailsDialog(
      BuildContext context, PreglediResponse pregled) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: FutureBuilder<Terapija?>(
            future: terapijaProvider.getTerapijabyPregledId(pregled.pregledId),
            builder: (context, snapshot) {
              bool hasTerapija = snapshot.hasData && snapshot.data != null;
              double dialogHeight = hasTerapija
                  ? MediaQuery.of(context).size.height * 0.7
                  : MediaQuery.of(context).size.height * 0.55;

              return Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: dialogHeight,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Detalji pregleda",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow(Icons.person, "Doktor:",
                                "${pregled.imeDoktora} ${pregled.prezimeDoktora}"),
                            _buildDetailRow(
                                Icons.calendar_today,
                                "Datum pregleda:",
                                formattedDate(pregled.datumTermina)),
                            _buildDetailRow(Icons.medical_services,
                                "Glavna dijagnoza:", pregled.glavnaDijagnoza),
                            _buildDetailRow(Icons.history_edu, "Anamneza:",
                                pregled.anamneza),
                            _buildDetailRow(Icons.assignment, "Zaključak:",
                                pregled.zakljucak),
                            if (hasTerapija) ...[
                              const SizedBox(height: 10),
                              const Text(
                                "Terapija",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(),
                              _buildDetailRow(
                                  Icons.medication,
                                  "Naziv terapije:",
                                  snapshot.data!.naziv ?? "N/A"),
                              _buildDetailRow(Icons.description, "Opis:",
                                  snapshot.data!.opis ?? "N/A"),
                              _buildDetailRow(
                                  Icons.date_range,
                                  "Datum početka:",
                                  formattedDate(snapshot.data!.datumPocetka)),
                              _buildDetailRow(
                                  Icons.date_range,
                                  "Datum završetka:",
                                  formattedDate(snapshot.data!.datumZavrsetka)),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueAccent, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  value,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
