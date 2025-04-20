import 'package:ebolnica_desktop/models/Response/pregledi_response.dart';
import 'package:ebolnica_desktop/models/hospitalizacija_model.dart';
import 'package:ebolnica_desktop/models/laboratorijski_nalaz_model.dart';
import 'package:ebolnica_desktop/models/medicinska_dokumentacija_model.dart';
import 'package:ebolnica_desktop/models/operacija_model.dart';
import 'package:ebolnica_desktop/models/otpusno_pismo_model.dart';
import 'package:ebolnica_desktop/models/terapija_model.dart';
import 'package:ebolnica_desktop/providers/hospitalizacija_provider.dart';
import 'package:ebolnica_desktop/providers/laboratorijski_nalaz_provider.dart';
import 'package:ebolnica_desktop/providers/medicinska_dokumentacija_provider.dart';
import 'package:ebolnica_desktop/providers/operacija_provider.dart';
import 'package:ebolnica_desktop/providers/otpusno_pismo_provider.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';
import 'package:ebolnica_desktop/providers/terapija_provider.dart';
import 'package:ebolnica_desktop/screens/nalaz_detalji_screen.dart';
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
  List<PreglediResponse>? pregledi = [];
  List<Hospitalizacija>? hospizalizacije = [];
  List<OtpusnoPismo>? otpusnaPisma = [];
  List<Terapija>? terapije = [];
  List<Operacija>? operacije = [];
  List<LaboratorijskiNalaz>? nalazi = [];
  MedicinskaDokumentacijaProvider dokumentacijaProvider =
      MedicinskaDokumentacijaProvider();
  bool isLoading = true;
  PacijentProvider pacijentProvider = PacijentProvider();
  HospitalizacijaProvider hospitalizacijaProvider = HospitalizacijaProvider();
  OtpusnoPismoProvider otpusnoPismoProvider = OtpusnoPismoProvider();
  MedicinskaDokumentacija? dokumentacija;
  TerapijaProvider terapijaProvider = TerapijaProvider();
  LaboratorijskiNalazProvider nalazProvider = LaboratorijskiNalazProvider();
  OperacijaProvider operacijaProvider = OperacijaProvider();
  @override
  void initState() {
    super.initState();
    pacijentProvider = PacijentProvider();
    dokumentacijaProvider = MedicinskaDokumentacijaProvider();
    terapijaProvider = TerapijaProvider();
    hospitalizacijaProvider = HospitalizacijaProvider();
    otpusnoPismoProvider = OtpusnoPismoProvider();
    nalazProvider = LaboratorijskiNalazProvider();
    operacijaProvider = OperacijaProvider();
    fetchMedicinskaDokumentacija();
    fetchPregledi(widget.pacijentId);
    fetchHospitalizacije(widget.pacijentId);
    fetchTerapije(widget.pacijentId);
    fetchOtpusnaPisma(widget.pacijentId);
    fetchOperacije(widget.pacijentId);
    fetchNalazi(widget.pacijentId);
  }

  void fetchNalazi(int pacijentId) async {
    try {
      var result = await nalazProvider.get(filter: {"PacijentId": pacijentId});
      setState(() {
        nalazi = result.result;
        isLoading = false;
      });
    } catch (e) {
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
      setState(() {
        isLoading = false;
      });
    }
  }

  void fetchHospitalizacije(int pacijentId) async {
    try {
      var result =
          await hospitalizacijaProvider.get(filter: {"PacijentId": pacijentId});
      setState(() {
        hospizalizacije = result.result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void fetchOtpusnaPisma(int pacijentId) async {
    try {
      var result =
          await otpusnoPismoProvider.get(filter: {"PacijentId": pacijentId});
      setState(() {
        otpusnaPisma = result.result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void fetchTerapije(int pacijentId) async {
    try {
      var result =
          await terapijaProvider.get(filter: {"PacijentId": pacijentId});
      setState(() {
        terapije = result.result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void fetchOperacije(int pacijentId) async {
    try {
      var result =
          await operacijaProvider.get(filter: {"PacijentId": pacijentId});
      setState(() {
        operacije = result.result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<MedicinskaDokumentacija> fetchMedicinskaDokumentacija() async {
    dokumentacija = await dokumentacijaProvider
        .getMedicinskaDokumentacijaByPacijentId(widget.pacijentId);
    return dokumentacija!;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
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
        final pregled = pregledi![index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => showPregledDetailsDialog(context, pregled),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildDetailRowWithIcon(
                    icon: Icons.calendar_today,
                    label: "Datum pregleda:",
                    value: formattedDate(pregled.datumTermina),
                  ),
                  const SizedBox(height: 8),
                  buildDetailRowWithIcon(
                    icon: Icons.local_hospital,
                    label: "Odjel:",
                    value: pregled.nazivOdjela,
                  ),
                  const SizedBox(height: 8),
                  buildDetailRowWithIcon(
                    icon: Icons.person,
                    label: "Doktor:",
                    value: "${pregled.imeDoktora} ${pregled.prezimeDoktora}",
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHospitalizacije() {
    if (hospizalizacije == null || hospizalizacije!.isEmpty) {
      return const Center(child: Text("Nema dostupnih hospitalizacija."));
    }

    return ListView.builder(
      itemCount: hospizalizacije!.length,
      itemBuilder: (context, index) {
        final hospitalizacija = hospizalizacije![index];
        final doktor = hospitalizacija.doktor!.korisnik!;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildDetailRowWithIcon(
                    icon: Icons.date_range,
                    label: "Datum prijema:",
                    value: formattedDate(hospitalizacija.datumPrijema),
                  ),
                  const SizedBox(height: 8),
                  buildDetailRowWithIcon(
                    icon: Icons.exit_to_app,
                    label: "Datum otpusta:",
                    value: hospitalizacija.datumOtpusta != null
                        ? formattedDate(hospitalizacija.datumOtpusta!)
                        : "N/A",
                  ),
                  const SizedBox(height: 8),
                  buildDetailRowWithIcon(
                    icon: Icons.person,
                    label: "Doktor:",
                    value: "${doktor.ime} ${doktor.prezime}",
                  ),
                  const SizedBox(height: 8),
                  buildDetailRowWithIcon(
                    icon: Icons.local_hospital,
                    label: "Odjel:",
                    value: hospitalizacija.odjel!.naziv!,
                  ),
                ],
              ),
            ),
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
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildDetailRowWithIcon(
                    icon: Icons.calendar_today,
                    label: "Datum otpusta:",
                    value: formattedDate(
                        otpusnoPismo.hospitalizacija!.datumOtpusta),
                  ),
                  const SizedBox(height: 8),
                  buildDetailRowWithIcon(
                    icon: Icons.local_hospital,
                    label: "Dijagnoza:",
                    value: otpusnoPismo.dijagnoza ?? "N/A",
                  ),
                  const SizedBox(height: 8),
                  buildDetailRowWithIcon(
                    icon: Icons.note,
                    label: "Anamneza:",
                    value: otpusnoPismo.anamneza ?? "N/A",
                  ),
                  const SizedBox(height: 8),
                  buildDetailRowWithIcon(
                    icon: Icons.check_circle,
                    label: "Zaključak:",
                    value: otpusnoPismo.zakljucak ?? "N/A",
                  ),
                ],
              ),
            ),
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
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.medication, color: Colors.teal),
                    SizedBox(width: 8),
                    Text(
                      "Terapija",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                buildDetailRowWithIcon(
                  icon: Icons.label,
                  label: "Naziv terapije:",
                  value: terapija.naziv ?? "N/A",
                ),
                buildDetailRowWithIcon(
                  icon: Icons.description,
                  label: "Opis:",
                  value: terapija.opis ?? "N/A",
                ),
                buildDetailRowWithIcon(
                  icon: Icons.calendar_today,
                  label: "Datum početka:",
                  value: formattedDate(terapija.datumPocetka),
                ),
                buildDetailRowWithIcon(
                  icon: Icons.event_available,
                  label: "Datum završetka:",
                  value: formattedDate(terapija.datumZavrsetka),
                ),
              ],
            ),
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
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    NalazDetaljiScreen(laboratorijskiNalaz: nalaz),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.science, color: Colors.deepPurple),
                      SizedBox(width: 8),
                      Text(
                        "Laboratorijski nalaz",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  buildDetailRowWithIcon(
                    icon: Icons.person,
                    label: "Naručio:",
                    value:
                        "${nalaz.doktor?.korisnik?.ime ?? ''} ${nalaz.doktor?.korisnik?.prezime ?? ''}",
                  ),
                  buildDetailRowWithIcon(
                    icon: Icons.calendar_today,
                    label: "Datum nalaza:",
                    value: formattedDate(nalaz.datumNalaza),
                  ),
                ],
              ),
            ),
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
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.medical_services, color: Colors.redAccent),
                      SizedBox(width: 8),
                      Text(
                        "Operacija",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  buildDetailRowWithIcon(
                    icon: Icons.calendar_today,
                    label: "Datum operacije:",
                    value: formattedDate(operacija.datumOperacije),
                  ),
                  buildDetailRowWithIcon(
                    icon: Icons.person,
                    label: "Doktor:",
                    value:
                        "${operacija.doktor?.korisnik?.ime ?? ''} ${operacija.doktor?.korisnik?.prezime ?? ''}",
                  ),
                  buildDetailRowWithIcon(
                    icon: Icons.healing,
                    label: "Tip operacije:",
                    value: operacija.tipOperacije ?? "Nepoznato",
                  ),
                  buildDetailRowWithIcon(
                    icon: Icons.comment,
                    label: "Komentar:",
                    value: operacija.komentar ?? "Nema komentara",
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showPregledDetailsDialog(
      BuildContext context, PreglediResponse pregled) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: FutureBuilder<Terapija?>(
            future: terapijaProvider.getTerapijabyPregledId(pregled.pregledId),
            builder: (context, snapshot) {
              bool hasTerapija = snapshot.hasData && snapshot.data != null;
              double dialogHeight = hasTerapija
                  ? MediaQuery.of(context).size.height * 0.50
                  : MediaQuery.of(context).size.height * 0.3;

              return Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: dialogHeight,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "🩺 Detalji pregleda",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildDetailRowWithIcon(
                              icon: Icons.person,
                              label: "Pacijent:",
                              value:
                                  "${pregled.imePacijenta} ${pregled.prezimePacijenta}",
                            ),
                            buildDetailRowWithIcon(
                              icon: Icons.calendar_today,
                              label: "Datum pregleda:",
                              value: formattedDate(pregled.datumTermina),
                            ),
                            buildDetailRowWithIcon(
                              icon: Icons.assignment,
                              label: "Glavna dijagnoza:",
                              value: pregled.glavnaDijagnoza,
                            ),
                            buildDetailRowWithIcon(
                              icon: Icons.notes,
                              label: "Anamneza:",
                              value: pregled.anamneza,
                            ),
                            buildDetailRowWithIcon(
                              icon: Icons.check_circle_outline,
                              label: "Zaključak:",
                              value: pregled.zakljucak,
                            ),
                            if (hasTerapija) ...[
                              const SizedBox(height: 10),
                              const Divider(),
                              const Row(
                                children: [
                                  Icon(Icons.medical_services,
                                      size: 22, color: Colors.blueGrey),
                                  SizedBox(width: 8),
                                  Text(
                                    "Terapija",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              buildDetailRowWithIcon(
                                icon: Icons.label,
                                label: "Naziv terapije:",
                                value: snapshot.data!.naziv!,
                              ),
                              buildDetailRowWithIcon(
                                icon: Icons.description,
                                label: "Opis:",
                                value: snapshot.data!.opis ?? "N/A",
                              ),
                              buildDetailRowWithIcon(
                                icon: Icons.calendar_today,
                                label: "Datum početka:",
                                value:
                                    formattedDate(snapshot.data!.datumPocetka),
                              ),
                              buildDetailRowWithIcon(
                                icon: Icons.event_available,
                                label: "Datum završetka:",
                                value: formattedDate(
                                    snapshot.data!.datumZavrsetka),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                        ),
                        child: const Text(
                          "Zatvori",
                          style: TextStyle(fontSize: 16),
                        ),
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
}
