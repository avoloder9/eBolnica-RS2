import 'package:ebolnica_desktop/models/terapija_model.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';
import 'package:ebolnica_desktop/providers/terapija_provider.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
import 'package:flutter/material.dart';

class TerapijaScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  const TerapijaScreen({super.key, required this.userId, this.userType});
  @override
  _TerapijaScreenState createState() => _TerapijaScreenState();
}

class _TerapijaScreenState extends State<TerapijaScreen> {
  int? pacijentId;
  late PacijentProvider pacijentProvider;
  late TerapijaProvider terapijaProvider;
  List<Terapija>? terapije = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    pacijentProvider = PacijentProvider();
    terapijaProvider = TerapijaProvider();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchTerapije();
  }

  Future<void> fetchTerapije() async {
    setState(() {
      terapije = [];
      _isLoading = true;
    });
    pacijentId =
        await pacijentProvider.getPacijentIdByKorisnikId(widget.userId);
    if (pacijentId != null) {
      var result = await pacijentProvider.getTerapijaByPacijentId(pacijentId!);
      setState(() {
        terapije = result;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (terapije == null || terapije!.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchTerapije();
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Termini"),
      ),
      drawer: SideBar(
        userType: widget.userType!,
        userId: widget.userId,
      ),
      body: Column(
        children: [_buildResultView()],
      ),
    );
  }

  Widget _buildResultView() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (terapije == null || terapije!.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            "Nema dostupnih terapija",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    return Expanded(
        child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
            columns: const [
              DataColumn(label: Text("Nadležni doktor")),
              DataColumn(label: Text("Naziv")),
              DataColumn(label: Text("Opis")),
              DataColumn(label: Text("Datum pocetka terapije")),
              DataColumn(label: Text("Datum zavrsetka terapije")),
            ],
            rows: terapije!
                .map<DataRow>(
                  (e) => DataRow(
                    cells: [
                      DataCell(Text(
                          "${e.pregled!.uputnica!.termin!.doktor!.korisnik!.ime} ${e.pregled!.uputnica!.termin!.doktor!.korisnik!.prezime}")),
                      DataCell(Text(e.naziv.toString())),
                      DataCell(Text(e.opis.toString())),
                      DataCell(Text(formattedDate(e.datumPocetka))),
                      DataCell(Text(formattedDate(e.datumZavrsetka))),
                    ],
                  ),
                )
                .toList()),
      ),
    ));
  }
}
