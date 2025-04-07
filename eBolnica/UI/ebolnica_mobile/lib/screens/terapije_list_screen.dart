import 'package:ebolnica_mobile/models/terapija_model.dart';
import 'package:ebolnica_mobile/providers/pacijent_provider.dart';
import 'package:ebolnica_mobile/providers/terapija_provider.dart';
import 'package:ebolnica_mobile/utils/utils.dart';
import 'package:flutter/material.dart';

class PacijentTerapijaScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  const PacijentTerapijaScreen(
      {super.key, required this.userId, this.userType});
  @override
  _PacijentTerapijaScreenState createState() => _PacijentTerapijaScreenState();
}

class _PacijentTerapijaScreenState extends State<PacijentTerapijaScreen> {
  late PacijentProvider pacijentProvider;
  late TerapijaProvider terapijaProvider;
  List<Terapija>? aktivneTerapije = [];
  List<Terapija>? gotoveTerapije = [];
  int? pacijentId;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    pacijentProvider = PacijentProvider();
    terapijaProvider = TerapijaProvider();
    fetchAktivneTerapije();
    fetchGotoveTerapije();
  }

  Future<void> fetchAktivneTerapije() async {
    setState(() {
      aktivneTerapije = [];
      isLoading = true;
    });
    pacijentId =
        await pacijentProvider.getPacijentIdByKorisnikId(widget.userId);
    if (pacijentId != null) {
      var result =
          await pacijentProvider.getAktivneTerapijeByPacijentId(pacijentId!);
      setState(() {
        aktivneTerapije = result;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchGotoveTerapije() async {
    setState(() {
      gotoveTerapije = [];
      isLoading = true;
    });
    pacijentId =
        await pacijentProvider.getPacijentIdByKorisnikId(widget.userId);
    if (pacijentId != null) {
      var result =
          await pacijentProvider.getGotoveTerapijeByPacijentId(pacijentId!);
      setState(() {
        gotoveTerapije = result;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: const Text(
              "Terapije",
              style: TextStyle(color: Colors.white),
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.deepPurple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            bottom: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                labelStyle:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                tabs: [
                  Tab(text: "Aktivne"),
                  Tab(text: "Gotove"),
                ]),
          ),
          body: TabBarView(
            children: [_buildAktivneTerapijeTab(), _buildGotoveTerapijeTab()],
          ),
        ));
  }

  Widget _buildAktivneTerapijeTab() {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: aktivneTerapije == null || aktivneTerapije!.isEmpty
          ? const Center(child: Text("Nema aktivnih terapija."))
          : ListView.builder(
              itemCount: aktivneTerapije!.length,
              itemBuilder: (context, index) {
                var e = aktivneTerapije![index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.naziv.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        e.opis ?? "Nema opisa",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                "Početak: ${formattedDate(e.datumPocetka)}",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.event_available,
                                  size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                "Kraj: ${formattedDate(e.datumZavrsetka)}",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildGotoveTerapijeTab() {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: gotoveTerapije == null || gotoveTerapije!.isEmpty
          ? const Center(child: Text("Nema gotovih terapija."))
          : ListView.builder(
              itemCount: gotoveTerapije!.length,
              itemBuilder: (context, index) {
                var e = gotoveTerapije![index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.naziv.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        e.opis ?? "Nema opisa",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                "Početak: ${formattedDate(e.datumPocetka)}",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.event_available,
                                  size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                "Kraj: ${formattedDate(e.datumZavrsetka)}",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
