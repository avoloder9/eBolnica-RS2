import 'package:ebolnica_mobile/screens/navBar.dart';
import 'package:flutter/material.dart';

class PacijentScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  const PacijentScreen({super.key, required this.userId, this.userType});
  @override
  _PacijentScreenState createState() => _PacijentScreenState();
}

class _PacijentScreenState extends State<PacijentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pocetna"),
      ),
      body: const Center(
        child: Text("Dobrodosli"),
      ),
      bottomNavigationBar: BottomNavBar(
        userId: widget.userId,
        userType: widget.userType!,
      ),
    );
  }
}
