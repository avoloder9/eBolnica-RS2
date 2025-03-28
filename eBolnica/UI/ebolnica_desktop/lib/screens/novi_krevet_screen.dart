import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/providers/krevet_provider.dart';
import 'package:flutter/material.dart';

class NoviKrevetScreen extends StatefulWidget {
  final int sobaId;
  final int odjelId;
  final int userId;
  final String? userType;

  const NoviKrevetScreen(
      {required this.sobaId,
      required this.odjelId,
      required this.userId,
      this.userType,
      super.key});
  @override
  _NoviKrevetScreenState createState() => _NoviKrevetScreenState();
}

class _NoviKrevetScreenState extends State<NoviKrevetScreen> {
  late KrevetProvider krevetProvider;
  @override
  void initState() {
    super.initState();
    krevetProvider = KrevetProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "Dodati krevet?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Da li ste sigurni da želite dodati novi krevet?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Odustani"),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        var request = {
                          "sobaId": widget.sobaId,
                          "zauzet": false
                        };

                        try {
                          await krevetProvider.insert(request);
                          Flushbar(
                                  message: "Krevet je uspješno dodan",
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 2))
                              .show(context);
                          await Future.delayed(const Duration(seconds: 1));

                          Navigator.pop(context);
                        } catch (e) {
                          Flushbar(
                                  message:
                                      "Došlo je do greške. Pokušajte ponovo.",
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 2))
                              .show(context);
                        }
                        Navigator.pop(context);
                      },
                      child: const Text("Da"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
