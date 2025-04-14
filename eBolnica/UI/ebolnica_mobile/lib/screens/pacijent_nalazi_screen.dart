import 'package:ebolnica_mobile/models/hospitalizacija_model.dart';
import 'package:ebolnica_mobile/models/laboratorijski_nalaz_model.dart';
import 'package:ebolnica_mobile/providers/laboratorijski_nalaz_provider.dart';
import 'package:ebolnica_mobile/providers/pacijent_provider.dart';
import 'package:ebolnica_mobile/screens/nalazi_detalji_screen.dart';
import 'package:ebolnica_mobile/utils/utils.dart';
import 'package:flutter/material.dart';

class PacijentNalaziScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  final Hospitalizacija? hospitalizacija;
  const PacijentNalaziScreen(
      {super.key, required this.userId, this.userType, this.hospitalizacija});

  @override
  _PacijentNalaziScreenState createState() => _PacijentNalaziScreenState();
}

class _PacijentNalaziScreenState extends State<PacijentNalaziScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.userType == "pacijent"
          ? AppBar(
              title: const Text("Historija nalaza",
                  style: TextStyle(color: Colors.white)),
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
      body: _buildResultView(),
    );
  }

  List<LaboratorijskiNalaz>? nalazi = [];
  late LaboratorijskiNalazProvider nalazProvider;
  late PacijentProvider pacijentProvider;
  int? pacijentId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    nalazProvider = LaboratorijskiNalazProvider();
    pacijentProvider = PacijentProvider();
    fetchNalaz();
  }

  Future<void> fetchNalaz() async {
    setState(() {
      nalazi = [];
      isLoading = true;
    });
    if (widget.userType == "doktor") {
      pacijentId = widget.hospitalizacija!.pacijentId;
    } else {
      pacijentId =
          await pacijentProvider.getPacijentIdByKorisnikId(widget.userId);
    }
    if (pacijentId != null) {
      var result = await pacijentProvider.getNalaziByPacijentId(pacijentId!);
      setState(() {
        nalazi = result;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print("error");
    }
  }

  Widget _buildResultView() {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: nalazi == null || nalazi!.isEmpty
          ? const Center(child: Text("Nema dostupnih nalaza."))
          : ListView.builder(
              itemCount: nalazi!.length,
              itemBuilder: (context, index) {
                var e = nalazi![index];
                return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => NalazDetaljiScreen(
                            laboratorijskiNalaz: e,
                            hospizalizacija: widget.hospitalizacija,
                          ),
                        );
                      },
                      contentPadding: const EdgeInsets.all(14),
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Doktor: ${e.doktor!.korisnik!.ime} ${e.doktor!.korisnik!.prezime}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              formattedDate(e.datumNalaza),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ]),
                    ));
              },
            ),
    );
  }
}
