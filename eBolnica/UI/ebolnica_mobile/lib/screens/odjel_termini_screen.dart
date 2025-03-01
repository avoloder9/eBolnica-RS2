import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_mobile/models/termin_model.dart';
import 'package:ebolnica_mobile/providers/medicinsko_osoblje_provider.dart';
import 'package:ebolnica_mobile/providers/odjel_provider.dart';
import 'package:ebolnica_mobile/providers/termin_provider.dart';
import 'package:ebolnica_mobile/screens/novi_termin_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OdjelTerminiScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  const OdjelTerminiScreen({super.key, required this.userId, this.userType});
  @override
  State<OdjelTerminiScreen> createState() => _OdjelTerminiScreenState();
}

class _OdjelTerminiScreenState extends State<OdjelTerminiScreen> {
  late OdjelProvider odjelProvider;
  late MedicinskoOsobljeProvider osobljeProvider;
  late TerminProvider terminProvider;
  int? osobljeId;
  int? odjelId;
  List<Termin>? termini = [];

  @override
  void initState() {
    super.initState();
    odjelProvider = OdjelProvider();
    osobljeProvider = MedicinskoOsobljeProvider();
    terminProvider = TerminProvider();
    fetchTermini();
  }

  String formattedDate(date) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  String formattedTime(Duration time) {
    final hours = time.inHours.toString().padLeft(2, '0');
    final minutes = (time.inMinutes % 60).toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  Future<void> fetchTermini() async {
    termini = [];
    osobljeId = await osobljeProvider.getOsobljeByKorisnikId(widget.userId);
    if (osobljeId != null) {
      odjelId =
          await osobljeProvider.getOdjelIdByMedicinskoOsoljeId(osobljeId!);
      if (odjelId != null) {
        var result = await odjelProvider.getTerminByOdjelId(odjelId!);
        setState(() {
          termini = result;
        });
        if (termini == null) {
          print("error");
        }
      } else
        print("error");
    } else
      print("error");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        title: const Text("Zakazani termini",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => NoviTerminScreen(
                  userId: widget.userId,
                  odjelId: odjelId,
                  userType: widget.userType,
                ),
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: termini == null || termini!.isEmpty
            ? const Center(child: Text("Nema dostupnih termina."))
            : ListView.builder(
                itemCount: termini!.length,
                itemBuilder: (context, index) {
                  var e = termini![index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(14),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          e.pacijent?.korisnik?.ime?.isNotEmpty == true
                              ? e.pacijent!.korisnik!.ime![0]
                              : "?",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        "${e.pacijent!.korisnik!.ime} ${e.pacijent!.korisnik!.prezime}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "${formattedDate(e.datumTermina)} u ${formattedTime(e.vrijemeTermina!)}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Potvrda"),
                                content: const Text(
                                    "Da li ste sigurni da želite otkazati termin?"),
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
                                        Navigator.of(context).pop();
                                        await Flushbar(
                                          message: "Uspješno otkazan termin",
                                          backgroundColor: Colors.green,
                                          duration: const Duration(seconds: 3),
                                        ).show(context);
                                        fetchTermini();
                                        setState(() {});
                                      } catch (error) {
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
      ),
    );
  }
}
