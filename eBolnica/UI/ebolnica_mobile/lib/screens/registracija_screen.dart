import 'dart:convert';
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_mobile/main.dart';
import 'package:ebolnica_mobile/providers/pacijent_provider.dart';
import 'package:ebolnica_mobile/utils/password_validator.dart';
import 'package:ebolnica_mobile/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/services.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int currentPage = 0;
  final TextEditingController imeController = TextEditingController();
  final TextEditingController prezimeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController korisnickoImeController = TextEditingController();
  final TextEditingController lozinkaController = TextEditingController();
  final TextEditingController lozinkaPotvrdaController =
      TextEditingController();
  final TextEditingController telefonController = TextEditingController();
  final TextEditingController adresaController = TextEditingController();
  late TextEditingController datumRodjenjaController;
  late PacijentProvider pacijentProvider;

  @override
  void initState() {
    super.initState();
    pacijentProvider = PacijentProvider();
    datumRodjenjaController = TextEditingController(
      text: datumRodjenja != null
          ? '${datumRodjenja!.day}/${datumRodjenja!.month}/${datumRodjenja!.year}'
          : '',
    );
  }

  DateTime? datumRodjenja;
  String spol = '';

  void _nextPage() {
    if (_formKey.currentState!.validate()) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        currentPage++;
      });
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      currentPage--;
    });
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  int _generateHealthCardNumber() {
    Random random = Random();
    return 10000 + random.nextInt(90000);
  }

  Future<void> _sendRegistrationRequest() async {
    if (_formKey.currentState?.validate() ?? false) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });

      final pacijent = {
        "ime": imeController.text,
        "prezime": prezimeController.text,
        "email": emailController.text,
        "korisnickoIme": korisnickoImeController.text,
        "lozinka": lozinkaController.text,
        "lozinkaPotvrda": lozinkaPotvrdaController.text,
        "datumRodjenja": datumRodjenja?.toIso8601String(),
        "telefon":
            telefonController.text.replaceAll(RegExp(r'[^0-9]'), '').trim(),
        "spol": spol,
        "adresa": adresaController.text,
        "brojZdravstveneKartice": _generateHealthCardNumber(),
        "dob": datumRodjenja != null ? _calculateAge(datumRodjenja!) : 0,
        "slika": _base64Image != null && _base64Image!.isNotEmpty
            ? _base64Image
            : null,
        "status": true
      };
      try {
        await pacijentProvider.insert(pacijent);

        Navigator.pop(context);

        imeController.clear();
        prezimeController.clear();
        emailController.clear();
        korisnickoImeController.clear();
        lozinkaController.clear();
        lozinkaPotvrdaController.clear();
        telefonController.clear();
        adresaController.clear();
        datumRodjenja = null;
        spol = '';

        setState(() {});
        if (!mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            Future.delayed(const Duration(seconds: 2), () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              }
            });

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: const Text("Registracija uspješna"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/images/success.png", height: 80),
                  const SizedBox(height: 10),
                  const Text("Korisnički nalog je uspješno kreiran."),
                ],
              ),
            );
          },
        );
      } catch (e) {
        Navigator.pop(context);
        await Flushbar(
          message: "Došlo je do greške. Pokušajte ponovo.",
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildFirstPage(),
                    _buildSecondPage(),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 140,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: currentPage == 0
                          ? () => Navigator.pop(context)
                          : _previousPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        currentPage == 0 ? "Odustani" : "Nazad",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: currentPage == 0
                          ? _nextPage
                          : _sendRegistrationRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        currentPage == 0 ? "Dalje" : "Registruj se",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFirstPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            const Center(
              child: Text(
                "Registracija",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40),
            _buildTextField(imeController, "Ime", Icons.person),
            _buildTextField(prezimeController, "Prezime", Icons.person_outline),
            _buildTextField(emailController, "Email", Icons.email,
                TextInputType.emailAddress),
            _buildTextField(korisnickoImeController, "Korisničko Ime",
                Icons.account_circle),
            _buildTextField(lozinkaController, "Lozinka", Icons.lock),
            _buildTextField(
                lozinkaPotvrdaController, "Lozinka potvrda", Icons.lock)
          ],
        ),
      ),
    );
  }

  Widget _buildSecondPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 55),
            GestureDetector(
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: datumRodjenja ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null && pickedDate != datumRodjenja) {
                  setState(() {
                    datumRodjenja = pickedDate;
                    datumRodjenjaController.text =
                        '${datumRodjenja!.day}/${datumRodjenja!.month}/${datumRodjenja!.year}';
                  });
                }
              },
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Datum Rođenja',
                    prefixIcon: const Icon(Icons.calendar_today,
                        color: Colors.blueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  controller: datumRodjenjaController,
                  validator: (value) {
                    if (datumRodjenja == null) {
                      return 'Molimo unesite datum rođenja';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),
            _buildTextField(
                telefonController, 'Telefon', Icons.phone, TextInputType.phone),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: spol.isEmpty ? null : spol,
              decoration: InputDecoration(
                labelText: 'Spol',
                prefixIcon: Icon(
                  spol == 'Muški' ? Icons.male : Icons.female,
                  color: Colors.blueAccent,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'Muški', child: Text('Muški')),
                DropdownMenuItem(value: 'zenski', child: Text('zenski')),
              ],
              onChanged: (value) {
                setState(() {
                  spol = value ?? '';
                });
              },
            ),
            const SizedBox(height: 15),
            _buildTextField(adresaController, 'Adresa', Icons.home),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: getImage,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: _image == null ? 'Odaberite sliku' : '',
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 108, 108, 108),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                child: Column(
                  children: [
                    if (_image != null)
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(_image!,
                                height: 150, fit: BoxFit.cover),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _image = null;
                                _base64Image = null;
                              });
                            },
                          ),
                        ],
                      )
                    else
                      const ListTile(
                        leading: Icon(Icons.image, color: Colors.blueAccent),
                        title: Text("Odaberite sliku"),
                        trailing:
                            Icon(Icons.file_upload, color: Colors.blueAccent),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      [TextInputType type = TextInputType.text]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        obscureText: label == "Lozinka" || label == "Lozinka potvrda",
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          counterText: label == "Telefon" ? '' : null,
        ),
        maxLength: label == "Telefon" ? 12 : null,
        inputFormatters: label == "Telefon"
            ? [
                FilteringTextInputFormatter.digitsOnly,
                PhoneNumberFormatter(),
              ]
            : null,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Molimo unesite $label";
          }
          if (label == "Ime" || label == "Prezime") {
            if (value[0] != value[0].toUpperCase()) {
              return "$label mora početi sa velikim slovom";
            }
          }
          if (label == "Email" &&
              !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return "Molimo unesite validan email";
          }
          if (label == "Lozinka") {
            String passwordValidation =
                PasswordValidator.checkPasswordStrength(value);
            if (passwordValidation.isNotEmpty) {
              return passwordValidation;
            }
          }
          if (label == "Lozinka potvrda" && value != lozinkaController.text) {
            return "Lozinke se ne poklapaju";
          }
          return null;
        },
      ),
    );
  }

  File? _image;
  String? _base64Image;

  void getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      setState(() {
        _image = File(result.files.single.path!);
        _base64Image = base64Encode(_image!.readAsBytesSync());
      });
    }
  }
}
