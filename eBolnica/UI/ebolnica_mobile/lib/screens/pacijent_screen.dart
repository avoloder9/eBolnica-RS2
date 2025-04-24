import 'dart:convert';
import 'package:ebolnica_mobile/models/doktor_model.dart';
import 'package:ebolnica_mobile/models/termin_model.dart';
import 'package:ebolnica_mobile/providers/doktor_provider.dart';
import 'package:ebolnica_mobile/providers/pacijent_provider.dart';
import 'package:ebolnica_mobile/providers/termin_provider.dart';
import 'package:ebolnica_mobile/screens/doktor_list_screen.dart';
import 'package:ebolnica_mobile/screens/novi_termin_screen.dart';
import 'package:ebolnica_mobile/screens/pacijent_detalji_screen.dart';
import 'package:ebolnica_mobile/utils/utils.dart';
import 'package:flutter/material.dart';

class PacijentScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  const PacijentScreen({super.key, required this.userId, this.userType});
  @override
  _PacijentScreenState createState() => _PacijentScreenState();
}

class _PacijentScreenState extends State<PacijentScreen> {
  int? pacijentId;
  late PacijentProvider pacijentProvider;
  late DoktorProvider doktorProvider;
  late TerminProvider terminProvider;

  List<Termin>? termini = [];
  List<Doktor> recommendedDoktori = [];
  bool isLoading = true;
  List<Doktor> doktori = [];
  @override
  void initState() {
    super.initState();
    pacijentProvider = PacijentProvider();
    doktorProvider = DoktorProvider();
    terminProvider = TerminProvider();
    fetchTermini();
    fetchRecommendedDoktori();
    fetchDoktori();
  }

  Future<void> fetchTermini() async {
    termini = [];
    pacijentId =
        await pacijentProvider.getPacijentIdByKorisnikId(widget.userId);
    if (pacijentId != null) {
      var result = await terminProvider.get(filter: {"PacijentId": pacijentId});
      setState(() {
        termini = result.result;
      });
    } else {
      termini = [];
    }
  }

  Future<void> fetchDoktori() async {
    doktori = [];
    var result = await doktorProvider.get();
    setState(() {
      doktori = result.result;
    });
  }

  Future<void> fetchRecommendedDoktori() async {
    try {
      pacijentId ??=
          await pacijentProvider.getPacijentIdByKorisnikId(widget.userId);
      if (pacijentId != null) {
        var result = await pacijentProvider.getRecommendedDoktori(pacijentId!);
        setState(() {
          recommendedDoktori = result;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.userType == "pacijent"
          ? AppBar(
              centerTitle: true,
              automaticallyImplyLeading: widget.userType == "doktor",
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.deepPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            )
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Vaše zdravlje je naša briga",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Naredni termin",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                    child: const Text("Prikazi sve",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black)),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.85,
                            child: PacijentDetaljiScreen(
                              userId: widget.userId,
                              userType: widget.userType,
                            ),
                          );
                        },
                      ).then((result) {
                        if (result == true) {
                          fetchTermini();
                        }
                      });
                    },
                  )
                ],
              ),
            ),
            termini!.isNotEmpty
                ? _buildNextAppointmentCard(termini!.first)
                : const Text("Nemate zakazanih termina."),
            const SizedBox(height: 20),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Preporučeni doktori",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                      child: const Text("Prikazi sve",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DoktoriListScreen(
                              doktori: doktori,
                              userId: widget.userId,
                              userType: widget.userType,
                            ),
                          ),
                        );
                        if (result == true) {
                          fetchTermini();
                        }
                      })
                ],
              ),
            ),
            _buildDoctorRecommendations(),
          ],
        ),
      ),
    );
  }

  Widget _buildNextAppointmentCard(Termin termin) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: const Color.fromARGB(255, 200, 150, 209),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.calendar_today,
                  size: 36, color: Colors.deepPurple),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${termin.doktor!.korisnik!.ime} ${termin.doktor!.korisnik!.prezime}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        formattedTime(termin.vrijemeTermina!),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        termin.odjel!.naziv!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formattedDate(termin.datumTermina!),
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorRecommendations() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (recommendedDoktori.isEmpty) {
      return const Text("Nema preporučenih doktora trenutno.");
    }
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: recommendedDoktori.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final doktor = recommendedDoktori[index];

          return GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return _buildDoktorInfo(doktor.doktorId!);
                  });
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                height: 210,
                width: 150,
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.transparent,
                      child: doktor.korisnik!.slika != null &&
                              doktor.korisnik!.slika!.isNotEmpty
                          ? Image.memory(
                              base64Decode(doktor.korisnik!.slika!),
                              fit: BoxFit.cover,
                            )
                          : ClipOval(
                              child: Image.asset(
                              'assets/images/osoba.jpg',
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            )),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${doktor.korisnik!.ime} ${doktor.korisnik!.prezime}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doktor.specijalizacija.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 87, 85, 85),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDoktorInfo(int doktorId) {
    return FutureBuilder<Doktor>(
      future: doktorProvider.getById(doktorId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Greška: ${snapshot.error}"));
        } else if (!snapshot.hasData) {
          return const Center(child: Text("Doktor nije pronađen"));
        }

        final doktor = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.transparent,
                child: doktor.korisnik!.slika != null &&
                        doktor.korisnik!.slika!.isNotEmpty
                    ? Image.memory(
                        base64Decode(doktor.korisnik!.slika!),
                        fit: BoxFit.cover,
                      )
                    : ClipOval(
                        child: Image.asset(
                          'assets/images/osoba.jpg',
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              Text(
                "${doktor.korisnik!.ime} ${doktor.korisnik!.prezime}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                doktor.specijalizacija!,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                doktor.biografija ?? 'Nema dostupne biografije',
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Godina rođenja: ${formattedDate(doktor.korisnik!.datumRodjenja)}",
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Zaposlen na odjelu: ${doktor.odjel!.naziv}",
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final result = await showDialog(
                    context: context,
                    builder: (BuildContext context) => NoviTerminScreen(
                      userId: widget.userId,
                      userType: widget.userType,
                      doktor: doktor,
                      odjel: doktor.odjel,
                      pacijentId: pacijentId,
                    ),
                  );

                  if (result == true && context.mounted) {
                    Navigator.pop(context);
                  }
                  fetchTermini();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                ),
                child: const Text(
                  "Zakazi termin",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
