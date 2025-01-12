class PasswordValidator {
  static String checkPasswordStrength(String password) {
    String errorMessage = '';

    if (password.length < 8) {
      errorMessage += "Lozinka mora sadržavati minimalno 8 karaktera.\n";
    }

    if (!RegExp(r'(?=.*[a-z])(?=.*[A-Z])').hasMatch(password)) {
      errorMessage +=
          "Lozinka mora sadržavati minimalno 1 veliko i 1 malo slovo.\n";
    }

    if (!RegExp(r'(?=.*\d)').hasMatch(password)) {
      errorMessage += "Lozinka mora sadržavati minimalno 1 broj.\n";
    }

    if (!RegExp(r'(?=.*[<,>,@,!,#,$,%,^,&,*,-,+,/,|,~,=])')
        .hasMatch(password)) {
      errorMessage += "Lozinka mora sadržavati minimalno 1 specijalan znak.\n";
    }

    return errorMessage.trim();
  }
}
