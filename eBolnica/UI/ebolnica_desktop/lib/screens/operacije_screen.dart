import 'package:ebolnica_desktop/models/operacija_model.dart';
import 'package:ebolnica_desktop/providers/doktor_provider.dart';
import 'package:ebolnica_desktop/providers/operacija_provider.dart';
import 'package:ebolnica_desktop/screens/nova_operacija_screen.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
import 'package:flutter/material.dart';

class OperacijaScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  final String? nazivOdjela;

  const OperacijaScreen(
      {super.key, required this.userId, this.userType, this.nazivOdjela});
  @override
  _OperacijaScreenState createState() => _OperacijaScreenState();
}

class _OperacijaScreenState extends State<OperacijaScreen> {
  late DoktorProvider doktorProvider;
  late OperacijaProvider operacijaProvider;
  List<Operacija>? operacije = [];
  int? doktorId;
  @override
  void initState() {
    super.initState();
    doktorProvider = DoktorProvider();
    operacijaProvider = OperacijaProvider();
    fetchOperacije();
  }

  Future<void> fetchOperacije() async {
    operacije = [];
    doktorId = await doktorProvider.getDoktorIdByKorisnikId(widget.userId);
    if (doktorId != null) {
      var result = await operacijaProvider.get(filter: {"DoktorId": doktorId});
      setState(() {
        operacije = result.result;
      });
      if (operacije == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nema operacija za ovog doktora')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nije pronadjen doktor')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Lista operacija"),
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return NovaOperacijaScreen(
                        userId: widget.userId,
                        doktorId: doktorId,
                        userType: widget.userType,
                        nazivOdjela: widget.nazivOdjela,
                      );
                    },
                    barrierDismissible: false);
              },
              icon: const Icon(Icons.add),
              label: const Text("Dodaj operaciju"),
            ),
          ],
        ),
        drawer: SideBar(
          userId: widget.userId,
          userType: widget.userType!,
          nazivOdjela: widget.nazivOdjela,
        ),
        body: operacije == null || operacije!.isEmpty
            ? buildEmptyView(
                context: context,
                screen: NovaOperacijaScreen(userId: widget.userId),
                message: "Nema zakazanih operacija")
            : _buildResultView());
  }

  Widget _buildResultView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
            columns: const [
              DataColumn(label: Text("Pacijent")),
              DataColumn(label: Text("Datum operacija")),
              DataColumn(label: Text("Tip operacije")),
              DataColumn(label: Text("Komentar")),
              DataColumn(label: Text("Status")),
            ],
            rows: operacije!
                .map<DataRow>((e) => DataRow(cells: [
                      DataCell(Text(
                          "${e.pacijent!.korisnik!.ime} ${e.pacijent!.korisnik!.prezime}")),
                      DataCell(Text(formattedDate(e.datumOperacije))),
                      DataCell(Text(e.tipOperacije!)),
                      DataCell(Text(e.komentar!)),
                      DataCell(buildOperacijaButtons(context, e.operacijaId!))
                    ]))
                .toList()),
      ),
    );
  }

  Widget buildOperacijaButtons(BuildContext context, int operacijaId) {
    return operacijaProvider.buildOperacijaButtons(context, operacijaId, () {
      fetchOperacije().then((_) {
        setState(() {});
      });
    });
  }
}
