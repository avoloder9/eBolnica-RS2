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
  final Doktor? doktor;
  final Odjel? odjel;
  const NoviTerminScreen(
      {super.key,
      this.pacijentId,
      this.odjelId,
      required this.userId,
      this.userType,
      this.doktor,
      this.odjel});

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
  bool _isDateValid = true;
  bool _isTimeValid = true;
  @override
  void initState() {
    super.initState();
    odjelProvider = OdjelProvider();
    doktorProvider = DoktorProvider();
    terminProvider = TerminProvider();
    pacijentProvider = PacijentProvider();
    if (widget.doktor != null && widget.odjel != null) {
      odabraniDoktor = widget.doktor!;
      odabraniOdjel = widget.odjel!;
    }

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
        SearchResult<Doktor> fetchedResult = await doktorProvider
            .get(filter: {"OdjelId": odabraniOdjel!.odjelId!});
        debugPrint('Fetched Doktor: $fetchedResult');
        setState(() {
          resultDoktor = fetchedResult.result;
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
                if ((widget.userType != "medicinsko osoblje" &&
                        widget.odjel == null &&
                        widget.pacijentId == null) ||
                    (widget.doktor == null && widget.odjel == null))
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
                if (widget.doktor == null)
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
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("Odustani"),
                    ),
                    ElevatedButton(
                      onPressed: _zakaziTermin,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      child: const Text("Zakazi termin",
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
        validator: (value) => value == null ? 'Odaberite ${label}a' : null,
      ),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: pickDate,
          child: Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isDateValid ? Colors.grey.shade400 : Colors.red,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('yyyy-MM-dd').format(selectedDate),
                  style: const TextStyle(fontSize: 16),
                ),
                const Icon(Icons.calendar_today, color: Colors.blue),
              ],
            ),
          ),
        ),
        if (!_isDateValid)
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 8),
            child:
                Text("Odaberite datum.", style: TextStyle(color: Colors.red)),
          ),
      ],
    );
  }

  Widget _buildTimeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
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
                        _isTimeValid = true;
                      });
                    },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
        ),
        if (!_isTimeValid)
          const Padding(
            padding: EdgeInsets.only(top: 8.0, left: 8),
            child:
                Text("Odaberite termin.", style: TextStyle(color: Colors.red)),
          ),
      ],
    );
  }

  Future<void> _zakaziTermin() async {
    if (_formKey.currentState?.validate() ?? false) {
      var noviTermin = {
        "pacijentId": widget.pacijentId ?? odabraniPacijent?.pacijentId,
        "doktorId": widget.doktor?.doktorId ?? odabraniDoktor?.doktorId,
        "odjelId": widget.odjel?.odjelId ?? odabraniOdjel?.odjelId,
        "datumTermina": DateFormat('yyyy-MM-dd').format(selectedDate),
        "vrijemeTermina": "$time:00",
        "otkazano": false,
      };

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
        await terminProvider.insert(noviTermin);
        if (mounted) Navigator.pop(context);
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
        if (mounted) Navigator.pop(context);
        await Flushbar(
          message: "Došlo je do greške. Pokušajte ponovo.",
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ).show(context);
      }
    } else {
      setState(() {
        _isDateValid = true;
        _isTimeValid = time != null;
      });
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
