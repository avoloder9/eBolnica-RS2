import 'package:ebolnica_mobile/models/hospitalizacija_model.dart';
import 'package:ebolnica_mobile/models/search_result.dart';
import 'package:ebolnica_mobile/providers/hospitalizacija_provider.dart';
import 'package:ebolnica_mobile/screens/pacijent_nalazi_screen.dart';
import 'package:ebolnica_mobile/screens/vitalni_parametri_screen.dart';
import 'package:ebolnica_mobile/utils/utils.dart';
import 'package:flutter/material.dart';

class HospitalizacijaListScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  final String? nazivOdjela;
  const HospitalizacijaListScreen(
      {super.key, required this.userId, this.userType, this.nazivOdjela});
  @override
  _HospitalizacijaListScreenState createState() =>
      _HospitalizacijaListScreenState();
}

class _HospitalizacijaListScreenState extends State<HospitalizacijaListScreen> {
  late HospitalizacijaProvider hospitalizacijaProvider;
  SearchResult<Hospitalizacija>? hospitalizacije;
  @override
  void initState() {
    super.initState();
    hospitalizacijaProvider = HospitalizacijaProvider();
    fetchHospitalizacije();
  }

  Future<void> fetchHospitalizacije() async {
    hospitalizacije = await hospitalizacijaProvider
        .get(filter: {'nazivOdjela': widget.nazivOdjela});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hospitalizovani pacijenti",
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
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: hospitalizacije == null || hospitalizacije!.result.isEmpty
            ? const Center(
                child: Text(
                  "Nema hospitalizovanih pacijenata na ovom odjelu.",
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
                ),
              )
            : ListView.builder(
                itemCount: hospitalizacije!.result.length,
                itemBuilder: (context, index) {
                  var e = hospitalizacije!.result[index];
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
                                            "Hospitalizovan: ${formattedDate(e.datumPrijema)}",
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
                                    _buildDetailTile(Icons.meeting_room, "Soba",
                                        izdvojiBrojSobe(e.soba?.naziv)),
                                    _buildDetailTile(Icons.bed, "Krevet",
                                        e.krevet?.krevetId),
                                    _buildDetailTile(
                                        Icons.local_hospital,
                                        "Doktor",
                                        "${e.doktor?.korisnik?.ime} ${e.doktor?.korisnik?.prezime}"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: const Icon(Icons.monitor_heart,
                                color: Colors.redAccent, size: 28),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                isScrollControlled: true,
                                builder: (context) => SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.75,
                                  child: DefaultTabController(
                                    length: 2,
                                    child: Column(
                                      children: [
                                        const TabBar(
                                          labelColor: Colors.blueAccent,
                                          unselectedLabelColor: Colors.black54,
                                          indicatorColor: Colors.blueAccent,
                                          tabs: [
                                            Tab(
                                                icon: Icon(Icons.monitor_heart),
                                                text: "Vitalni Parametri"),
                                            Tab(
                                                icon: Icon(Icons.description),
                                                text: "Nalazi"),
                                          ],
                                        ),
                                        Expanded(
                                          child: TabBarView(
                                            children: [
                                              VitalniParametriScreen(
                                                userId: widget.userId,
                                                pacijent: e.pacijent,
                                                userType: widget.userType,
                                              ),
                                              PacijentNalaziScreen(
                                                userId: widget.userId,
                                                userType: widget.userType,
                                                hospitalizacija: e,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
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

  String izdvojiBrojSobe(String? nazivSobe) {
    if (nazivSobe == null) return "N/A";
    RegExp regExp = RegExp(r'\d+');
    Match? match = regExp.firstMatch(nazivSobe);
    return match != null ? match.group(0)! : "N/A";
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
