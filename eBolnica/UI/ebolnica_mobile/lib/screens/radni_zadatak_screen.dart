import 'package:ebolnica_mobile/models/radni_zadatak_model.dart';
import 'package:ebolnica_mobile/models/search_result.dart';
import 'package:ebolnica_mobile/providers/doktor_provider.dart';
import 'package:ebolnica_mobile/providers/hospitalizacija_provider.dart';
import 'package:ebolnica_mobile/providers/odjel_provider.dart';
import 'package:ebolnica_mobile/providers/radni_zadatak_provider.dart';
import 'package:ebolnica_mobile/screens/novi_radni_zadatak_screen.dart';
import 'package:ebolnica_mobile/utils/utils.dart';
import 'package:flutter/material.dart';

class RadniZadatakScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  final String? nazivOdjela;
  const RadniZadatakScreen(
      {super.key, required this.userId, this.userType, this.nazivOdjela});

  _RadniZadatakScreenState createState() => _RadniZadatakScreenState();
}

class _RadniZadatakScreenState extends State<RadniZadatakScreen> {
  late RadniZadatakProvider radniZadatakProvider;
  late DoktorProvider doktorProvider;
  late HospitalizacijaProvider hospitalizacijaProvider;
  late OdjelProvider odjelProvider;
  SearchResult<RadniZadatak>? radniZadaci;
  int? doktorId;
  Future<void> fetchRadniZadatak() async {
    doktorId = await doktorProvider.getDoktorIdByKorisnikId(widget.userId);
    radniZadaci =
        await radniZadatakProvider.get(filter: {'doktorId': doktorId});
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    radniZadatakProvider = RadniZadatakProvider();
    doktorProvider = DoktorProvider();
    fetchRadniZadatak();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Radni zadaci", style: TextStyle(color: Colors.white)),
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
            style: const ButtonStyle(
                iconColor: MaterialStatePropertyAll(Colors.white)),
            onPressed: () async {
              bool? rezultat = await showDialog(
                context: context,
                builder: (BuildContext context) => NoviRadniZadatakScreen(
                  userId: widget.userId,
                  userType: widget.userType,
                  doktorId: doktorId!,
                  nazivOdjela: widget.nazivOdjela,
                ),
              );
              if (rezultat == true) {
                await fetchRadniZadatak();
                setState(() {});
              }
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: radniZadaci == null || radniZadaci!.result.isEmpty
            ? const Center(
                child: Text(
                  "Nema radnih zadataka od strane ovog doktora.",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              )
            : ListView.builder(
                itemCount: radniZadaci!.result.length,
                itemBuilder: (context, index) {
                  var e = radniZadaci!.result[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    margin:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                    shadowColor: Colors.black.withOpacity(0.15),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.blue[50]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Colors.blueAccent,
                                      child: Text(
                                        e.pacijent?.korisnik?.ime?.isNotEmpty ==
                                                true
                                            ? e.pacijent!.korisnik!.ime![0]
                                            : "?",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${e.pacijent!.korisnik!.ime} ${e.pacijent!.korisnik!.prezime}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "Datum zadatka: ${formattedDate(e.datumZadatka)}",
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 20, thickness: 1),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildDetailTile(Icons.group, "Osoblje",
                                        "${e.medicinskoOsoblje?.korisnik?.ime} ${e.medicinskoOsoblje?.korisnik?.prezime}"),
                                    _buildDetailTile(
                                      Icons.assignment,
                                      "Opis zadatka",
                                      e.opis ?? "Nema opisa",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String label, dynamic value) {
    return Column(
      children: [
        Icon(icon, color: Colors.blueAccent, size: 26),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        Text(
          value != null ? value.toString() : "N/A",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
