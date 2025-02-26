import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/providers/soba_provider.dart';
import 'package:ebolnica_desktop/screens/soba_list_screen.dart';
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
      title: const Text("Dodaj novu sobu"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: nazivController,
                decoration: InputDecoration(
                  labelText: 'Naziv',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Molimo unesite naziv';
                  }
                  if (value[0] != value[0].toUpperCase()) {
                    return 'Naziv mora početi sa velikim slovom';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
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
                await Future.wait([
                  Future.delayed(const Duration(seconds: 1)),
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SobaListScreen(
                          odjelId: widget.odjelId,
                          userId: widget.userId,
                          userType: widget.userType,
                        ),
                      ),
                      (route) => route.isFirst)
                ]);
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
          child: const Text("Dodaj"),
        ),
      ],
    );
  }

  Future<bool> _showConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Potvrda"),
          content: const Text("Da li ste sigurni da želite dodati novu sobu?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Ne"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Da"),
            ),
          ],
        );
      },
    );
  }
}
