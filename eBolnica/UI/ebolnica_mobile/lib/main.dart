import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_mobile/providers/auth_provider.dart';
import 'package:ebolnica_mobile/providers/base_provider.dart';
import 'package:ebolnica_mobile/providers/korisnik_provider.dart';
import 'package:ebolnica_mobile/screens/doktor_screen.dart';
import 'package:ebolnica_mobile/screens/osoblje_screen.dart';
import 'package:ebolnica_mobile/screens/pacijent_screen.dart';
import 'package:ebolnica_mobile/screens/registracija_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/pozadina2.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 50,
            right: 50,
            child: Image.asset(
              'assets/images/logo2.jpg',
              width: 100,
              color: const Color.fromRGBO(209, 213, 219, 80),
              height: 120,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 55,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  child: const Text(
                    "Prijava",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.grey[300],
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const RegistrationScreen()));
                  },
                  child: const Text(
                    "Registracija",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 39, 38, 38),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
  String? usernameError;
  String? passwordError;
  bool isLoading = false;
  late KorisnikProvider korisnikProvider;
  @override
  void initState() {
    super.initState();
    korisnikProvider = KorisnikProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Column(
                  children: <Widget>[
                    Text(
                      "Prijava",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          labelText: 'Korisničko ime',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          errorText: usernameError,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    padding: const EdgeInsets.only(top: 1, left: 1),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: isLoading ? null : _login,
                      color: const Color(0xff0095FF),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Prijavi se',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegistrationScreen()));
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Nemate račun? "),
                      Text(
                        "Registrujte se",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 100),
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/login.jpg'),
                        fit: BoxFit.fitHeight),
                  ),
                )
              ],
            ))
          ],
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
      var response = await korisnikProvider.login(username, password, 'mobile');

      if (response.containsKey('userType') && response.containsKey('userId')) {
        String userType = response['userType'];
        int userId = response['userId'];

        AuthProvider.username = _usernameController.text;
        AuthProvider.password = _passwordController.text;

        if (userType == 'administrator') {
          setState(() {
            Flushbar(
              message: "Administrator ne može koristiti mobilnu aplikaciju.",
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 3),
            ).show(context);
          });
          return;
        }

        Widget dashboard;
        switch (userType) {
          case 'doktor':
            dashboard = DoktorScreen(
              userId: userId,
              userType: userType,
            );
            break;
          case 'medicinsko osoblje':
            dashboard = OsobljeScreen(
              userId: userId,
              userType: userType,
            );
            break;
          case 'pacijent':
            dashboard = PacijentScreen(
              userId: userId,
              userType: userType,
            );
            break;
          default:
            setState(() {
              usernameError = "Nepoznata uloga korisnika.";
            });
            return;
        }

        _usernameController.clear();
        _passwordController.clear();
        FocusScope.of(context).unfocus();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => dashboard),
        );
      } else {
        if (mounted) return;
        await Flushbar(
          message: "Pogrešno korisničko ime ili lozinka.",
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ).show(context);
      }
    } catch (e) {
      String errorMessage = "Greška u komunikaciji s serverom.";

      if (e is SocketException) {
        errorMessage = "Nema internet konekcije.";
      } else if (e is UserFriendlyException) {
        errorMessage = e.message;
      } else if (e is FormatException) {
        errorMessage = "Neispravan odgovor sa servera.";
      } else if (e is http.ClientException) {
        errorMessage = "Greška u mrežnoj komunikaciji.";
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

      if (!mounted) return;
      Flushbar(
        message: errorMessage,
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ).show(context);
    } finally {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }
}
