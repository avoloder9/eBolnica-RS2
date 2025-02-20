import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:flutter/material.dart';

class DashboardAdmin extends StatelessWidget {
  final int userId;
  final String? userType;
  const DashboardAdmin({super.key, required this.userId, this.userType});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Administrator')),
      drawer: SideBar(
        userType: userType!,
        userId: userId,
      ),
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
