import 'package:flutter/material.dart';

class DoktorScreen extends StatefulWidget {
  final int userId;
  const DoktorScreen({super.key, required this.userId});
  @override
  _DoktorScreenState createState() => _DoktorScreenState();
}

class _DoktorScreenState extends State<DoktorScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Doktor"),
    );
  }
}
