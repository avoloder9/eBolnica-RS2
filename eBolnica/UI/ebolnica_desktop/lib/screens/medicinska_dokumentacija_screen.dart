import 'package:flutter/material.dart';

class MedicinskaDokumentacijaScreen extends StatefulWidget {
  final int pacijentId;
  const MedicinskaDokumentacijaScreen({super.key, required this.pacijentId});
  @override
  State<MedicinskaDokumentacijaScreen> createState() =>
      _MedicinskaDokumentacijaScreenState();
}

class _MedicinskaDokumentacijaScreenState
    extends State<MedicinskaDokumentacijaScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 200,
    );
  }
}
