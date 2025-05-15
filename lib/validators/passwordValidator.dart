class PasswordValidator {
  final String? password;

  PasswordValidator({this.password});

  String? get validatePassword {
    var nonNullPassword = password ?? '';
    if (nonNullPassword.length <= 7) {
      return 'Mínimo 7 caracteres';
    } else if (!nonNullPassword.contains(RegExp(r'[0-9]'))) {
      return 'Agrega al menos un número';
    } else if (!nonNullPassword.contains(RegExp(r'[A-Z]'))) {
      return 'Agrega al menos una letra mayúscula';
    } else if (!nonNullPassword.contains(RegExp(r'[a-z]'))) {
      return 'Agrega al menos una letra minúscula';
    } else if (nonNullPassword.contains(RegExp(r'^[A-Za-z0-9]+$'))) {
      return 'Agrega al menos un caracter especial';
    }
    return null;
  }
  /*String? get validatePassword {
    var nonNullPassword = password ?? '';
    if (nonNullPassword.isEmpty) {
      return 'La contraseña no puede estar vacía';
    } else if (nonNullPassword.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    } else if (!hasUpperCase(nonNullPassword)) {
      return 'La contraseña debe contener al menos 1 letra mayúscula';
    } else if (!hasNumber(nonNullPassword)) {
      return 'La contraseña debe contener al menos 1 número';
    }
    return null;
  }

  bool hasUpperCase(String str) {
    return RegExp(r'[A-Z]').hasMatch(str);
  }

  bool hasNumber(String str) {
    return RegExp(r'\d').hasMatch(str);
  }*/
}
