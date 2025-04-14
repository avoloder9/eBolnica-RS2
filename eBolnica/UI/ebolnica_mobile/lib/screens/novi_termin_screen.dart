import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_mobile/models/doktor_model.dart';
import 'package:ebolnica_mobile/models/odjel_model.dart';
import 'package:ebolnica_mobile/models/pacijent_model.dart';
import 'package:ebolnica_mobile/models/search_result.dart';
import 'package:ebolnica_mobile/providers/doktor_provider.dart';
import 'package:ebolnica_mobile/providers/odjel_provider.dart';
import 'package:ebolnica_mobile/providers/pacijent_provider.dart';
import 'package:ebolnica_mobile/providers/termin_provider.dart';
import 'package:ebolnica_mobile/screens/odjel_termini_screen.dart';
import 'package:ebolnica_mobile/screens/pacijent_detalji_screen.dart';
import 'package:ebolnica_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoviTerminScreen extends StatefulWidget {
  final int? pacijentId;
  final int? odjelId;
  final int userId;
  final String? userType;
  const NoviTerminScreen(
      {super.key,
      this.pacijentId,
      this.odjelId,
      required this.userId,
      this.userType});

  @override
  _NoviTerminScreenState createState() => _NoviTerminScreenState();
}

class _NoviTerminScreenState extends State<NoviTerminScreen> {
  final _formKey = GlobalKey<FormState>();
  late DoktorProvider doktorProvider;
  late OdjelProvider odjelProvider;
  late TerminProvider terminProvider;
  late PacijentProvider pacijentProvider;
  List<Pacijent> pacijenti = [];
  Pacijent? odabraniPacijent;
  List<String> odjeli = [];
  Odjel? odabraniOdjel;
  Doktor? odabraniDoktor;
  List<Doktor>? resultDoktor;
  SearchResult<Odjel>? resultOdjel;
  List<String> zauzetiTermini = [];
  DateTime selectedDate = DateTime.now();
  String? time;

  @override
  void initState() {
    super.initState();
    odjelProvider = OdjelProvider();
    doktorProvider = DoktorProvider();
    terminProvider = TerminProvider();
    pacijentProvider = PacijentProvider();
    fetchOdjeli().then((_) {
      if (widget.odjelId != null && resultOdjel != null) {
        var matchingOdjel = resultOdjel!.result.firstWhere(
            (odjel) => odjel.odjelId == widget.odjelId,
            orElse: () => Odjel());
        if (matchingOdjel.odjelId != null) {
          setState(() {
            odabraniOdjel = matchingOdjel;
          });
          fetchDoktor();
        }
      }
    });
    if (widget.pacijentId == null) {
      fetchPacijente();
    }
  }

