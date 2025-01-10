import 'package:flutter/material.dart';

class DashboardPatient extends StatelessWidget {
  final int userId;
  const DashboardPatient({super.key, required this.userId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Pacijent')),
      body: const Center(
        child: Text(
          'Dobrodošli na pacijent dashboard!\nKorisnik ID:  ',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
