import 'package:formz/formz.dart';

enum PasswordValidationError {
  empty,
  tooShort,
  noNumbers,
  noUpperCase,
  noLowerCase,
  noSpecialCharacters
}

class PasswordInput extends FormzInput<String, List<PasswordValidationError>> {
  const PasswordInput.pure() : super.pure('');
  const PasswordInput.dirty([super.value = '']) : super.dirty();

  @override
  List<PasswordValidationError>? validator(String value) {
    if (value.isEmpty) {
      return [PasswordValidationError.empty];
    }

    List<PasswordValidationError> errors = [];

    if (value.length <= 7) {
      errors.add(PasswordValidationError.tooShort);
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      errors.add(PasswordValidationError.noNumbers);
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      errors.add(PasswordValidationError.noUpperCase);
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      errors.add(PasswordValidationError.noLowerCase);
    }
    if (value.contains(RegExp(r'^[A-Za-z0-1]+$'))) {
      errors.add(PasswordValidationError.noSpecialCharacters);
    }

    return errors.isEmpty ? null : errors;
  }

  static const Map<PasswordValidationError, String> errorToString = {
    PasswordValidationError.empty: 'Agrega más caracteres',
    PasswordValidationError.tooShort: 'Demasiado corta',
    PasswordValidationError.noNumbers: 'Agrega un número',
    PasswordValidationError.noUpperCase: 'Agrega una mayúscula',
    PasswordValidationError.noLowerCase: 'Agrega una minúscula',
    PasswordValidationError.noSpecialCharacters: 'Agrega un caracter especial',
  };
}
