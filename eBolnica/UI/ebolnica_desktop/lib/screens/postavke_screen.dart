import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/providers/administrator_provider.dart';
import 'package:ebolnica_desktop/providers/doktor_provider.dart';
import 'package:ebolnica_desktop/providers/medicinsko_osoblje_provider.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostavkeScreen extends StatefulWidget {
  final int userId;
  final String userType;
  const PostavkeScreen(
      {super.key, required this.userId, required this.userType});

  @override
  State<PostavkeScreen> createState() => _PostavkeScreenState();
}

class _PostavkeScreenState extends State<PostavkeScreen> {
  late DoktorProvider doktorProvider;
  late PacijentProvider pacijentProvider;
  late AdministratorProvider administratorProvider;
  late MedicinskoOsobljeProvider osobljeProvider;

  bool _isEditing = false;
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
  TextEditingController adresaController = TextEditingController();

  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    doktorProvider = DoktorProvider();
    administratorProvider = AdministratorProvider();
    osobljeProvider = MedicinskoOsobljeProvider();
    pacijentProvider = PacijentProvider();
    _fetchUserData();
  }

  String formattedDate(date) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  dynamic userData;
  int? entityId;
  Future<void> _fetchUserData() async {
    try {
      switch (widget.userType) {
        case 'administrator':
          entityId = await administratorProvider
              .getAdministratorIdByKorisnikId(widget.userId);
          if (entityId != null) {
            userData = await administratorProvider.getById(entityId!);
          }
          break;

        case 'doktor':
          entityId =
              await doktorProvider.getDoktorIdByKorisnikId(widget.userId);
          if (entityId != null) {
            userData = await doktorProvider.getById(entityId!);
          }
          break;
        case 'pacijent':
          entityId =
              await pacijentProvider.getPacijentIdByKorisnikId(widget.userId);
          if (entityId != null) {
            userData = await pacijentProvider.getById(entityId!);
          }
          break;
        case 'medicinsko osoblje':
          entityId =
              await osobljeProvider.getOsobljeByKorisnikId(widget.userId);
          if (entityId != null) {
            userData = await osobljeProvider.getById(entityId!);
          }
          break;

        default:
          print("Nepoznat tip korisnika: ${widget.userType}");
          return;
      }
      if (userData != null) {
        setState(() {
          imeController.text = userData.korisnik!.ime;
          prezimeController.text = userData.korisnik!.prezime;
          telefonController.text = userData.korisnik!.telefon ?? '';
          emailController.text = userData.korisnik!.email;
          datumRodjenjaController.text =
              userData.korisnik!.datumRodjenja != null
                  ? formattedDate(userData.korisnik!.datumRodjenja!)
                  : '';

          if (widget.userType == "doktor") {
            biografijaController.text = userData.biografija ?? '';
            specijalizacijaController.text = userData.specijalizacija;
          }
          if (widget.userType == "pacijent") {
            adresaController.text = userData.adresa ?? '';
          }

          if (userData.korisnik!.slika != null &&
              userData.korisnik!.slika!.isNotEmpty) {
            try {
              _imageBytes = base64Decode(userData.korisnik!.slika!);
            } catch (e) {
              _imageBytes = null;
            }
          } else {
            _imageBytes = null;
          }
        });
      }
    } catch (e) {
      print("Error fetching user data :$e");
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
          if (userData != null && userData!.korisnik != null) {
            if (_imageBytes != null) {
              String base64String = base64Encode(_imageBytes!);
              userData!.korisnik!.slika = base64String;
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
        updatedData["DatumRodjenja"] = DateFormat("dd/MM/yyyy")
            .parse(datumRodjenjaController.text)
            .toIso8601String();
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
      if (widget.userType == "pacijent") {
        if (adresaController.text.isNotEmpty) {
          updatedData["Adresa"] = adresaController.text;
        }
      }
      if (widget.userType == "medicinsko osoblje") {
        if (userData != null && userData.odjel != null) {
          updatedData["Odjel"] = userData.odjel;
        }
      }
      if (_imageBytes != null) {
        updatedData["Slika"] = base64Encode(_imageBytes!);
      }

      try {
        switch (widget.userType) {
          case 'administrator':
            await administratorProvider.update(entityId!, updatedData);
            break;
          case 'doktor':
            await doktorProvider.update(entityId!, updatedData);
            break;
          case 'pacijent':
            await pacijentProvider.update(entityId!, updatedData);
            break;
          case 'medicinsko osoblje':
            await osobljeProvider.update(entityId!, updatedData);
            break;

          default:
            print("Nepoznat tip korisnika: ${widget.userType}");
            return;
        }
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
      appBar: AppBar(title: const Text("Postavke")),
      drawer: SideBar(userId: widget.userId, userType: widget.userType),
      body: userData == null
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
                            borderRadius: BorderRadius.circular(10),
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
                                      : (userData!.korisnik!.slika != null &&
                                              userData!
                                                  .korisnik!.slika!.isNotEmpty)
                                          ? MemoryImage(base64Decode(
                                              userData!.korisnik!.slika!))
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
                      _buildTextField("Datum rođenja", datumRodjenjaController,
                          isDate: true),
                      if (widget.userType == "doktor") ...[
                        _buildTextField(
                            "Specijalizacija", specijalizacijaController),
                        _buildTextField("Biografija", biografijaController,
                            maxLines: 3, isBiografija: true),
                      ],
                      if (widget.userType == "pacijent")
                        _buildTextField("Adresa", adresaController),
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
      {int maxLines = 1,
      bool isPassword = false,
      bool isOptional = false,
      bool isDate = false,
      bool isBiografija = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: isDate || !_isEditing,
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
            if (value.length < 8) {
              return "Lozinka mora imati najmanje 8 karaktera";
            }
          }
          if (isBiografija && value != null && value.isNotEmpty) {
            if (value.length > 255) {
              return "Biografija može imati maksimalno 255 karaktera";
            }
          }
          return null;
        },
      ),
    );
  }
}
