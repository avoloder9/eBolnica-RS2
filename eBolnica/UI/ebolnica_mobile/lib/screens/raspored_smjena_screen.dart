import 'package:ebolnica_mobile/models/radni_sati_model.dart';
import 'package:ebolnica_mobile/models/raspored_smjena_model.dart';
import 'package:ebolnica_mobile/providers/medicinsko_osoblje_provider.dart';
import 'package:ebolnica_mobile/providers/radni_sati_provider.dart';
import 'package:ebolnica_mobile/providers/raspored_smjena_provider.dart';
import 'package:ebolnica_mobile/utils/utils.dart';
import 'package:flutter/material.dart';

class RasporedSmjenaScreen extends StatefulWidget {
  final int userId;
  final String userType;

  const RasporedSmjenaScreen(
      {super.key, required this.userId, required this.userType});

  @override
  _RasporedSmjenaScreenState createState() => _RasporedSmjenaScreenState();
}

class _RasporedSmjenaScreenState extends State<RasporedSmjenaScreen> {
  late RasporedSmjenaProvider rasporedSmjenaProvider;
  late RadniSatiProvider radniSatiProvider;
  late MedicinskoOsobljeProvider medicinskoOsobljeProvider;
  int? radniSatiId;

  Future<List<RasporedSmjena>> fetchRaspored() async {
    var filter = {
      "korisnikId": widget.userId.toString(),
    };
    var result = await rasporedSmjenaProvider.get(filter: filter);
    return result.result;
  }

  @override
  void initState() {
    super.initState();
    rasporedSmjenaProvider = RasporedSmjenaProvider();
    radniSatiProvider = RadniSatiProvider();
    medicinskoOsobljeProvider = MedicinskoOsobljeProvider();
  }

  Future<void> showPrijavaDialog(
      int rasporedSmjenaId, bool isDolazak, RadniSati? radniSati) async {
    DateTime now = DateTime.now();
    Duration duration = Duration(hours: now.hour, minutes: now.minute);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isDolazak ? 'Prijavi dolazak' : 'Prijavi odlazak'),
          content: Text(isDolazak
              ? 'Želite li prijaviti dolazak na smjenu?'
              : 'Želite li prijaviti odlazak sa smjene?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Otkazati'),
            ),
            TextButton(
              onPressed: () async {
                var osobljeId = await medicinskoOsobljeProvider
                    .getOsobljeByKorisnikId(widget.userId);

                var request;
                if (isDolazak) {
                  request = {
                    'medicinskoOsobljeId': osobljeId,
                    'rasporedSmjenaId': rasporedSmjenaId,
                    'vrijemeDolaska': duration.toString(),
                    'vrijemeOdlaska': null,
                  };
                  var response = await radniSatiProvider.insert(request);

                  if (response.radniSatiId != null) {
                    if (mounted) {
                      setState(() {
                        radniSatiId = response.radniSatiId;
                      });
                      await showCustomDialog(
                          context: context,
                          title: "",
                          message: "Uspješno prijavljen dolazak na smjenu",
                          imagePath: "assets/images/success.png");
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Greška pri unosu radnih sati")),
                    );
                  }
                } else {
                  if (radniSatiId != null) {
                    request = {
                      'vrijemeOdlaska': duration.toString(),
                    };
                    await radniSatiProvider.update(radniSatiId!, request);
                    await showCustomDialog(
                        context: context,
                        title: "",
                        message: "Uspješno prijavljen odlazak sa smjene",
                        imagePath: "assets/images/success.png");
                    fetchRaspored();
                    setState(() {});
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Greška, radni sati nisu pronađeni")),
                    );
                  }
                }
                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Potvrdi'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Raspored smjena",
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
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(child: _buildShiftList()),
          ],
        ),
      ),
    );
  }

  Widget _buildShiftList() {
    return FutureBuilder<List<RasporedSmjena>>(
      future: fetchRaspored(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Greška pri učitavanju podataka'));
        }

        List<RasporedSmjena> rasporedi = snapshot.data ?? [];
        List<RasporedSmjena> validRasporedi =
            rasporedi.where((r) => r.smjena != null).toList();

        if (validRasporedi.isEmpty) {
          return const Center(child: Text('Nemate zakazane smjene'));
        }

        return ListView.builder(
          itemCount: validRasporedi.length,
          itemBuilder: (context, index) {
            var raspored = validRasporedi[index];
            var smjena = raspored.smjena;
            var datum = formattedDate(raspored.datum);
            var filter = {
              "rasporedSmjenaId": raspored.rasporedSmjenaId,
            };

            Future<RadniSati?> getRadniSati() async {
              var result = await radniSatiProvider.get(filter: filter);
              return result.result.isNotEmpty ? result.result.first : null;
            }

            return FutureBuilder<RadniSati?>(
              future: getRadniSati(),
              builder: (context, radniSatiSnapshot) {
                if (radniSatiSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                RadniSati? radniSati = radniSatiSnapshot.data;
                bool isDolazak = radniSati?.vrijemeDolaska == null;

                bool danas = DateTime.now().day == raspored.datum!.day &&
                    DateTime.now().month == raspored.datum!.month &&
                    DateTime.now().year == raspored.datum!.year;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadowColor: Colors.black.withOpacity(0.1),
                    color: isDolazak ? Colors.blue[50] : Colors.white,
                    child: ListTile(
                      leading: const Icon(
                        Icons.schedule,
                        color: Colors.blueAccent,
                        size: 30,
                      ),
                      title: Text(
                        "${smjena?.nazivSmjene ?? "Nepoznata smjena"} smjena",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Datum: $datum',
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${formattedTime(smjena!.vrijemePocetka!)} - ${formattedTime(smjena.vrijemeZavrsetka!)}',
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          isDolazak ? Icons.check_circle : Icons.circle,
                          color: isDolazak ? Colors.green : Colors.redAccent,
                        ),
                        onPressed: danas
                            ? () {
                                showPrijavaDialog(raspored.rasporedSmjenaId!,
                                    isDolazak, radniSati);
                              }
                            : () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Smjena nije za danas, nije moguće prijaviti radne sate"),
                                        duration: Duration(seconds: 3),
                                        backgroundColor:
                                            Color.fromARGB(255, 114, 30, 148)));
                              },
                      ),
                      onTap: danas
                          ? () {
                              showPrijavaDialog(raspored.rasporedSmjenaId!,
                                  !isDolazak, radniSati);
                            }
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Smjena nije za danas, nije moguće odjaviti radne sate"),
                                      duration: Duration(seconds: 3),
                                      backgroundColor:
                                          Color.fromARGB(255, 114, 30, 148)));
                            },
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
