import 'package:another_flushbar/flushbar.dart';
import 'package:ebolnica_desktop/providers/krevet_provider.dart';
import 'package:ebolnica_desktop/screens/krevet_list_screen.dart';
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
    return AlertDialog(
      title: const Text("Potvrda"),
      content: const Text(
          "Da li ste sigurni da zelite dodati novi krevet za odabranu sobu"),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Ne")),
        ElevatedButton(
            onPressed: () async {
              var request = {"sobaId": widget.sobaId, "zauzet": false};

              try {
                await krevetProvider.insert(request);
                Flushbar(
                        message: "Soba je uspješno dodana",
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 2))
                    .show(context);
                Future.wait([
                  Future.delayed(const Duration(seconds: 1)),
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KrevetListScreen(
                          sobaId: widget.sobaId,
                          odjelId: widget.odjelId,
                          userId: widget.userId,
                          userType: widget.userType,
                        ),
                      ),
                      (route) => route.isFirst)
                ]);
              } catch (e) {
                Flushbar(
                        message: "Došlo je do greške. Pokušajte ponovo.",
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 2))
                    .show(context);
              }
            },
            child: const Text("Da"))
      ],
    );
  }
}
