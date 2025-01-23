import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/providers/medicinsko_osoblje_provider.dart';
import 'package:ebolnica_desktop/providers/odjel_provider.dart';
import 'package:flutter/material.dart';

class EditMedicinskoOsobljeScreen extends StatefulWidget {
  final int medicinskoOsobljeId;
  final VoidCallback onSave;

  const EditMedicinskoOsobljeScreen({
    super.key,
    required this.medicinskoOsobljeId,
    required this.onSave,
  });

  @override
  _EditMedicinskoOsobljeScreenState createState() =>
      _EditMedicinskoOsobljeScreenState();
}

class _EditMedicinskoOsobljeScreenState
    extends State<EditMedicinskoOsobljeScreen> {
  late MedicinskoOsobljeProvider provider;
  late OdjelProvider odjelProvider;
  late TextEditingController _imeController;
  late TextEditingController _prezimeController;
  late TextEditingController _lozinkaController;
  late TextEditingController _lozinkaPotvrdaController;
  late TextEditingController _telefonController;
  int? _selectedOdjelId;
  List<dynamic> _odjeli = [];
  bool _status = true;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    provider = MedicinskoOsobljeProvider();
    odjelProvider = OdjelProvider();
    _imeController = TextEditingController();
    _prezimeController = TextEditingController();
    _lozinkaController = TextEditingController();
    _lozinkaPotvrdaController = TextEditingController();
    _telefonController = TextEditingController();

    _loadOsobljeData();
    _loadOdjeli();
  }

  Future<void> _loadOsobljeData() async {
    final osoblje = await provider.getById(widget.medicinskoOsobljeId);
    setState(() {
      _imeController.text = osoblje.korisnik!.ime;
      _prezimeController.text = osoblje.korisnik!.prezime;
      _telefonController.text = osoblje.korisnik!.telefon ?? '';
      _status = osoblje.korisnik?.status ?? true;
      _selectedOdjelId = osoblje.odjelId;
      _isLoading = false;
    });
  }

  Future<void> _loadOdjeli() async {
    final odjeli = await odjelProvider.get();
    setState(() {
      _odjeli = odjeli.result;
    });
  }

  Future<void> _saveChanges() async {
    if (_lozinkaController.text != _lozinkaPotvrdaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lozinke se ne poklapaju!")),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Potvrda"),
          content: const Text("Da li ste sigurni da želite ažurirati podatke?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Ne"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Da"),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      final updateRequest = {
        "Ime": _imeController.text,
        "Prezime": _prezimeController.text,
        "Lozinka":
            _lozinkaController.text.isNotEmpty ? _lozinkaController.text : null,
        "Telefon": _telefonController.text,
        "Status": _status,
        "OdjelId": _selectedOdjelId,
      };

      await provider.update(widget.medicinskoOsobljeId, updateRequest);
      widget.onSave();
      Navigator.of(context).pop();

      Flushbar(
        message: "Podaci su uspješno ažurirani!",
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 450,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _imeController,
                      decoration: const InputDecoration(labelText: "Ime"),
                    ),
                    TextField(
                      controller: _prezimeController,
                      decoration: const InputDecoration(labelText: "Prezime"),
                    ),
                    TextField(
                      controller: _lozinkaController,
                      decoration:
                          const InputDecoration(labelText: "Nova lozinka"),
                      obscureText: true,
                    ),
                    TextField(
                      controller: _lozinkaPotvrdaController,
                      decoration:
                          const InputDecoration(labelText: "Potvrda lozinke"),
                      obscureText: true,
                    ),
                    TextField(
                      controller: _telefonController,
                      decoration: const InputDecoration(labelText: "Telefon"),
                    ),
                    DropdownButtonFormField<int>(
                      value: _selectedOdjelId,
                      items: _odjeli
                          .map((odjel) => DropdownMenuItem<int>(
                                value: odjel.odjelId,
                                child: Text(odjel.naziv ?? ''),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedOdjelId = value;
                        });
                      },
                      decoration: const InputDecoration(labelText: "Odjel"),
                    ),
                    SwitchListTile(
                      value: _status,
                      onChanged: (value) {
                        setState(() {
                          _status = value;
                        });
                      },
                      title: const Text("Status"),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Odustani"),
                        ),
                        ElevatedButton(
                          onPressed: _saveChanges,
                          child: const Text("Sačuvaj"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
