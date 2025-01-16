import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/main.dart';
import 'package:ebolnica_desktop/models/pacijent_model.dart';
import 'package:ebolnica_desktop/utils/password_validator.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:ebolnica_desktop/api_constants.dart';
import 'package:http/http.dart' as http;

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

      var url = Uri.parse('${ApiConstants.baseUrl}/Pacijent/register');
      try {
        var response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(pacijent.toJson()),
        );

        Navigator.pop(context);

        if (response.statusCode == 200) {
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
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          });
        } else {
          await Flushbar(
                  message: "Došlo je do greške. Pokušajte ponovo.",
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3))
              .show(context);
        }
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
      appBar: AppBar(
        title: const Text('Registracija Pacijenta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Column(
                children: [
                  const SizedBox(height: 10),
                  Image.asset(
                    'assets/images/logo.jpg',
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              TextFormField(
                controller: imeController,
                decoration: const InputDecoration(labelText: 'Ime'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Molimo unesite ime';
                  }
                  if (value[0] != value[0].toUpperCase()) {
                    return 'Ime mora početi sa velikim slovom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: prezimeController,
                decoration: const InputDecoration(labelText: 'Prezime'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Molimo unesite prezime';
                  }
                  if (value[0] != value[0].toUpperCase()) {
                    return 'Prezime mora početi sa velikim slovom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Molimo unesite validan email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: korisnickoImeController,
                decoration: const InputDecoration(labelText: 'Korisničko Ime'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Molimo unesite korisničko ime';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: lozinkaController,
                decoration: const InputDecoration(labelText: 'Lozinka'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Molimo unesite lozinku';
                  }
                  String passwordValidation =
                      PasswordValidator.checkPasswordStrength(value);
                  if (passwordValidation.isNotEmpty) {
                    return passwordValidation;
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: lozinkaPotvrdaController,
                decoration: const InputDecoration(labelText: 'Potvrdi Lozinku'),
                obscureText: true,
                validator: (value) {
                  if (value != lozinkaController.text) {
                    return 'Lozinke se moraju poklapati';
                  }
                  return null;
                },
              ),
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
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Datum Rođenja',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(
                      text: datumRodjenja != null
                          ? '${datumRodjenja!.day}/${datumRodjenja!.month}/${datumRodjenja!.year}'
                          : '',
                    ),
                    validator: (value) {
                      if (datumRodjenja == null) {
                        return 'Molimo unesite datum rođenja';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              TextFormField(
                controller: telefonController,
                decoration: const InputDecoration(labelText: 'Telefon'),
                keyboardType: TextInputType.phone,
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Molimo unesite broj telefona';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: spol.isEmpty ? null : spol,
                decoration: const InputDecoration(labelText: 'Spol'),
                items: const [
                  DropdownMenuItem(value: 'Muški', child: Text('Muški')),
                  DropdownMenuItem(value: 'Ženski', child: Text('Ženski')),
                ],
                onChanged: (value) {
                  setState(() {
                    spol = value ?? '';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Molimo odaberite spol';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: adresaController,
                decoration: const InputDecoration(labelText: 'Adresa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Molimo unesite adresu';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _sendRegistrationRequest,
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50)),
                child: const Text('Registruj se'),
              ),
              const SizedBox(
                height: 30,
                width: 60,
              ),
              Align(
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 350),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ));
                    },
                    child: const Text('Već imate nalog? Prijavite se'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
