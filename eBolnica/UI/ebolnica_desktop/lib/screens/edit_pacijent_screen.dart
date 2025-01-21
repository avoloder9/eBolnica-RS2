import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';

class EditPacijentScreen extends StatefulWidget {
  final int pacijentId;
  final VoidCallback onSave;

  const EditPacijentScreen({
    Key? key,
    required this.pacijentId,
    required this.onSave,
  }) : super(key: key);

  @override
  _EditPacijentScreenState createState() => _EditPacijentScreenState();
}

class _EditPacijentScreenState extends State<EditPacijentScreen> {
  late PacijentProvider provider;
  late TextEditingController _imeController;
  late TextEditingController _prezimeController;
  late TextEditingController _lozinkaController;
  late TextEditingController _lozinkaPotvrdaController;
  late TextEditingController _telefonController;
  late TextEditingController _adresaController;
  bool _status = true;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    provider = PacijentProvider();
    _imeController = TextEditingController();
    _prezimeController = TextEditingController();
    _lozinkaController = TextEditingController();
    _lozinkaPotvrdaController = TextEditingController();
    _telefonController = TextEditingController();
    _adresaController = TextEditingController();
    _loadPacijentData();
  }

  Future<void> _loadPacijentData() async {
    final pacijent = await provider.getById(widget.pacijentId);
    setState(() {
      _imeController.text = pacijent.korisnik!.ime;
      _prezimeController.text = pacijent.korisnik!.prezime;
      _telefonController.text = pacijent.korisnik!.telefon ?? '';
      _adresaController.text = pacijent.adresa ?? '';
      _status = pacijent.korisnik?.status ?? true;
      _isLoading = false;
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
        "Adresa": _adresaController.text,
        "Status": _status,
      };

      await provider.update(widget.pacijentId, updateRequest);
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
                    TextField(
                      controller: _adresaController,
                      decoration: const InputDecoration(labelText: "Adresa"),
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