  void fetchPacijente() async {
    final result = await pacijentProvider.getPacijentSaDokumentacijom();
    setState(() {
      pacijenti = result;
    });
  }

  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        zauzetiTermini = [];
      });
      loadZauzetiTermini();
    }
  }

  Future<void> loadZauzetiTermini() async {
    try {
      var result = await terminProvider.getZauzetiTermini(
          selectedDate, odabraniDoktor!.doktorId!);
      setState(() {
        zauzetiTermini = result;
      });
    } catch (e) {
      debugPrint('Greška pri učitavanju zauzetih termina: $e');
    }
  }

  Future<void> fetchOdjeli() async {
    try {
      SearchResult<Odjel> fetchedResult = await odjelProvider.get();
      debugPrint('Fetched Odjeli: ${fetchedResult.result}');
      setState(() {
        resultOdjel = fetchedResult;
      });
    } catch (e) {
      debugPrint('Error fetching odjeli: $e');
    }
  }

  Future<void> fetchDoktor() async {
    try {
      if (odabraniOdjel != null && odabraniOdjel!.odjelId != null) {
        List<Doktor> fetchedResult =
            await odjelProvider.getDoktorByOdjelId(odabraniOdjel!.odjelId!);
        debugPrint('Fetched Doktor: $fetchedResult');
        setState(() {
          resultDoktor = fetchedResult;
        });
      } else {
        debugPrint("Odabrani odjel je null");
      }
    } catch (e) {
      debugPrint('Error fetching doktori: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Novi termin",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (widget.pacijentId == null)
                  _buildDropdown<Pacijent>(
                    label: "Pacijent",
                    icon: Icons.person,
                    value: odabraniPacijent,
                    items: pacijenti
                        .map((pacijent) => DropdownMenuItem(
                              value: pacijent,
                              child: Text(
                                  "${pacijent.korisnik!.ime} ${pacijent.korisnik!.prezime}"),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => odabraniPacijent = value),
                  ),
                if (widget.userType != "medicinsko osoblje")
                  _buildDropdown<Odjel>(
                    label: "Odjel",
                    icon: Icons.business,
                    value: odabraniOdjel,
                    items: resultOdjel?.result
                        .map((odjel) => DropdownMenuItem(
                              value: odjel,
                              child: Text(odjel.naziv!),
                            ))
                        .toList(),
                    onChanged: widget.odjelId != null
                        ? null
                        : (value) {
                            setState(() {
                              odabraniOdjel = value;
                              odabraniDoktor = null;
                              resultDoktor = [];
                            });
                            fetchDoktor();
                          },
                  )
                else
                  const SizedBox.shrink(),
                _buildDropdown<Doktor>(
                  label: "Doktor",
                  icon: Icons.medical_services,
                  value: odabraniDoktor,
                  items: (resultDoktor ?? [])
                      .map((doktor) => DropdownMenuItem(
                            value: doktor,
                            child: Text(
                                "${doktor.korisnik?.ime ?? "Nepoznato"} ${doktor.korisnik?.prezime ?? "Nepoznato"}"),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      odabraniDoktor = value;
                      zauzetiTermini = [];
                    });
                    loadZauzetiTermini();
                  },
                ),
                _buildDatePicker(),
                _buildTimeSelector(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Odustani"),
                    ),
                    ElevatedButton(
                      onPressed: _zakaziTermin,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      child: const Text("Zakaži termin",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required IconData icon,
    required T? value,
    required List<DropdownMenuItem<T>>? items,
    required void Function(T?)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: _inputDecoration(label, icon),
        items: items,
        onChanged: onChanged,
        validator: (value) => value == null ? 'Odaberite $label' : null,
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: pickDate,
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateFormat('yyyy-MM-dd').format(selectedDate),
                style: const TextStyle(fontSize: 16)),
            const Icon(Icons.calendar_today, color: Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: List.generate(12, (index) {
        int hour = 9 + index ~/ 3;
        int minute = (index % 3) * 20;
        String selectedTime =
            "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";

        bool isZauzet = zauzetiTermini.contains(selectedTime);
        bool isSelected = selectedTime == time;
        return GestureDetector(
          onTap: isZauzet
              ? null
              : () {
                  setState(() {
                    time = selectedTime;
                  });
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isZauzet
                  ? Colors.grey.shade400
                  : isSelected
                      ? Colors.green
                      : Colors.blue,
            ),
            child: Text(
              selectedTime,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
      }),
    );
  }

  Future<void> _zakaziTermin() async {
    if (_formKey.currentState?.validate() ?? false) {
      var noviTermin = {
        "pacijentId": widget.pacijentId ?? odabraniPacijent?.pacijentId,
        "doktorId": odabraniDoktor?.doktorId,
        "odjelId": odabraniOdjel?.odjelId,
        "datumTermina": DateFormat('yyyy-MM-dd').format(selectedDate),
        "vrijemeTermina": "$time:00",
        "otkazano": false,
      };

      try {
        await terminProvider.insert(noviTermin);
        if (!mounted) return;
        showCustomDialog(
            context: context,
            title: "",
            message: "Uspješno zakazan novi termin",
            imagePath: "assets/images/success.png");
        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;
        Navigator.pop(context, true);
        if (mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              if (widget.odjelId != null) {
                return OdjelTerminiScreen(
                  userId: widget.userId,
                  userType: widget.userType,
                );
              } else {
                return PacijentDetaljiScreen(
                    userId: widget.userId, userType: widget.userType);
              }
            },
          ),
        );
      } catch (e) {
        await Flushbar(
          message: "Došlo je do greške. Pokušajte ponovo.",
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ).show(context);
      }
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      prefixIcon: Icon(icon),
    );
  }
}
