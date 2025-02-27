import 'package:flutter/material.dart';

class OsobljeScreen extends StatefulWidget {
  final int userId;
  const OsobljeScreen({super.key, required this.userId});
  @override
  _OsobljeScreenState createState() => _OsobljeScreenState();
}

class _OsobljeScreenState extends State<OsobljeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Osoblje"),
    );
  }
}
