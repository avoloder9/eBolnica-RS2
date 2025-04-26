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
      var result =
          await terapijaProvider.get(filter: {"PacijentId": pacijentId});
      setState(() {
        terapije = result.result;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
      return const Expanded(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Nema dostupnih terapija",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
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
            headingRowColor: MaterialStateProperty.all(
              Colors.blueGrey.shade50,
            ),
            headingTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
            dataRowHeight: 64,
            columnSpacing: 24,
            columns: const [
              DataColumn(label: Text("Nadležni doktor")),
              DataColumn(label: Text("Naziv")),
              DataColumn(label: Text("Opis")),
              DataColumn(label: Text("Početak")),
              DataColumn(label: Text("Završetak")),
            ],
            rows: List.generate(terapije!.length, (index) {
              final e = terapije![index];
              final isEven = index % 2 == 0;

              return DataRow(
                color: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    return isEven ? Colors.grey[50] : null;
                  },
                ),
                cells: [
                  DataCell(Text(
                      "${e.pregled!.uputnica!.termin!.doktor!.korisnik!.ime} ${e.pregled!.uputnica!.termin!.doktor!.korisnik!.prezime}")),
                  DataCell(Text(e.naziv ?? "-")),
                  DataCell(SizedBox(
                    width: 200,
                    child: Text(
                      e.opis ?? "-",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: const TextStyle(fontSize: 14),
                    ),
                  )),
                  DataCell(Text(formattedDate(e.datumPocetka))),
                  DataCell(Text(formattedDate(e.datumZavrsetka))),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
