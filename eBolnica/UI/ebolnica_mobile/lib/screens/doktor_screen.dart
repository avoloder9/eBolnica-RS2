import 'package:ebolnica_mobile/screens/navBar.dart';
import 'package:flutter/material.dart';

class DoktorScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  const DoktorScreen({super.key, required this.userId, this.userType});
  @override
  _DoktorScreenState createState() => _DoktorScreenState();
}

class _DoktorScreenState extends State<DoktorScreen> {
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
