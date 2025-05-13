import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/models/krevet_model.dart';
import 'package:ebolnica_desktop/providers/krevet_provider.dart';
import 'package:ebolnica_desktop/screens/novi_krevet_screen.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
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
  late KrevetProvider krevetProvider;
  List<Krevet>? kreveti = [];

  @override
  void initState() {
    super.initState();
    krevetProvider = KrevetProvider();
    _fetchKreveti();
  }

  Future<void> _fetchKreveti() async {
    var result = await krevetProvider.get(filter: {"SobaId": widget.sobaId});
    setState(() {
      kreveti = result.result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    userType: widget.userType,
                  );
                },
                barrierDismissible: false,
              ).then((value) {
                setState(() {
                  widget.userType;
                });
                _fetchKreveti();
              }),
              icon: const Icon(Icons.add),
              label: const Text("Dodaj novi krevet"),
            ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: kreveti == null || kreveti!.isEmpty
          ? buildEmptyView(
              context: context,
              screen: NoviKrevetScreen(
                sobaId: widget.sobaId,
                odjelId: widget.odjelId,
                userId: widget.userId,
                userType: widget.userType,
              ),
              message: "Nema kreveta na ovom odjelu",
              onDialogClosed: () {
                setState(() {});
                _fetchKreveti();
              },
            )
          : _buildResultView(),
    );
  }

  Widget _buildResultView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          columnSpacing: 20,
          headingRowHeight: 56,
          columns: const [
            DataColumn(
              label: Center(
                child: Text(
                  "Broj kreveta",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            DataColumn(
              label: Center(
                child: Text(
                  "Soba",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            DataColumn(
              label: Center(
                child: Text(
                  "Status",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            DataColumn(label: Text("")),
          ],
          rows: kreveti?.map<DataRow>((e) {
                return DataRow(
                  cells: [
                    DataCell(
                      SizedBox(
                        width: 100,
                        child: Center(
                          child: Text(
                            e.krevetId.toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 50,
                        child: Center(
                          child: Text(
                            e.soba!.naziv!,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 70,
                        child: Center(
                          child: Text(
                            e.zauzet == true ? "Zauzet" : "Slobodan",
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  e.zauzet == true ? Colors.red : Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      widget.userType == "administrator"
                          ? Tooltip(
                              message: e.zauzet == false
                                  ? "Ukloni krevet"
                                  : "Ne možete ukloniti krevet koji je zauzet",
                              child: ElevatedButton.icon(
                                  icon: const Icon(Icons.delete),
                                  label: const Text("Ukloni krevet"),
                                  onPressed: e.zauzet == false
                                      ? () async {
                                          showCustomDialog(
                                            context: context,
                                            title: "Obrisati krevet?",
                                            message:
                                                "Da li ste sigurni da želite ukloniti krevet?",
                                            confirmText: "Da",
                                            onConfirm: () async {
                                              try {
                                                await krevetProvider
                                                    .delete(e.krevetId!);
                                                await Flushbar(
                                                  message:
                                                      "Krevet je uspješno uklonjen!",
                                                  duration: const Duration(
                                                      seconds: 3),
                                                  backgroundColor: Colors.green,
                                                ).show(context);
                                              } catch (error) {
                                                await Flushbar(
                                                  message:
                                                      "Došlo je do greške prilikom uklanjanja pacijenta.",
                                                  duration: const Duration(
                                                      seconds: 3),
                                                  backgroundColor: Colors.red,
                                                ).show(context);
                                              }
                                              _fetchKreveti();
                                            },
                                          );
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: e.zauzet == false
                                        ? Colors.red
                                        : Colors.grey.shade400,
                                    foregroundColor: Colors.white,
                                  )),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                );
              }).toList() ??
              [],
        ),
      ),
    );
  }
}
