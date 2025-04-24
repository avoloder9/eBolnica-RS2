import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_mobile/models/termin_model.dart';
import 'package:ebolnica_mobile/providers/medicinsko_osoblje_provider.dart';
import 'package:ebolnica_mobile/providers/odjel_provider.dart';
import 'package:ebolnica_mobile/providers/termin_provider.dart';
import 'package:ebolnica_mobile/screens/novi_termin_screen.dart';
import 'package:ebolnica_mobile/utils/utils.dart';
import 'package:flutter/material.dart';

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

  Future<void> fetchTermini() async {
    termini = [];
    osobljeId = await osobljeProvider.getOsobljeByKorisnikId(widget.userId);
    if (osobljeId != null) {
      odjelId =
          await osobljeProvider.getOdjelIdByMedicinskoOsoljeId(osobljeId!);
      if (odjelId != null) {
        var result = await terminProvider.get(filter: {"OdjelId": odjelId!});
        setState(() {
          termini = result.result;
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
          title: const Text("Zakazani termini",
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
          actions: [
            IconButton(
              onPressed: () async {
                bool rezultat = await showDialog(
                  context: context,
                  builder: (BuildContext context) => NoviTerminScreen(
                    userId: widget.userId,
                    odjelId: odjelId,
                    userType: widget.userType,
                  ),
                );
                if (rezultat == true) {
                  fetchTermini();
                }
              },
              icon: const Icon(Icons.add),
              style: const ButtonStyle(
                  iconColor: MaterialStatePropertyAll(Colors.white)),
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
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "${formattedDate(e.datumTermina)} u ${formattedTime(e.vrijemeTermina!)}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.cancel, color: Colors.red),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        backgroundColor:
                                            Colors.white.withOpacity(0.9),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: ConstrainedBox(
                                            constraints: const BoxConstraints(
                                                maxWidth: 400),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                  size: 60,
                                                ),
                                                const SizedBox(height: 12),
                                                const Text(
                                                  "Otkazati termin?",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 8),
                                                const Text(
                                                  "Da li ste sigurni da zelite otkazati termin?",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    OutlinedButton(
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 20,
                                                                vertical: 12),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                      ),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, false),
                                                      child: const Text(
                                                          "Odustani"),
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.green,
                                                        foregroundColor:
                                                            Colors.white,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 20,
                                                                vertical: 12),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        var request = {
                                                          "DatumTermina": e
                                                              .datumTermina!
                                                              .toIso8601String(),
                                                          "VrijemeTermina": e
                                                              .vrijemeTermina
                                                              .toString(),
                                                          "Otkazano": true
                                                        };
                                                        try {
                                                          showGeneralDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            barrierColor: Colors
                                                                .transparent,
                                                            transitionDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        200),
                                                            pageBuilder: (context,
                                                                animation,
                                                                secondaryAnimation) {
                                                              return const Center(
                                                                child: SizedBox(
                                                                  width: 80.0,
                                                                  height: 80.0,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        6.0,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );

                                                          await terminProvider
                                                              .update(
                                                                  e.terminId!,
                                                                  request);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.of(context)
                                                              .pop();

                                                          await Flushbar(
                                                            message:
                                                                "Uspješno otkazan termin",
                                                            backgroundColor:
                                                                Colors.green,
                                                            duration:
                                                                const Duration(
                                                                    seconds: 3),
                                                          ).show(context);
                                                          fetchTermini();
                                                          setState(() {});
                                                        } catch (error) {
                                                          Navigator.pop(
                                                              context);
                                                          await Flushbar(
                                                            message:
                                                                "Došlo je do greške. Pokušajte ponovo.",
                                                            backgroundColor:
                                                                Colors.red,
                                                            duration:
                                                                const Duration(
                                                                    seconds: 3),
                                                          ).show(context);
                                                        }
                                                      },
                                                      child: const Text("Da"),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              )));
                    })));
  }
}
