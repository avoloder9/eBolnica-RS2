import 'package:ebolnica_mobile/screens/navBar.dart';
import 'package:flutter/material.dart';

class OsobljeScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  const OsobljeScreen({super.key, required this.userId, this.userType});
  @override
  _OsobljeScreenState createState() => _OsobljeScreenState();
}

class _OsobljeScreenState extends State<OsobljeScreen> {
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
