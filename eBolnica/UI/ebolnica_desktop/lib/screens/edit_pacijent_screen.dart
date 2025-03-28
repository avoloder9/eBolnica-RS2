import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';

class EditPacijentScreen extends StatefulWidget {
  final int pacijentId;
  final VoidCallback onSave;

  const EditPacijentScreen({
    super.key,
    required this.pacijentId,
    required this.onSave,
  });

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
      _imeController.text = pacijent.korisnik!.ime!;
      _prezimeController.text = pacijent.korisnik!.prezime!;
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
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white.withOpacity(0.9),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 60,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    "Ažurirati podatke?",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Da li ste sigurni da želite ažurirati podatke?",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Odustani"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("Da"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Ažuriranje podataka",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(_imeController, "Ime", Icons.person),
                  const SizedBox(height: 12),
                  _buildTextField(
                      _prezimeController, "Prezime", Icons.person_outline),
                  const SizedBox(height: 12),
                  _buildTextField(
                    _lozinkaController,
                    "Nova lozinka",
                    Icons.lock,
                    obscureText: true,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    _lozinkaPotvrdaController,
                    "Potvrda lozinke",
                    Icons.lock_outline,
                    obscureText: true,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(_telefonController, "Telefon", Icons.phone),
                  const SizedBox(height: 12),
                  _buildTextField(
                      _adresaController, "Adresa", Icons.location_on),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    value: _status,
                    onChanged: (value) {
                      setState(() {
                        _status = value;
                      });
                    },
                    title: const Text("Status"),
                    activeColor: Colors.blueAccent,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton("Odustani",
                          () => Navigator.of(context).pop(), Colors.grey),
                      _buildActionButton(
                          "Sačuvaj", _saveChanges, Colors.blueAccent),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
      ),
      child: Text(label),
    );
  }
}
