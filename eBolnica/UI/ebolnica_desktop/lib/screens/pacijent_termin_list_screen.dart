import 'package:ebolnica_desktop/models/termin_model.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';
import 'package:ebolnica_desktop/screens/novi_termin_screen.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TerminiScreen extends StatefulWidget {
  final int userId;
  const TerminiScreen({super.key, required this.userId});
  @override
  _TerminiScreenState createState() => _TerminiScreenState();
}

class _TerminiScreenState extends State<TerminiScreen> {
  int? pacijentId;
  late PacijentProvider pacijentProvider;
  List<Termin>? termini = [];
  @override
  void initState() {
    super.initState();
    pacijentProvider = PacijentProvider();
    //   fetchTermini();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
    setState(() {
      termini = [];
    });
    pacijentId =
        await pacijentProvider.getPacijentIdByKorisnikId(widget.userId);
    if (pacijentId != null) {
      var result = await pacijentProvider.getTerminByPacijentId(pacijentId!);
      setState(() {
        termini = result;
      });
    } else
      print("error");
  }

  @override
  Widget build(BuildContext context) {
    if (termini == null || termini!.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchTermini();
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Termini"),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return NoviTerminScreen(
                      pacijentId: pacijentId!,
                      userId: widget.userId,
                    );
                  },
                  barrierDismissible: false);
            },
            icon: const Icon(Icons.add),
            label: const Text("Dodaj novi termin"),
          ),
        ],
      ),
      drawer: SideBar(
        userType: 'pacijent',
        userId: widget.userId,
      ),
      body: Column(
        children: [_buildResultView()],
      ),
    );
  }

  Widget _buildResultView() {
    return Expanded(
        child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
            columns: const [
              DataColumn(label: Text("Ime i prezime doktora")),
              DataColumn(label: Text("Odjel")),
              DataColumn(label: Text("Datum termina")),
              DataColumn(label: Text("Vrijeme termina")),
              DataColumn(label: Text(" ")),
            ],
            rows: termini!
                .map<DataRow>(
                  (e) => DataRow(
                    cells: [
                      DataCell(Text(
                          "${e.doktor!.korisnik!.ime} ${e.doktor!.korisnik!.prezime}")),
                      DataCell(Text(e.odjel!.naziv.toString())),
                      DataCell(Text(formattedDate(e.datumTermina))),
                      DataCell(Text(formattedTime(e.vrijemeTermina!))),
                      DataCell(ElevatedButton(
                          child: const Text("Otkaži termin"),
                          onPressed: () {})),
                    ],
                  ),
                )
                .toList()),
      ),
    ));
  }
}
