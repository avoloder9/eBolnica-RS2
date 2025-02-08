import 'package:ebolnica_desktop/models/krevet_model.dart';
import 'package:ebolnica_desktop/providers/krevet_provider.dart';
import 'package:ebolnica_desktop/screens/novi_krevet_screen.dart';
import 'package:ebolnica_desktop/screens/soba_list_screen.dart';
import 'package:flutter/material.dart';

class KrevetListScreen extends StatefulWidget {
  final int sobaId;
  final int odjelId;
  final int userId;
  final String? userType;

  const KrevetListScreen(
      {super.key,
      required this.sobaId,
      required this.odjelId,
      required this.userId,
      this.userType});
  @override
  State<KrevetListScreen> createState() => _KrevetListScreenState();
}

class _KrevetListScreenState extends State<KrevetListScreen> {
  late KrevetProvider provider;
  List<Krevet>? kreveti = [];

  @override
  void initState() {
    super.initState();
    provider = KrevetProvider();
    _fetchKreveti();
  }

  Future<void> _fetchKreveti() async {
    var result = await provider.getKrevetBySobaId(widget.sobaId);
    setState(() {
      kreveti = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SobaListScreen(
                odjelId: widget.odjelId,
                userId: widget.userId,
                userType: widget.userType),
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Lista kreveta"),
          actions: [
            if (widget.userType == "administrator")
              ElevatedButton.icon(
                onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return NoviKrevetScreen(
                      sobaId: widget.sobaId,
                      odjelId: widget.odjelId,
                      userId: widget.userId,
                    );
                  },
                  barrierDismissible: false,
                ).then((value) {
                  _fetchKreveti();
                }),
                icon: const Icon(Icons.add),
                label: const Text("Dodaj novi krevet"),
              ),
          ],
        ),
        body: Column(
          children: [_buildResultView()],
        ),
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
              DataColumn(label: Center(child: Text("Broj kreveta"))),
              DataColumn(label: Center(child: Text("Soba"))),
              DataColumn(label: Center(child: Text("Status"))),
            ],
            rows: kreveti
                    ?.map<DataRow>((e) => DataRow(
                          cells: [
                            DataCell(SizedBox(
                                width: 100,
                                child: Center(
                                    child: Text(e.krevetId.toString())))),
                            DataCell(SizedBox(
                                width: 50,
                                child: Center(child: Text(e.soba!.naziv!)))),
                            DataCell(SizedBox(
                                width: 70,
                                child: Center(
                                    child: Text(e.zauzet == true
                                        ? "Zauzet"
                                        : "Slobodan")))),
                          ],
                        ))
                    .toList() ??
                [],
          ),
        ),
      ),
    );
  }
}
