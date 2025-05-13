import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/providers/administrator_provider.dart';
import 'package:ebolnica_desktop/providers/doktor_provider.dart';
import 'package:ebolnica_desktop/providers/medicinsko_osoblje_provider.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:ebolnica_desktop/utils/password_validator.dart';
import 'package:ebolnica_desktop/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostavkeScreen extends StatefulWidget {
  final int userId;
  final String userType;
  final String? nazivOdjela;
  const PostavkeScreen(
      {super.key,
      required this.userId,
      required this.userType,
      this.nazivOdjela});

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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Nepoznat tip korisnika: ${widget.userType}')),
          );
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Greška pri dohvaćanju korisničkih podataka')),
      );
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
        updatedData["DatumRodjenja"] = DateFormat("dd.MM.yyyy")
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
          updatedData["OdjelId"] = userData.odjelId;
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Nepoznat tip korisnika ${widget.userType}')),
            );
            return;
        }
        setState(() {
          _isEditing = false;
          lozinkaController.text = "";
          lozinkaPotvrdaController.text = "";
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
      appBar: AppBar(title: const Text("Vaš profil")),
      drawer: SideBar(
        userId: widget.userId,
        userType: widget.userType,
        nazivOdjela: widget.nazivOdjela,
      ),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          tooltip: "Uredi ili sačuvaj izmjene",
                          icon: Icon(_isEditing ? Icons.save : Icons.edit),
                          onPressed: () {
                            setState(() {
                              if (_isEditing) _saveChanges();
                              _isEditing = true;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Ažurirajte informacije o svom profilu",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 120,
                                height: 160,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: _imageBytes != null
                                        ? MemoryImage(_imageBytes!)
                                        : (userData!.korisnik!.slika != null &&
                                                userData!.korisnik!.slika!
                                                    .isNotEmpty)
                                            ? MemoryImage(base64Decode(
                                                userData!.korisnik!.slika!))
                                            : const AssetImage(
                                                    'assets/images/osoba.jpg')
                                                as ImageProvider,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (_isEditing)
                              TextButton.icon(
                                onPressed: _pickImage,
                                icon: const Icon(Icons.upload),
                                label: const Text("Dodaj sliku"),
                              ),
                          ],
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                          child: Column(
                            children: [
                              Row(children: [
                                Expanded(
                                    child:
                                        _buildTextField("Ime", imeController)),
                                const SizedBox(width: 16),
                                Expanded(
                                    child: _buildTextField(
                                        "Prezime", prezimeController)),
                              ]),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                      child: _buildTextField(
                                          "Telefon", telefonController)),
                                  const SizedBox(width: 16),
                                  Expanded(
                                      child: _buildTextField(
                                          "Email", emailController)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                  "Datum rođenja", datumRodjenjaController,
                                  readOnly: true),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 32),
                    if (widget.userType == "doktor") ...[
                      _buildTextField(
                          "Specijalizacija", specijalizacijaController),
                      const SizedBox(height: 16),
                      _buildTextField("Biografija", biografijaController,
                          maxLines: 3),
                    ],
                    if (widget.userType == "pacijent") ...[
                      _buildTextField("Adresa", adresaController),
                    ],
                    if (_isEditing) ...[
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField("Lozinka", lozinkaController,
                                isPassword: true, optional: true),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                                "Potvrda lozinke", lozinkaPotvrdaController,
                                isPassword: true, optional: true),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    bool isPassword = false,
    bool optional = false,
    bool isDate = false,
    bool isBiografija = false,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly || isDate || !_isEditing,
        obscureText: isPassword,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        validator: (value) {
          if (!optional && (value == null || value.isEmpty)) {
            return "$label ne može biti prazno";
          }
          if (isPassword && value != null && value.isNotEmpty) {
            String passwordValidation =
                PasswordValidator.checkPasswordStrength(value);
            if (passwordValidation.isNotEmpty) {
              return passwordValidation;
            }

            if (label == "Lozinka" &&
                lozinkaPotvrdaController.text.isNotEmpty &&
                value != lozinkaPotvrdaController.text) {
              return "Lozinke se ne poklapaju";
            }

            if (label == "Potvrda lozinke" &&
                lozinkaController.text.isNotEmpty &&
                value != lozinkaController.text) {
              return "Lozinke se ne poklapaju";
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
