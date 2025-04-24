import 'dart:convert';

import 'package:ebolnica_desktop/providers/auth_provider.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';
import 'package:ebolnica_desktop/providers/korisnik_provider.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';
import 'package:ebolnica_desktop/screens/dashboard_admin.dart';
import 'package:ebolnica_desktop/screens/doktor_termini_screen.dart';
import 'package:ebolnica_desktop/screens/odjel_termini_screen.dart';
import 'package:ebolnica_desktop/screens/pacijent_termin_list_screen.dart';
import 'package:ebolnica_desktop/screens/registration_screen.dart';
import 'package:ebolnica_desktop/utils/password_validator.dart';
import 'package:ebolnica_desktop/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => PacijentProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  String? usernameError;
  String? passwordError;
  late KorisnikProvider korisnikProvider;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    korisnikProvider = KorisnikProvider();
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
                padding: const EdgeInsets.symmetric(horizontal: 64.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dobrodošli',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Prijavite se da nastavite',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 40),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            style: const TextStyle(fontSize: 16),
                            decoration: const InputDecoration(
                              labelText: 'Korisničko ime',
                              labelStyle: TextStyle(color: Colors.grey),
                              border: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blueAccent),
                              ),
                            ),
                            validator: (value) =>
                                generalValidator(value, 'korisničko ime', [
                              notEmpty,
                            ]),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            style: const TextStyle(fontSize: 16),
                            onFieldSubmitted: (_) => _login(),
                            decoration: const InputDecoration(
                              labelText: 'Lozinka',
                              labelStyle: TextStyle(color: Colors.grey),
                              border: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blueAccent),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Molimo unesite lozinku';
                              }
                              if (value.trim().length < 8) {
                                return 'Lozinka mora imati najmanje 8 karaktera.';
                              }

                              String passwordValidation =
                                  PasswordValidator.checkPasswordStrength(
                                      value);
                              if (passwordValidation.isNotEmpty) {
                                return passwordValidation;
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                'Prijavi se',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const RegistrationScreen(),
                        ));
                      },
                      child: const Text('Nemate račun? Registrujte se'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _login() async {
    if (isLoading) return;
    setState(() {
      usernameError = null;
      passwordError = null;
    });

    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (!_formKey.currentState!.validate()) return;
    setState(() {
      isLoading = true;
    });
    try {
      var response =
          await korisnikProvider.login(username, password, 'desktop');
      if (response.containsKey('userType') && response.containsKey('userId')) {
        String userType = response['userType'];
        int userId = response['userId'];
        final String? nazivOdjela = response['odjel'];

        AuthProvider.username = _usernameController.text;
        AuthProvider.password = _passwordController.text;

        Widget dashboard;
        switch (userType) {
          case 'administrator':
            dashboard = DashboardAdmin(
              userId: userId,
              userType: userType,
            );
            break;
          case 'doktor':
            dashboard = DoktorTerminiScreen(
              userId: userId,
              nazivOdjela: nazivOdjela!,
            );
            break;
          case 'medicinsko osoblje':
            dashboard = OdjelTerminiScreen(
              userId: userId,
              userType: userType,
            );
            break;
          case 'pacijent':
            dashboard = TerminiScreen(
              userId: userId,
              userType: userType,
            );
            break;
          default:
            setState(() {
              usernameError = "Nepoznata uloga korisnika.";
              isLoading = false;
            });
            return;
        }
        _usernameController.clear();
        _passwordController.clear();

        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => dashboard),
        );
      } else {
        setState(() {
          Flushbar(
                  message: "Pogrešno korisničko ime ili lozinka.",
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3))
              .show(context);
        });
      }
    } catch (e) {
      String errorMessage = "Greška u komunikaciji s serverom.";

      if (e is UserFriendlyException) {
        errorMessage = e.message;
      } else if (e is http.ClientException) {
        errorMessage = "Nema internet konekcije.";
      } else if (e is FormatException) {
        errorMessage = "Neispravan odgovor sa servera.";
      } else if (e is http.Response) {
        if (e.statusCode == 400) {
          errorMessage = "Pogrešno korisničko ime ili lozinka.";
        } else if (e.statusCode == 403) {
          final errorResponse = jsonDecode(e.body);
          errorMessage = errorResponse['message'] ?? "Pristup odbijen.";
        } else if (e.statusCode == 500) {
          errorMessage = "Greška na serveru. Pokušajte kasnije.";
        }
      }

      Flushbar(
        message: errorMessage,
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ).show(context);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
