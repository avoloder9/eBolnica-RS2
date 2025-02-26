import 'package:ebolnica_desktop/models/hospitalizacija_model.dart';
import 'package:ebolnica_desktop/models/laboratorijski_nalaz_model.dart';
import 'package:ebolnica_desktop/models/medicinska_dokumentacija_model.dart';
import 'package:ebolnica_desktop/models/operacija_model.dart';
import 'package:ebolnica_desktop/models/otpusno_pismo_model.dart';
import 'package:ebolnica_desktop/models/pregled_model.dart';
import 'package:ebolnica_desktop/models/terapija_model.dart';
import 'package:ebolnica_desktop/providers/medicinska_dokumentacija_provider.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';
import 'package:ebolnica_desktop/providers/terapija_provider.dart';
import 'package:ebolnica_desktop/screens/nalaz_details_screen.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
import 'package:flutter/material.dart';

class MedicinskaDokumentacijaScreen extends StatefulWidget {
  final int pacijentId;
  const MedicinskaDokumentacijaScreen({super.key, required this.pacijentId});

  @override
  _MedicinskaDokumentacijaScreenState createState() =>
      _MedicinskaDokumentacijaScreenState();
}

class _MedicinskaDokumentacijaScreenState
    extends State<MedicinskaDokumentacijaScreen> {
  List<Pregled>? pregledi = [];
  List<Hospitalizacija>? hospizalizacije = [];
  List<OtpusnoPismo>? otpusnaPisma = [];
  List<Terapija>? terapije = [];
  List<Operacija>? operacije = [];
  List<LaboratorijskiNalaz>? nalazi = [];
  MedicinskaDokumentacijaProvider dokumentacijaProvider =
      MedicinskaDokumentacijaProvider();
  bool isLoading = true;
  PacijentProvider pacijentProvider = PacijentProvider();
  MedicinskaDokumentacija? dokumentacija;
  TerapijaProvider terapijaProvider = TerapijaProvider();
  @override
  void initState() {
    super.initState();
    pacijentProvider = PacijentProvider();
    dokumentacijaProvider = MedicinskaDokumentacijaProvider();
    terapijaProvider = TerapijaProvider();
    fetchMedicinskaDokumentacija();
    fetchPregledi(widget.pacijentId);
    fetchHospitalizacije(widget.pacijentId);
    fetchOtpusnaPisma(widget.pacijentId);
    fetchTerapije(widget.pacijentId);
    fetchOperacije(widget.pacijentId);
    fetchNalazi(widget.pacijentId);
  }

  void fetchNalazi(int pacijentId) async {
    try {
      var result = await pacijentProvider.GetNalaziByPacijentId(pacijentId);
      setState(() {
        nalazi = result;
        isLoading = false;
      });
    } catch (e) {
      print("Greška: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void fetchPregledi(int pacijentId) async {
    try {
      var result = await pacijentProvider.getPreglediByPacijentId(pacijentId);
      setState(() {
        pregledi = result;
        isLoading = false;
      });
    } catch (e) {
      print("Greška: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void fetchHospitalizacije(int pacijentId) async {
    try {
      var result =
          await pacijentProvider.getHospitalizacijeByPacijentId(pacijentId);
      setState(() {
        hospizalizacije = result;
        isLoading = false;
      });
    } catch (e) {
      print("Greska: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void fetchOtpusnaPisma(int pacijentId) async {
    try {
      var result =
          await pacijentProvider.getOtpusnaPismaByPacijentId(pacijentId);
      setState(() {
        otpusnaPisma = result;
        isLoading = false;
      });
    } catch (e) {
      print("Greska: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void fetchTerapije(int pacijentId) async {
    try {
      var result = await pacijentProvider.getTerapijaByPacijentId(pacijentId);
      setState(() {
        terapije = result;
        isLoading = false;
      });
    } catch (e) {
      print("Greska: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void fetchOperacije(int pacijentId) async {
    try {
      var result = await pacijentProvider.GetOperacijeByPacijentId(pacijentId);
      setState(() {
        operacije = result;
        isLoading = false;
      });
    } catch (e) {
      print("Greska: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: DefaultTabController(
          length: 6,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: isLoading
                    ? const Text(
                        "Učitavanje podataka...",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    : Text(
                        dokumentacija != null
                            ? "Medicinska Dokumentacija za ${dokumentacija!.pacijent!.korisnik!.ime} ${dokumentacija!.pacijent!.korisnik!.prezime} "
                            : "Medicinska Dokumentacija",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
              const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: "Pregledi"),
                  Tab(text: "Hospitalizacije"),
                  Tab(text: "Otpusna Pisma"),
                  Tab(text: "Terapije"),
                  Tab(text: "Laboratorijski Nalazi"),
                  Tab(text: "Operacije"),
                ],
              ),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : TabBarView(
                        children: [
                          _buildPregledi(),
                          _buildHospitalizacije(),
                          _buildOtpusnaPisma(),
                          _buildTerapije(),
                          _buildLaboratorijskiNalazi(),
                          _buildOperacije(),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPregledi() {
    if (pregledi == null || pregledi!.isEmpty) {
      return const Center(child: Text("Nema dostupnih pregleda."));
    }

    return ListView.builder(
      itemCount: pregledi!.length,
      itemBuilder: (context, index) {
        var pregled = pregledi![index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildInfoItem(
                    "Datum pregleda",
                    formattedDate(pregled.uputnica!.termin!.datumTermina),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _buildInfoItem(
                    "Odjel",
                    pregled.uputnica!.termin!.odjel!.naziv ?? 'Nepoznato',
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _buildInfoItem(
                    "Doktor",
                    "${pregled.uputnica!.termin!.doktor!.korisnik!.ime ?? ''} "
                        "${pregled.uputnica!.termin!.doktor!.korisnik!.prezime ?? ''}",
                  ),
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              showPregledDetailsDialog(context, pregled);
            },
          ),
        );
      },
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildHospitalizacije() {
    if (hospizalizacije == null || hospizalizacije!.isEmpty) {
      return const Center(child: Text("Nema dostupnih hospitalizacija."));
    }

    return ListView.builder(
      itemCount: hospizalizacije!.length,
      itemBuilder: (context, index) {
        var hospitalizacija = hospizalizacije![index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildInfoItem(
                    "Datum prijema",
                    formattedDate(hospitalizacija.datumPrijema),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _buildInfoItem(
                    "Datum otpusta",
                    hospitalizacija.datumOtpusta != null
                        ? formattedDate(hospitalizacija.datumOtpusta)
                        : '',
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _buildInfoItem(
                    "Doktor",
                    "${hospitalizacija.doktor!.korisnik!.ime ?? ''} "
                        "${hospitalizacija.doktor!.korisnik!.prezime ?? ''}",
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _buildInfoItem(
                      "Odjel", hospitalizacija.odjel!.naziv.toString()),
                ),
              ],
            ),
            onTap: () {},
          ),
        );
      },
    );
  }

  Widget _buildOtpusnaPisma() {
    if (otpusnaPisma == null || otpusnaPisma!.isEmpty) {
      return const Center(child: Text("Nema dostupnih otpusnih pisama."));
    }

    return ListView.builder(
      itemCount: otpusnaPisma!.length,
      itemBuilder: (context, index) {
        var otpusnoPismo = otpusnaPisma![index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildInfoItem(
                      "Datum otpusta",
                      formattedDate(
                          otpusnoPismo.hospitalizacija!.datumOtpusta)),
                ),
                Expanded(
                  flex: 3,
                  child: _buildInfoItem(
                    "Dijagnoza",
                    otpusnoPismo.dijagnoza.toString(),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _buildInfoItem(
                    "Anamneza",
                    otpusnoPismo.anamneza.toString(),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _buildInfoItem(
                    "Zakljucak",
                    otpusnoPismo.zakljucak.toString(),
                  ),
                ),
              ],
            ),
            onTap: () {},
          ),
        );
      },
    );
  }

  Widget _buildTerapije() {
    if (terapije == null || terapije!.isEmpty) {
      return const Center(child: Text("Nema dostupnih terapija."));
    }

    return ListView.builder(
      itemCount: terapije!.length,
      itemBuilder: (context, index) {
        var terapija = terapije![index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildInfoItem(
                    "Naziv prijema",
                    terapija.naziv.toString(),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _buildInfoItem(
                    "Opis",
                    terapija.opis.toString(),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _buildInfoItem(
                      "Datum pocetka", formattedDate(terapija.datumPocetka)),
                ),
                Expanded(
                  flex: 3,
                  child: _buildInfoItem("Datum završetka",
                      formattedDate(terapija.datumZavrsetka)),
                ),
              ],
            ),
            onTap: () {},
          ),
        );
      },
    );
  }

  Widget _buildLaboratorijskiNalazi() {
    if (nalazi == null || nalazi!.isEmpty) {
      return const Center(child: Text("Nema dostupnih nalaza."));
    }

    return ListView.builder(
      itemCount: nalazi!.length,
      itemBuilder: (context, index) {
        var nalaz = nalazi![index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildInfoItem(
                    "Naručio",
                    "${nalaz.doktor!.korisnik!.ime ?? ''} "
                        "${nalaz.doktor!.korisnik!.prezime ?? ''}",
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _buildInfoItem(
                    "Datum nalaza",
                    formattedDate(nalaz.datumNalaza),
                  ),
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      NalazDetaljiScreen(laboratorijskiNalaz: nalaz));
            },
          ),
        );
      },
    );
  }

  Widget _buildOperacije() {
    if (operacije == null || operacije!.isEmpty) {
      return const Center(child: Text("Nema dostupnih operacija."));
    }

    return ListView.builder(
      itemCount: operacije!.length,
      itemBuilder: (context, index) {
        var operacija = operacije![index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildInfoItem(
                    "Datum operacije",
                    formattedDate(operacija.datumOperacije),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _buildInfoItem(
                    "Doktor",
                    "${operacija.doktor!.korisnik!.ime} ${operacija.doktor!.korisnik!.prezime}",
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _buildInfoItem(
                      "Tip operacije", operacija.tipOperacije.toString()),
                ),
                Expanded(
                  flex: 3,
                  child:
                      _buildInfoItem("Komentar", operacija.komentar.toString()),
                ),
              ],
            ),
            onTap: () {},
          ),
        );
      },
    );
  }

  Widget _buildListView(List<String>? items) {
    if (items == null || items.isEmpty) {
      return const Center(child: Text("Nema podataka"));
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(items[index]),
        );
      },
    );
  }

  Future<MedicinskaDokumentacija> fetchMedicinskaDokumentacija() async {
    dokumentacija = await dokumentacijaProvider
        .getMedicinskaDokumentacijaByPacijentId(widget.pacijentId);
    return dokumentacija!;
  }

  void showPregledDetailsDialog(BuildContext context, Pregled pregled) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: FutureBuilder<Terapija?>(
            future: terapijaProvider.getTerapijabyPregledId(pregled.pregledId!),
            builder: (context, snapshot) {
              bool hasTerapija = snapshot.hasData && snapshot.data != null;
              double dialogHeight = hasTerapija
                  ? MediaQuery.of(context).size.height * 0.57
                  : MediaQuery.of(context).size.height * 0.35;

              return Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: dialogHeight,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Detalji pregleda",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow("Pacijent:",
                                "${pregled.uputnica!.termin!.pacijent!.korisnik!.ime} ${pregled.uputnica!.termin!.pacijent!.korisnik!.prezime}"),
                            _buildDetailRow(
                                "Datum pregleda:",
                                formattedDate(
                                    pregled.uputnica!.termin!.datumTermina)),
                            _buildDetailRow("Glavna dijagnoza:",
                                pregled.glavnaDijagnoza.toString()),
                            _buildDetailRow(
                                "Anamneza:", pregled.anamneza.toString()),
                            _buildDetailRow(
                                "Zaključak:", pregled.zakljucak.toString()),
                            if (hasTerapija) ...[
                              const SizedBox(height: 20),
                              const Text(
                                "Terapija",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const Divider(),
                              _buildDetailRow("Naziv terapije:",
                                  snapshot.data!.naziv.toString()),
                              _buildDetailRow(
                                  "Opis:", snapshot.data!.opis.toString()),
                              _buildDetailRow("Datum početka:",
                                  formattedDate(snapshot.data!.datumPocetka)),
                              _buildDetailRow("Datum završetka:",
                                  formattedDate(snapshot.data!.datumZavrsetka)),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Zatvori",
                            style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
