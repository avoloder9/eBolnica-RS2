import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/models/doktor_model.dart';
import 'package:ebolnica_desktop/providers/doktor_provider.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoktorPostavkeScreen extends StatefulWidget {
  final int userId;
  const DoktorPostavkeScreen({super.key, required this.userId});

  @override
  State<DoktorPostavkeScreen> createState() => _DoktorPostavkeScreenState();
}

class _DoktorPostavkeScreenState extends State<DoktorPostavkeScreen> {
  late DoktorProvider doktorProvider;
  int? doktorId;
  bool _isEditing = false;
  Doktor? _doktor;
  final _formKey = GlobalKey<FormState>();

  TextEditingController imeController = TextEditingController();
  TextEditingController prezimeController = TextEditingController();
  TextEditingController telefonController = TextEditingController();
  TextEditingController biografijaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController datumRodjenjaController = TextEditingController();
  TextEditingController specijalizacijaController = TextEditingController();
  TextEditingController lozinkaController = TextEditingController();
  TextEditingController lozinkaPotvrdaController = TextEditingController();

  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    doktorProvider = DoktorProvider();
    _fetchDoktorData();
  }

  String formattedDate(date) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  Future<void> _fetchDoktorData() async {
    try {
      doktorId = await doktorProvider.getDoktorIdByKorisnikId(widget.userId);
      if (doktorId != null) {
        Doktor doktor = await doktorProvider.getById(doktorId!);
        setState(() {
          _doktor = doktor;
          imeController.text = doktor.korisnik!.ime.toString();
          prezimeController.text = doktor.korisnik!.prezime.toString();
          telefonController.text = doktor.korisnik!.telefon ?? '';
          biografijaController.text = doktor.biografija ?? '';
          emailController.text = doktor.korisnik!.email.toString();
          datumRodjenjaController.text = doktor.korisnik!.datumRodjenja != null
              ? formattedDate(doktor.korisnik!.datumRodjenja!)
              : '';

          specijalizacijaController.text = doktor.specijalizacija.toString();

          if (doktor.korisnik!.slika != null &&
              doktor.korisnik!.slika!.isNotEmpty) {
            try {
              _imageBytes = base64Decode(doktor.korisnik!.slika!);
            } catch (e) {
              _imageBytes = null;
            }
          } else {
            _imageBytes = null;
          }
        });
      }
    } catch (e) {
      print("Error fetching doktor data: $e");
    }
  }

  Future<void> _pickImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      Uint8List? selectedBytes = result.files.single.bytes;

      if (selectedBytes == null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        selectedBytes = await file.readAsBytes();
      }

      if (selectedBytes != null) {
        setState(() {
          _imageBytes = selectedBytes;
          if (_doktor != null && _doktor!.korisnik != null) {
            if (_imageBytes != null) {
              String base64String = base64Encode(_imageBytes!);
              _doktor!.korisnik!.slika = base64String;
            }
          }
        });
      }
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      var updatedData = {
        "Ime": imeController.text,
        "Prezime": prezimeController.text,
        "Status": true,
      };

      if (telefonController.text.isNotEmpty) {
        updatedData["Telefon"] = telefonController.text;
      }
      if (emailController.text.isNotEmpty) {
        updatedData["Email"] = emailController.text;
      }
      if (datumRodjenjaController.text.isNotEmpty) {
        updatedData["DatumRodjenja"] = formattedDate(
            DateTime.parse(datumRodjenjaController.text).toIso8601String());
      }
      if (specijalizacijaController.text.isNotEmpty) {
        updatedData["Specijalizacija"] = specijalizacijaController.text;
      }
      if (biografijaController.text.isNotEmpty) {
        updatedData["Biografija"] = biografijaController.text;
      }
      if (lozinkaController.text.isNotEmpty &&
          lozinkaPotvrdaController.text.isNotEmpty) {
        updatedData["Lozinka"] = lozinkaController.text;
        updatedData["LozinkaPotvrda"] = lozinkaPotvrdaController.text;
      }
      if (_imageBytes != null) {
        updatedData["Slika"] = base64Encode(_imageBytes!);
      }

      try {
        await doktorProvider.update(doktorId!, updatedData);
        setState(() {
          _isEditing = false;
        });

        Flushbar(
          message: "Podaci uspješno ažurirani!",
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green,
        ).show(context);
      } catch (e) {
        Flushbar(
          message: "Greška prilikom ažuriranja: ${e.toString()}",
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Postavke doktora")),
      drawer: SideBar(userId: widget.userId, userType: "doktor"),
      body: _doktor == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: 120,
                              height: 170,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: _imageBytes != null
                                      ? MemoryImage(_imageBytes!)
                                          as ImageProvider
                                      : (_doktor!.korisnik!.slika != null &&
                                              _doktor!
                                                  .korisnik!.slika!.isNotEmpty)
                                          ? MemoryImage(base64Decode(
                                              _doktor!.korisnik!.slika!))
                                          : const AssetImage(
                                                  'assets/images/osoba.jpg')
                                              as ImageProvider,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (_isEditing)
                            ElevatedButton(
                              onPressed: _pickImage,
                              child: const Text("Dodaj sliku"),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildTextField("Ime", imeController),
                      _buildTextField("Prezime", prezimeController),
                      _buildTextField("Telefon", telefonController),
                      _buildTextField("Email", emailController),
                      _buildTextField("Datum rođenja", datumRodjenjaController),
                      _buildTextField(
                          "Specijalizacija", specijalizacijaController),
                      _buildTextField("Biografija", biografijaController,
                          maxLines: 3),
                      if (_isEditing) ...[
                        _buildTextField("Lozinka", lozinkaController,
                            isPassword: true, isOptional: true),
                        _buildTextField(
                            "Potvrda lozinke", lozinkaPotvrdaController,
                            isPassword: true, isOptional: true),
                      ],
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (_isEditing) {
                              _saveChanges();
                            }
                            _isEditing = true;
                          });
                        },
                        child: Text(_isEditing ? "Sačuvaj" : "Uredi"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1, bool isPassword = false, bool isOptional = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: !_isEditing,
        maxLines: maxLines,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (!isOptional && (value == null || value.isEmpty)) {
            return "$label ne može biti prazno";
          }
          if (isPassword && value != null && value.isNotEmpty) {
            if (value.length < 8)
              return "Lozinka mora imati najmanje 8 karaktera";
          }
          return null;
        },
      ),
    );
  }
}
