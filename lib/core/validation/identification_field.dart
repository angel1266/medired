import 'package:formz/formz.dart';
import 'package:medired/core/value_objects/identification_input_error.dart';

///Aka as Cédula
class IdentificationField extends FormzInput<String, IdentificationInputError> {
  const IdentificationField.pure(super.value) : super.pure();

  @override
  IdentificationInputError? validator(String value) {
    if (value.length < 11) {
      return IdentificationInputError.tooShort;
    }
    return null;
  }
}
