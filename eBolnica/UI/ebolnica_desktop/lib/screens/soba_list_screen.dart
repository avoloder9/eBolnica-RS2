import 'package:ebolnica_desktop/models/soba_model.dart';
import 'package:ebolnica_desktop/providers/soba_provider.dart';
import 'package:ebolnica_desktop/screens/krevet_list_screen.dart';
import 'package:ebolnica_desktop/screens/nova_soba_screen.dart';
import 'package:ebolnica_desktop/screens/odjel_list_screen.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
import 'package:flutter/material.dart';

class SobaListScreen extends StatefulWidget {
  final int odjelId;
  final int userId;
  final String? userType;
  const SobaListScreen(
      {super.key, required this.odjelId, required this.userId, this.userType});

  @override
  _SobaListScreenState createState() => _SobaListScreenState();
}

class _SobaListScreenState extends State<SobaListScreen> {
  List<Soba>? sobe = [];
  late SobaProvider sobaProvider;
  @override
  void initState() {
    super.initState();
    sobaProvider = SobaProvider();
    _fetchSobe();
  }

  Future<void> _fetchSobe() async {
    var result = await sobaProvider.getSobeByOdjelId(widget.odjelId);

    setState(() {
      sobe = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OdjelListScreen(
                userId: widget.userId,
                userType: widget.userType,
              ),
            ),
          );
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Lista soba"),
              actions: [
                if (widget.userType == "administrator")
                  ElevatedButton.icon(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return NovaSobaScreen(
                            odjelId: widget.odjelId,
                            userId: widget.userId,
                            userType: widget.userType);
                      },
                      barrierDismissible: false,
                    ).then((value) {
                      _fetchSobe();
                    }),
                    icon: const Icon(Icons.add),
                    label: const Text("Dodaj novu sobu"),
                  ),
              ],
            ),
            body: sobe == null || sobe!.isEmpty
                ? buildEmptyView(
                    context: context,
                    screen: NovaSobaScreen(
                      odjelId: widget.odjelId,
                      userId: widget.userId,
                      userType: widget.userType,
                    ),
                    message: "Nema soba na ovom odjelu")
                : _buildResultView()));
  }

  Widget _buildResultView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          columns: const [
            DataColumn(label: Text("Naziv")),
            DataColumn(
                label:
                    SizedBox(width: 100, child: Center(child: Text("Odjel")))),
            DataColumn(
                label: SizedBox(width: 150, child: Text("Broj kreveta"))),
            DataColumn(
                label:
                    SizedBox(width: 160, child: Center(child: Text("Status")))),
            DataColumn(label: Text("")),
          ],
          rows: sobe
                  ?.map<DataRow>((e) => DataRow(
                        cells: [
                          DataCell(Text(e.naziv.toString())),
                          DataCell(SizedBox(
                              width: 120,
                              child: Center(child: Text(e.odjel!.naziv!)))),
                          DataCell(SizedBox(
                              width: 90,
                              child: Center(
                                  child: Text(e.brojKreveta.toString())))),
                          DataCell(SizedBox(
                              width: 170,
                              child: Center(
                                  child: Text(e.zauzeta == true
                                      ? "Zauzeta"
                                      : "Slobodna")))),
                          DataCell(ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => KrevetListScreen(
                                            sobaId: e.sobaId!,
                                            odjelId: widget.odjelId,
                                            userId: widget.userId,
                                            userType: widget.userType,
                                          )));
                            },
                            child: const Text("Detalji"),
                          )),
                        ],
                      ))
                  .toList() ??
              [],
        ),
      ),
    );
  }
}
