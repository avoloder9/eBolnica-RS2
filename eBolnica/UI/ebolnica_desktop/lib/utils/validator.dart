typedef ValidatorRule = String? Function(String? value);

String? generalValidator(
    String? value, String fieldName, List<ValidatorRule> rules) {
  for (var rule in rules) {
    final result = rule(value);
    if (result != null) return result.replaceAll('{field}', fieldName);
  }
  return null;
}

String? notEmpty(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Molimo unesite {field}';
  }
  return null;
}

ValidatorRule maxLength(int length) {
  return (String? value) {
    if (value != null && value.trim().length > length) {
      return '{field} može imati najviše $length znakova';
    }
    return null;
  };
}

String? startsWithCapital(String? value) {
  if (value == null || value.isEmpty) return null;
  final firstChar = value.trim()[0];
  if (firstChar != firstChar.toUpperCase()) {
    return '{field} mora početi sa velikim slovom';
  }
  return null;
}

String? validEmail(String? value) {
  if (value == null ||
      !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
          .hasMatch(value)) {
    return 'Molimo unesite validan email';
  }
  return null;
}

String? dropdownValidator<T>(T? value, String fieldName) {
  if (value == null || (value is String && value.trim().isEmpty)) {
    return 'Molimo odaberite $fieldName';
  }
  return null;
}

String? dateValidator(DateTime? date, String fieldName) {
  if (date == null) {
    return 'Molimo unesite $fieldName';
  }
  return null;
}
