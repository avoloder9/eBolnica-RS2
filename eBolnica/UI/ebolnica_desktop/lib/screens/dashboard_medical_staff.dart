import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:flutter/material.dart';

class DashboardMedicalStaff extends StatelessWidget {
  final int userId;

  const DashboardMedicalStaff({super.key, required this.userId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Medicinsko osoblje')),
      drawer: const SideBar(userType: 'medicinsko osoblje'),
      body: const Center(
        child: Text(
          "Dobrodošli na medicinsko osoblje dashboard!\nKorisnik ID:",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
