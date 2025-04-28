import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/main.dart';
import 'package:ebolnica_desktop/models/pacijent_model.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';
import 'package:ebolnica_desktop/utils/password_validator.dart';
import 'package:ebolnica_desktop/utils/validator.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController imeController = TextEditingController();
  final TextEditingController prezimeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController korisnickoImeController = TextEditingController();
  final TextEditingController lozinkaController = TextEditingController();
  final TextEditingController lozinkaPotvrdaController =
      TextEditingController();
  final TextEditingController telefonController = TextEditingController();
  final TextEditingController adresaController = TextEditingController();
  late PacijentProvider pacijentProvider;
  @override
  void initState() {
    super.initState();
    pacijentProvider = PacijentProvider();
  }

  DateTime? datumRodjenja;
  String spol = '';

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

      final pacijent = Pacijent(
        ime: imeController.text,
        prezime: prezimeController.text,
        email: emailController.text,
        korisnickoIme: korisnickoImeController.text,
        lozinka: lozinkaController.text,
        lozinkaPotvrda: lozinkaPotvrdaController.text,
        datumRodjenja: datumRodjenja,
        telefon: telefonController.text,
        spol: spol,
        adresa: adresaController.text,
        brojZdravstveneKartice: _generateHealthCardNumber(),
        dob: datumRodjenja != null ? _calculateAge(datumRodjenja!) : 0,
      );

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
        await Flushbar(
                message: "Registracija uspješna.",
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3))
            .show(context);

        if (!mounted) return;
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        });
      } catch (e) {
        Navigator.pop(context);
        await Flushbar(
                message: "Došlo je do greške. Pokušajte ponovo.",
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3))
            .show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Image.asset(
              'assets/images/pozadina2.jpg',
              fit: BoxFit.cover,
              height: double.infinity,
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      const Text(
                        'Registracija pacijenta',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Unesite svoje podatke',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 40),
                      _buildTextField(
                        imeController,
                        'Ime',
                        validator: (value) => generalValidator(
                            value, 'ime', [notEmpty, startsWithCapital]),
                      ),
                      _buildTextField(
                        prezimeController,
                        'Prezime',
                        validator: (value) => generalValidator(
                            value, 'prezime', [notEmpty, startsWithCapital]),
                      ),
                      _buildTextField(
                        emailController,
                        'Email',
                        validator: (value) => generalValidator(
                            value, 'email', [notEmpty, validEmail]),
                      ),
                      _buildTextField(
                        korisnickoImeController,
                        'Korisničko ime',
                        validator: (value) => generalValidator(
                            value, 'korisničko ime', [notEmpty]),
                      ),
                      _buildTextField(lozinkaController, 'Lozinka',
                          obscureText: true, validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Molimo unesite lozinku';
                        }
                        String passwordValidation =
                            PasswordValidator.checkPasswordStrength(value);
                        if (passwordValidation.isNotEmpty) {
                          return passwordValidation;
                        }
                        return null;
                      }),
                      _buildTextField(
                          lozinkaPotvrdaController, 'Potvrdi lozinku',
                          obscureText: true, validator: (value) {
                        if (value != lozinkaController.text) {
                          return 'Lozinke se moraju poklapati';
                        }
                        return null;
                      }),
                      GestureDetector(
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: datumRodjenja ?? DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null &&
                              pickedDate != datumRodjenja) {
                            setState(() {
                              datumRodjenja = pickedDate;
                            });
                          }
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: TextEditingController(
                              text: datumRodjenja != null
                                  ? '${datumRodjenja!.day}.${datumRodjenja!.month}.${datumRodjenja!.year}'
                                  : '',
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Datum rođenja',
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            validator: (value) =>
                                dateValidator(datumRodjenja, 'datum rođenja'),
                          ),
                        ),
                      ),
                      _buildTextField(
                        telefonController,
                        'Telefon',
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        validator: (value) =>
                            generalValidator(value, 'telefon', [notEmpty]),
                      ),
                      DropdownButtonFormField<String>(
                        value: spol.isEmpty ? null : spol,
                        decoration: const InputDecoration(labelText: 'Spol'),
                        items: const [
                          DropdownMenuItem(
                              value: 'Muški', child: Text('Muški')),
                          DropdownMenuItem(
                              value: 'Ženski', child: Text('Ženski')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            spol = value ?? '';
                          });
                        },
                        validator: (value) => dropdownValidator(value, 'spol'),
                      ),
                      _buildTextField(
                        adresaController,
                        'Adresa',
                        validator: (value) =>
                            generalValidator(value, 'adresu', [notEmpty]),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _sendRegistrationRequest,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Registruj se',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Već imate nalog? Prijavite se'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool obscureText = false,
      int? maxLength,
      TextInputType? keyboardType,
      String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        maxLength: maxLength,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          counterText: '',
        ),
        validator: validator,
      ),
    );
  }
}
