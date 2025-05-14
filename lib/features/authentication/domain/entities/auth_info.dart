import 'package:medired/core/core_export.dart';
import 'package:medired/core/utils/json_serializable/serializable.dart';
import 'package:medired/features/authentication/data/models/auth_info_model.dart';

class AuthInfo extends Equatable implements Serializable {
  final String password;
  final String? email;
  final String? uid;
  final String? providerId;
  final String? photoUrl;
  final bool isEnabled;

  const AuthInfo({
    required this.password,
    required this.email,
    this.uid,
    this.providerId,
    this.photoUrl,
    this.isEnabled = false,
  });

  String? get validateEmail {
    var nonNullEmail = email ?? '';
    if (nonNullEmail.isEmpty) {
      return 'El correo no puede estar vacío';
    } else if (!isEmailValid()) {
      return 'Correo inválido';
    }
    return null;
  }

  get memberType => null;

  bool isEmailValid() {
    var regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$');

    return email != null ? regex.hasMatch(email!) : false;
  }

  String? get validatePassword {
    var errors = <String>[];
    if (password.length <= 7) {
      errors.add('Mínimo 7 caracteres');
    } else if (!password.contains(RegExp(r'[0-9]'))) {
      errors.add('Agrega al menos un número');
    } else if (!password.contains(RegExp(r'[A-Z]'))) {
      errors.add('Agrega al menos una letra mayúscula');
    } else if (!password.contains(RegExp(r'[a-z]'))) {
      errors.add('Agrega al menos una letra minúscula');
    } else if (password.contains(RegExp(r'^[A-Za-z0-1]+$'))) {
      errors.add('Agrega al menos un caracter especial');
    }
    return errors.isEmpty ? null : errors.join(',');
  }

  AuthInfo copyWith({
    String? password,
    String? email,
    String? uid,
    String? providerId,
    String? photoUrl,
    bool? isEnabled,
  }) =>
      AuthInfo(
        password: password ?? this.password,
        email: email ?? this.email,
        uid: uid ?? this.uid,
        providerId: providerId ?? this.providerId,
        photoUrl: photoUrl ?? this.photoUrl,
        isEnabled: isEnabled ?? this.isEnabled,
      );

  factory AuthInfo.fromSignUp() {
    return const AuthInfo(
      password: '',
      email: '',
      isEnabled: true,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        uid,
        providerId,
        photoUrl,
        isEnabled,
      ];

  @override
  toJson() => AuthInfoModel.fromEntity(this).toJson();

  @override
  fromJson(Map<String, dynamic> json) => AuthInfoModel.fromJson(json);
}
