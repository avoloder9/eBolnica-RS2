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

  int? doktorId;
  int? osobljeId;

  SearchResult<RadniZadatak>? aktivniZadaci;
  SearchResult<RadniZadatak>? gotoviZadaci;

  Future<void> fetchRadniZadaci() async {
    if (widget.userType == "doktor") {
      doktorId = await doktorProvider.getDoktorIdByKorisnikId(widget.userId);
      if (doktorId != null) {
        aktivniZadaci = await radniZadatakProvider.get(filter: {
          'doktorId': doktorId,
          'status': true,
        });
        gotoviZadaci = await radniZadatakProvider.get(filter: {
          'doktorId': doktorId,
          'status': false,
        });
      }
    } else if (widget.userType == "medicinsko osoblje") {
      osobljeId = await osobljeProvider.getOsobljeByKorisnikId(widget.userId);
      if (osobljeId != null) {
        aktivniZadaci = await radniZadatakProvider.get(filter: {
          'medicinskoOsobljeId': osobljeId,
          'status': true,
        });
      }
      gotoviZadaci = null;
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
    return DefaultTabController(
      length: widget.userType == "doktor" ? 2 : 1,
      child: Scaffold(
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
          bottom: widget.userType == "doktor"
              ? const TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  indicatorColor: Colors.white,
                  labelStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  tabs: [
                    Tab(text: "Aktivni"),
                    Tab(text: "Završeni"),
                  ],
                )
              : null,
          actions: [
            if (widget.userType == "doktor")
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () async {
                  bool rezultat = await showDialog(
                    context: context,
                    builder: (BuildContext context) => NoviRadniZadatakScreen(
                      userId: widget.userId,
                      userType: widget.userType,
                      doktorId: doktorId ?? 0,
                      nazivOdjela: widget.nazivOdjela,
                    ),
                  );
                  if (rezultat == true) {
                    fetchRadniZadaci();
                  }
                },
              )
          ],
        ),
        body: TabBarView(
          children: widget.userType == "doktor"
              ? [
                  _buildRadniZadaciList(aktivniZadaci),
                  _buildRadniZadaciList(gotoviZadaci),
                ]
              : [
                  _buildRadniZadaciList(aktivniZadaci),
                ],
        ),
      ),
    );
  }

  Widget _buildRadniZadaciList(SearchResult<RadniZadatak>? zadaci) {
    if (zadaci == null || zadaci.result.isEmpty) {
      return const Center(child: Text("Nema radnih zadataka."));
    }
    return ListView.builder(
      itemCount: zadaci.result.length,
      itemBuilder: (context, index) {
        var e = zadaci.result[index];
        String dodatniTekst = "";
        if (widget.userType == "medicinsko osoblje" && e.doktor != null) {
          dodatniTekst =
              "Doktor: ${e.doktor!.korisnik!.ime} ${e.doktor!.korisnik!.prezime}";
        } else if (widget.userType == "doktor" && e.medicinskoOsoblje != null) {
          dodatniTekst =
              "Osoblje: ${e.medicinskoOsoblje!.korisnik!.ime} ${e.medicinskoOsoblje!.korisnik!.prezime}";
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(Icons.assignment, color: Colors.blue.shade800),
                ),
                title: Text(
                  "${e.pacijent?.korisnik?.ime ?? "Nepoznat"} ${e.pacijent?.korisnik?.prezime ?? ""}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      "Opis: ${e.opis ?? 'Nema opisa'}",
                      style:
                          TextStyle(color: Colors.grey.shade700, fontSize: 14),
                    ),
                    if (dodatniTekst.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        "$dodatniTekst",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ]
                  ],
                ),
                trailing: widget.userType == "medicinsko osoblje"
                    ? IconButton(
                        icon: const Icon(Icons.check_circle,
                            color: Colors.green, size: 30),
                        onPressed: () => _showDialog(context, e),
                      )
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDialog(BuildContext context, RadniZadatak e) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Potvrda",
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: child,
          ),
        );
      },
      pageBuilder: (context, _, __) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white.withOpacity(0.9),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 60),
                const SizedBox(height: 12),
                const Text(
                  "Završiti zadatak?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Da li ste sigurni da želite označiti zadatak kao završen?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Odustani"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        await _completeTask(context, e);
                      },
                      child: const Text("Da, završi"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _completeTask(BuildContext context, RadniZadatak e) async {
    var request = {"Status": false, "Opis": e.opis};

    try {
      await radniZadatakProvider.update(e.radniZadatakId!, request);
      Navigator.pop(context);
      showCustomDialog(
        context: context,
        title: "",
        message: "Uspješno završen radni zadatak",
        imagePath: "assets/images/success.png",
      );
      fetchRadniZadaci();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Došlo je do greške. Pokušajte ponovo."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
