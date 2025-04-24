import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/providers/soba_provider.dart';
import 'package:ebolnica_desktop/utils/validator.dart';
import 'package:flutter/material.dart';

class NovaSobaScreen extends StatefulWidget {
  final int odjelId;
  final int userId;
  final String? userType;

  const NovaSobaScreen(
      {required this.odjelId, super.key, required this.userId, this.userType});

  @override
  _NovaSobaScreenState createState() => _NovaSobaScreenState();
}

class _NovaSobaScreenState extends State<NovaSobaScreen> {
  final nazivController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int? brojKreveta;
  bool zauzeta = false;
  late SobaProvider sobaProvider;

  @override
  void initState() {
    super.initState();
    sobaProvider = SobaProvider();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Align(
        alignment: Alignment.center,
        child: Text(
          "Dodaj novu sobu",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextFormField(
                controller: nazivController,
                decoration: InputDecoration(
                  labelText: 'Naziv',
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.grey[300]!,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.blue[600]!,
                      width: 2.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 16.0),
                ),
                validator: (value) => generalValidator(
                    value, 'naziv', [notEmpty, startsWithCapital]),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            textStyle: TextStyle(fontSize: 16, color: Colors.blue[600]),
          ),
          child: const Text("Otkaži"),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              var request = {
                'odjelId': widget.odjelId,
                'brojKreveta': 0,
                'zauzeta': false,
                'naziv': nazivController.text
              };

              try {
                await sobaProvider.insert(request);
                await Flushbar(
                        message: "Soba je uspješno dodana",
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 2))
                    .show(context);
                _formKey.currentState?.reset();
              } catch (e) {
                await Flushbar(
                        message: "Došlo je do greške. Pokušajte ponovo.",
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 2))
                    .show(context);
              }
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 14.0, horizontal: 28.0),
          ),
          child: const Text("Dodaj",
              style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
      ],
    );
  }
}
