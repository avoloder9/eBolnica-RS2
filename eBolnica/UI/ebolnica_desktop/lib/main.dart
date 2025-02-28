import 'dart:convert';

import 'package:ebolnica_desktop/providers/auth_provider.dart';
import 'package:ebolnica_desktop/providers/base_provider.dart';
import 'package:ebolnica_desktop/providers/korisnik_provider.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';
import 'package:ebolnica_desktop/screens/dashboard_doctor.dart';
import 'package:ebolnica_desktop/screens/dashboard_medical_staff.dart';
import 'package:ebolnica_desktop/screens/dashboard_admin.dart';
import 'package:ebolnica_desktop/screens/pacijent_termin_list_screen.dart';
import 'package:ebolnica_desktop/screens/registration_screen.dart';
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

  @override
  void initState() {
    super.initState();
    korisnikProvider = KorisnikProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Image.asset(
                'assets/images/logo.jpg',
                height: 120,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  labelText: 'Korisničko ime',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  errorText: usernameError,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  labelText: 'Lozinka',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  errorText: passwordError,
                ),
                onSubmitted: (_) {
                  _login();
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _login,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Prijavi se',
                          style: TextStyle(fontSize: 18.0),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  print('Zaboravili ste lozinku?');
                },
                child: const Text('Zaboravili ste lozinku?'),
              ),
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

    if (username.isEmpty) {
      setState(() {
        usernameError = "Molimo unesite korisničko ime";
        isLoading = false;
      });
      return;
    }
    if (password.isEmpty) {
      setState(() {
        passwordError = "Molimo unesite lozinku";
      });
      return;
    }
    if (password.length < 8) {
      setState(() {
        passwordError = "Lozinka mora imati najmanje 8 karaktera.";
      });
      return;
    }

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
            dashboard = DashboardDoctor(
              userId: userId,
              nazivOdjela: nazivOdjela!,
            );
            break;
          case 'medicinsko osoblje':
            dashboard = DashboardMedicalStaff(userId: userId);
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
