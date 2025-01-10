import 'package:ebolnica_desktop/api_constants.dart';
import 'package:ebolnica_desktop/models/login_model.dart';
import 'package:ebolnica_desktop/screens/dashboard_doctor.dart';
import 'package:ebolnica_desktop/screens/dashboard_patient.dart';
import 'package:ebolnica_desktop/screens/dashboard_medical_staff.dart';
import 'package:ebolnica_desktop/screens/dashboard_admin.dart';
import 'package:ebolnica_desktop/screens/registration.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:another_flushbar/flushbar.dart';

void main() {
  runApp(const MyApp());
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
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    var loginModel = LoginModel(
                      username: _usernameController.text,
                      password: _passwordController.text,
                      deviceType: 'desktop',
                    );

                    var url =
                        Uri.parse('${ApiConstants.baseUrl}/Korisnik/login');
                    var response = await http.post(
                      url,
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode(loginModel.toJson()),
                    );

                    if (response.statusCode == 200) {
                      var responseBody = json.decode(response.body);
                      String? userType = responseBody['userType'];
                      int userId = responseBody['userId'];

                      if (userType != null) {
                        if (userType == 'administrator') {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                DashboardAdmin(userId: userId),
                          ));
                        } else if (userType == 'doktor') {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                DashboardDoctor(userId: userId),
                          ));
                        } else if (userType == 'medicinsko osoblje') {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                DashboardMedicalStaff(userId: userId),
                          ));
                        } else if (userType == 'pacijent') {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                DashboardPatient(userId: userId),
                          ));
                        }
                      }
                    } else {
                      Flushbar(
                        message: "Login failed: ${response.body}",
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 3),
                      ).show(context);
                    }
                  },
                  child: const Text(
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
                    builder: (context) =>
                        const RegistrationScreen(), // Implementirajte RegistrationScreen
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
}
