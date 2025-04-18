import 'package:ebolnica_desktop/models/Response/pregledi_response.dart';
import 'package:ebolnica_desktop/models/terapija_model.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';
import 'package:ebolnica_desktop/providers/terapija_provider.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
import 'package:flutter/material.dart';

class PacijentPreglediScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  const PacijentPreglediScreen(
      {super.key, required this.userId, this.userType});

  @override
  _PacijentPreglediScreenState createState() => _PacijentPreglediScreenState();
}

class _PacijentPreglediScreenState extends State<PacijentPreglediScreen> {
  late PacijentProvider pacijentProvider;
  late TerapijaProvider terapijaProvider;
  int? pacijentId;
  Terapija? terapija;
  List<PreglediResponse>? pregledi = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    pacijentProvider = PacijentProvider();
    terapijaProvider = TerapijaProvider();
    fetchPregledi();
  }

  Future<void> fetchTerapija(int pregledId) async {
    var result = await terapijaProvider.getTerapijabyPregledId(pregledId);
    setState(() {
      terapija = result;
    });
  }

  Future<void> fetchPregledi() async {
    setState(() {
      pregledi = [];
      _isLoading = true;
    });
    pacijentId =
        await pacijentProvider.getPacijentIdByKorisnikId(widget.userId);
    if (pacijentId != null) {
      var result = await pacijentProvider.getPreglediByPacijentId(pacijentId!);
      setState(() {
        pregledi = result;
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
        title: const Text("Pregledi"),
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

    if (pregledi == null || pregledi!.isEmpty) {
      return const Expanded(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Nema obavljenih pregleda",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
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
            dataRowColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.blue.withOpacity(0.2);
                }
                return null;
              },
            ),
            dataTextStyle: const TextStyle(
              fontSize: 14,
            ),
            columnSpacing: 24,
            columns: const [
              DataColumn(label: Text("Doktor")),
              DataColumn(label: Text("Odjel")),
              DataColumn(label: Text("Datum pregleda")),
              DataColumn(label: Text("Glavna dijagnoza")),
              DataColumn(label: Text("Anamneza")),
              DataColumn(label: Text("Zaključak")),
              DataColumn(label: Text("Terapija")),
            ],
            rows: pregledi!.map<DataRow>(
              (e) {
                return DataRow(
                  cells: [
                    DataCell(Text("${e.imeDoktora} ${e.prezimeDoktora}")),
                    DataCell(Text(e.nazivOdjela)),
                    DataCell(Text(formattedDate(e.datumTermina))),
                    DataCell(
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 150),
                        child: Text(
                          e.glavnaDijagnoza,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 150),
                        child: Text(
                          e.anamneza,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 150),
                        child: Text(
                          e.zakljucak,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 150),
                        child: FutureBuilder<Terapija?>(
                          future: terapijaProvider
                              .getTerapijabyPregledId(e.pregledId),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text(
                                "Nije određena terapija nakon pregleda",
                                style: TextStyle(color: Colors.red),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data == null) {
                              return const Text("—");
                            } else {
                              return Text(
                                snapshot.data!.opis ?? "",
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}
