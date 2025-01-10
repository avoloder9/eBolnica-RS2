import 'package:flutter/material.dart';

class DashboardAdmin extends StatelessWidget {
  final int userId;

  const DashboardAdmin({super.key, required this.userId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Administrator')),
      body: const Center(
        child: Text(
          "Dobrodošli na administratorski dashboard!\nKorisnik ID:",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
