import 'package:ebolnica_mobile/models/radni_zadatak_model.dart';
import 'package:ebolnica_mobile/models/search_result.dart';
import 'package:ebolnica_mobile/providers/doktor_provider.dart';
import 'package:ebolnica_mobile/providers/medicinsko_osoblje_provider.dart';
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
  late MedicinskoOsobljeProvider osobljeProvider;
  SearchResult<RadniZadatak>? radniZadaci;
  int? doktorId;
  int? osobljeId;

  Future<void> fetchRadniZadaci() async {
    if (widget.userType == "doktor") {
      doktorId = await doktorProvider.getDoktorIdByKorisnikId(widget.userId);
      radniZadaci =
          await radniZadatakProvider.get(filter: {'doktorId': doktorId});
    } else if (widget.userType == "medicinsko osoblje") {
      osobljeId = await osobljeProvider.getOsobljeByKorisnikId(widget.userId);
      radniZadaci = await radniZadatakProvider
          .get(filter: {'medicinskoOsobljeId': osobljeId});
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    radniZadatakProvider = RadniZadatakProvider();
    doktorProvider = DoktorProvider();
    osobljeProvider = MedicinskoOsobljeProvider();
    fetchRadniZadaci();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchRadniZadaci();
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
          if (widget.userType == "doktor")
            IconButton(
              style: const ButtonStyle(
                  iconColor: MaterialStatePropertyAll(Colors.white)),
              onPressed: () async {
                bool rezultat = await showDialog(
                  context: context,
                  builder: (BuildContext context) => NoviRadniZadatakScreen(
                    userId: widget.userId,
                    userType: widget.userType,
                    doktorId: doktorId!,
                    nazivOdjela: widget.nazivOdjela,
                  ),
                );
                if (rezultat == true) {
                  fetchRadniZadaci();
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
                  "Nema aktivnih radnih zadataka.",
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
                                    _buildDetailTile(
                                        Icons.group,
                                        widget.userType == "doktor"
                                            ? "Osoblje"
                                            : "Doktor",
                                        "${widget.userType == "doktor" ? e.medicinskoOsoblje?.korisnik?.ime : e.doktor?.korisnik?.ime} "
                                        "${widget.userType == "doktor" ? e.medicinskoOsoblje?.korisnik?.prezime : e.doktor?.korisnik?.prezime}"),
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
                        if (widget.userType == "medicinsko osoblje")
                          Positioned(
                            top: 10,
                            right: 10,
                            child: IconButton(
                                icon: const Icon(Icons.check_circle,
                                    color: Colors.green, size: 28),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Potvrda"),
                                        content: const Text(
                                            "Da li želite završiti zadatak?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              if (mounted) {
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            child: const Text("Ne"),
                                          ),
                                          TextButton(
                                            style: const ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        Colors.blue)),
                                            onPressed: () async {
                                              if (!mounted) return;

                                              var request = {
                                                "Status": false,
                                                "Opis": e.opis
                                              };

                                              try {
                                                await radniZadatakProvider
                                                    .update(e.radniZadatakId!,
                                                        request);

                                                Navigator.of(context).pop();
                                                showCustomDialog(
                                                  context: context,
                                                  title: "",
                                                  message:
                                                      "Uspješno završen radni zadatak",
                                                  imagePath:
                                                      "assets/images/success.png",
                                                );
                                                fetchRadniZadaci();
                                              } catch (error) {
                                                if (mounted) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          "Došlo je do greške. Pokušajte ponovo."),
                                                      backgroundColor:
                                                          Colors.red,
                                                      duration:
                                                          Duration(seconds: 3),
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                            child: const Text("Da",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }),
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
