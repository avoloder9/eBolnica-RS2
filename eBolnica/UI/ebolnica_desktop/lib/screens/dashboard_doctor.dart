import 'package:flutter/material.dart';

class DashboardDoctor extends StatelessWidget {
  final int userId;

  const DashboardDoctor({super.key, required this.userId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Doktor')),
      body: const Center(
        child: Text(
          "Dobrodošli na doktorski dashboard!\nKorisnik ID:",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
