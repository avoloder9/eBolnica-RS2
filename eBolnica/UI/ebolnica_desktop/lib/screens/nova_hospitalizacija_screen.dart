import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/models/krevet_model.dart';
import 'package:ebolnica_desktop/models/pacijent_model.dart';
import 'package:ebolnica_desktop/models/soba_model.dart';
import 'package:ebolnica_desktop/providers/doktor_provider.dart';
import 'package:ebolnica_desktop/providers/hospitalizacija_provider.dart';
import 'package:ebolnica_desktop/providers/krevet_provider.dart';
import 'package:ebolnica_desktop/providers/medicinska_dokumentacija_provider.dart';
import 'package:ebolnica_desktop/providers/odjel_provider.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';
import 'package:ebolnica_desktop/providers/soba_provider.dart';
import 'package:ebolnica_desktop/screens/hospitalizacija_screen.dart';
import 'package:flutter/material.dart';

class NovaHospitalizacijaScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  final String? nazivOdjela;
  final int? doktorId;
  const NovaHospitalizacijaScreen(
      {super.key,
      required this.userId,
      this.userType,
      this.nazivOdjela,
      this.doktorId});
  @override
  _NovaHospitalizacijaScreenState createState() =>
      _NovaHospitalizacijaScreenState();
}

class _NovaHospitalizacijaScreenState extends State<NovaHospitalizacijaScreen> {
  final _formKey = GlobalKey<FormState>();
  late HospitalizacijaProvider hospitalizacijaProvider;
  late DoktorProvider doktorProvider;
  late PacijentProvider pacijentProvider;
  late OdjelProvider odjelProvider;
  late SobaProvider sobaProvider;
  late KrevetProvider krevetProvider;
  late MedicinskaDokumentacijaProvider dokumentacijaProvider;
  Pacijent? odabraniPacijent;
  List<Pacijent> pacijenti = [];
  int? odjelId;
  Soba? odabranaSoba;
  List<Soba> sobe = [];
  Krevet? odabraniKrevet;
  List<Krevet> kreveti = [];

  @override
  void initState() {
    super.initState();
    hospitalizacijaProvider = HospitalizacijaProvider();
    pacijentProvider = PacijentProvider();
    odjelProvider = OdjelProvider();
    sobaProvider = SobaProvider();
    krevetProvider = KrevetProvider();
    dokumentacijaProvider = MedicinskaDokumentacijaProvider();
    doktorProvider = DoktorProvider();
    fetchPacijenti();
    fetchOdjel();
  }

  Future<void> fetchPacijenti() async {
    var result = await pacijentProvider.getPacijentiZaHospitalizaciju();
    setState(() {
      pacijenti = result;
    });
  }

  Future<void> fetchOdjel() async {
    if (widget.doktorId == null) {
      return;
    }
    var result = await odjelProvider.getOdjelByDoktorId(widget.doktorId!);
    setState(() {
      odjelId = result!.odjelId;
    });
    fetchSobe();
  }

  Future<void> fetchSobe() async {
    if (odjelId == null) {
      return;
    }
    var result = await sobaProvider.getSlobodneSobeByOdjelId(odjelId!);
    setState(() {
      sobe = result;
    });
  }

  Future<void> fetchKreveti() async {
    if (odabranaSoba == null) {
      return;
    }
    var result =
        await krevetProvider.getSlobodanKrevetBySobaId(odabranaSoba!.sobaId!);
    setState(() {
      kreveti = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(15.0),
      title: const Center(
        child: Text(
          "Nova hospitalizacija",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: DropdownButtonFormField<Pacijent>(
                  value: odabraniPacijent,
                  decoration: InputDecoration(
                    labelText: 'Pacijent',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  items: pacijenti.map((pacijent) {
                    return DropdownMenuItem(
                      value: pacijent,
                      child: Text(
                          "${pacijent.korisnik!.ime} ${pacijent.korisnik!.prezime}"),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      odabraniPacijent = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Molimo odaberite pacijenta';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: DropdownButtonFormField<Soba>(
                  value: odabranaSoba,
                  decoration: InputDecoration(
                    labelText: 'Soba',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  items: sobe.map((soba) {
                    return DropdownMenuItem(
                      value: soba,
                      child: Text(soba.naziv.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      odabranaSoba = value;
                      odabraniKrevet = null;
                      kreveti = [];
                    });
                    if (odabranaSoba != null) {
                      fetchKreveti();
                    }
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Molimo odaberite sobu';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: DropdownButtonFormField<Krevet>(
                  value: odabraniKrevet,
                  decoration: InputDecoration(
                    labelText: 'Krevet',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  items: kreveti.map((krevet) {
                    return DropdownMenuItem(
                      value: krevet,
                      child: Text(krevet.krevetId.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      odabraniKrevet = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Molimo odaberite krevet';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Odustani")),
                      ElevatedButton(
                          onPressed: () async {
                            if (!(_formKey.currentState?.validate() ?? false)) {
                              return;
                            }
                            var dokumentacija = await dokumentacijaProvider
                                .getMedicinskaDokumentacijaByPacijentId(
                                    odabraniPacijent!.pacijentId!);

                            var doktorId = await await doktorProvider
                                .getDoktorIdByKorisnikId(widget.userId);
                            if (_formKey.currentState?.validate() ?? false) {
                              var novaHospitalizacija = {
                                "pacijentId": odabraniPacijent!.pacijentId,
                                "doktorId": doktorId,
                                "odjelId": odjelId,
                                "datumPrijema":
                                    DateTime.now().toIso8601String(),
                                "medicinskaDokumentacijaId":
                                    dokumentacija.medicinskaDokumentacijaId,
                                "sobaId": odabranaSoba!.sobaId,
                                "krevetId": odabraniKrevet!.krevetId
                              };
                              try {
                                await hospitalizacijaProvider
                                    .insert(novaHospitalizacija);
                                await Flushbar(
                                  message:
                                      "Pacijent je uspješno hospitalizovan",
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 3),
                                ).show(context);

                                if (mounted) {
                                  setState(() {
                                    odabraniPacijent = null;
                                    odabranaSoba = null;
                                    odabraniKrevet = null;
                                    sobe = [];
                                    kreveti = [];
                                  });
                                }
                                _formKey.currentState?.reset();
                                if (mounted) {
                                  await Future.wait([
                                    Future.delayed(const Duration(seconds: 1)),
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return HospitalizacijaScreen(
                                            userId: widget.userId,
                                            userType: widget.userType,
                                            nazivOdjela: widget.nazivOdjela);
                                      }),
                                    )
                                  ]);
                                  return;
                                }
                              } catch (e) {
                                await Flushbar(
                                        message:
                                            "Došlo je do greške. Pokušajte ponovo.",
                                        backgroundColor: Colors.red,
                                        duration: const Duration(seconds: 2))
                                    .show(context);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          child: const Text(
                            "Sačuvaj",
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  ))
            ]),
          ),
        ),
      ),
    );
  }
}
