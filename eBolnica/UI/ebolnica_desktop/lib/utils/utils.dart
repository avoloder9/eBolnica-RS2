import 'dart:convert';
import 'package:ebolnica_desktop/models/pacijent_model.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

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
