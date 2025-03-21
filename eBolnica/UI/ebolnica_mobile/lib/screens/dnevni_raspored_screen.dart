import 'package:ebolnica_mobile/models/dnevnI_raspored_response.dart';
import 'package:ebolnica_mobile/providers/doktor_provider.dart';
import 'package:ebolnica_mobile/utils/utils.dart';
import 'package:flutter/material.dart';

class DnevniRasporedScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  final String? nazivOdjela;
  const DnevniRasporedScreen(
      {super.key, required this.userId, this.userType, this.nazivOdjela});
  _DnevniRasporedScreenState createState() => _DnevniRasporedScreenState();
}

class _DnevniRasporedScreenState extends State<DnevniRasporedScreen> {
  late DoktorProvider doktorProvider;
  DnevniRasporedResponse? dnevniRaspored;
  int? doktorId;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    doktorProvider = DoktorProvider();
    fetchRaspored();
  }

  Future<void> fetchRaspored() async {
    doktorId = await doktorProvider.getDoktorIdByKorisnikId(widget.userId);
    if (doktorId != null) {
      dnevniRaspored = await doktorProvider.getDnevniRaspored(doktorId!);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dnevni raspored",
            style: TextStyle(color: Colors.white)),
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
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : dnevniRaspored == null ||
                  (dnevniRaspored!.termini.isEmpty &&
                      dnevniRaspored!.operacije.isEmpty)
              ? const Center(
                  child: Text(
                    "Nema zakazanih termina ni operacija za danas.",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (dnevniRaspored!.termini.isNotEmpty) ...[
                          const Text(
                            "📅 Termini",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                          ),
                          const SizedBox(height: 8),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: dnevniRaspored!.termini.length,
                            itemBuilder: (context, index) {
                              var termin = dnevniRaspored!.termini[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                elevation: 2,
                                child: ListTile(
                                  leading: const Icon(Icons.event,
                                      color: Colors.blue),
                                  title: Text(
                                    "Termin: ${formattedDate(termin.datumTermina)}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    "Pacijent: ${termin.pacijent!.korisnik!.ime} ${termin.pacijent!.korisnik!.prezime}",
                                    style:
                                        const TextStyle(color: Colors.black87),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                        if (dnevniRaspored!.operacije.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          const Row(
                            children: [
                              Icon(Icons.healing, color: Colors.red),
                              SizedBox(width: 5),
                              Text(
                                "Operacije",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: dnevniRaspored!.operacije.length,
                            itemBuilder: (context, index) {
                              var operacija = dnevniRaspored!.operacije[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                elevation: 2,
                                child: ListTile(
                                  leading: const Icon(Icons.medical_services,
                                      color: Colors.red),
                                  title: Text(
                                    "Operacija: ${formattedDate(operacija.datumOperacije)}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    "Pacijent: ${operacija.pacijent!.korisnik!.ime} ${operacija.pacijent!.korisnik!.prezime}",
                                    style:
                                        const TextStyle(color: Colors.black87),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
    );
  }
}
