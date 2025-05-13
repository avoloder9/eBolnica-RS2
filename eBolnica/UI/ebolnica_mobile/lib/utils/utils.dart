import 'dart:convert';
import 'package:ebolnica_mobile/models/pacijent_model.dart';
import 'package:ebolnica_mobile/providers/pacijent_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

late PacijentProvider pacijentProvider;
String formatNumber(dynamic) {
  var f = NumberFormat('###,00');
  if (dynamic == null) {
    return "";
  }
  return f.format(dynamic);
}

Image imageFromString(String input) {
  return Image.memory(base64Decode(input));
}

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;
    text = text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.length <= 9) {
      text = text.replaceAllMapped(RegExp(r"(\d{3})(\d{3})(\d{3})"), (match) {
        return "${match[1]}/${match[2]}-${match[3]}";
      });
    } else if (text.length == 10) {
      text = text.replaceAllMapped(RegExp(r"(\d{3})(\d{3})(\d{4})"), (match) {
        return "${match[1]}/${match[2]}-${match[3]}";
      });
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

int? getPacijentIdByUserId(int? userId, List<Pacijent> pacijenti) {
  if (userId == null) return null;

  final pacijent = pacijenti.firstWhere(
    (pacijent) => pacijent.korisnikId == userId,
    orElse: () => Pacijent(),
  );

  return pacijent.pacijentId;
}

Future<List<Pacijent>> fetchPacijenti() async {
  final response = await pacijentProvider.get();
  return response.result;
}

String formattedDate(date) {
  final formatter = DateFormat('dd.MM.yyyy');
  return formatter.format(date);
}

String formattedTime(Duration time) {
  final hours = time.inHours.toString().padLeft(2, '0');
  final minutes = (time.inMinutes % 60).toString().padLeft(2, '0');
  return '$hours:$minutes';
}

Widget buildEmptyView(
    {required BuildContext context,
    required Widget screen,
    required String message}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.add_circle, size: 80, color: Colors.blue),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return screen;
              },
              barrierDismissible: false,
            );
          },
        ),
        const SizedBox(height: 10),
        Text(
          message,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

class DurationConverter implements JsonConverter<Duration?, String?> {
  const DurationConverter();

  @override
  Duration? fromJson(String? json) {
    if (json == null) return null;
    List<String> parts = json.split(':');
    if (parts.length != 3) return null; // Ako format nije HH:mm:ss

    int hours = int.tryParse(parts[0]) ?? 0;
    int minutes = int.tryParse(parts[1]) ?? 0;
    int seconds = int.tryParse(parts[2]) ?? 0;

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  @override
  String? toJson(Duration? duration) {
    if (duration == null) return null;
    return "${duration.inHours.toString().padLeft(2, '0')}:"
        "${(duration.inMinutes % 60).toString().padLeft(2, '0')}:"
        "${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }
}

Duration? parseDuration(String? timeString) {
  if (timeString == null) return null;
  List<String> parts = timeString.split(':');
  if (parts.length < 2) return null;

  int hours = int.tryParse(parts[0]) ?? 0;
  int minutes = int.tryParse(parts[1]) ?? 0;

  return Duration(hours: hours, minutes: minutes);
}

Future<bool> showCustomDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? imagePath,
}) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          Future.delayed(const Duration(seconds: 2), () {
            if (dialogContext.mounted) {
              Navigator.of(dialogContext, rootNavigator: true).pop(true);
            }
          });

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: title.isNotEmpty ? Text(title) : null,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (imagePath != null) Image.asset(imagePath, height: 80),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ) ??
      false;
}
