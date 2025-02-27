import 'package:flutter/material.dart';

class PacijentScreen extends StatefulWidget {
  final int userId;
  const PacijentScreen({super.key, required this.userId});
  @override
  _PacijentScreenState createState() => _PacijentScreenState();
}

class _PacijentScreenState extends State<PacijentScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Pacijent"),
    );
  }
}
