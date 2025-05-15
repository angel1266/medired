class EmailValidator {
  final String? email;

  EmailValidator({this.email});

  // Método para validar el correo electrónico
  String? get validateEmail {
    var nonNullEmail = email ?? '';
    if (nonNullEmail.isEmpty) {
      return 'El correo no puede estar vacío';
    } else if (!isEmailValid()) {
      return 'Correo inválido';
    }
    return null;
  }

  // Método para verificar si el formato del correo electrónico es válido
  bool isEmailValid() {
    var regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$');
    return email != null ? regex.hasMatch(email!) : false;
  }
}
