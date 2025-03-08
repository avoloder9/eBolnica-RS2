import 'package:ebolnica_mobile/models/raspored_smjena_model.dart';
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

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                shadowColor: Colors.black.withOpacity(0.2),
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
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${formattedTime(smjena!.vrijemePocetka!)} - ${formattedTime(smjena.vrijemeZavrsetka!)}',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
