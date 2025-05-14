import 'package:medired/core/core_export.dart';
import 'package:medired/features/authentication/data/models/personal_info_model.dart';
import 'package:medired/features/authentication/domain/entities/authentication_entities.dart';

class PersonalInfo extends BaseInfo {
  final String firstName;
  final String lastName;
  final String token_google;
  final String token_facebook;
  final Sex sex;
  final Country nationality;
  final DateTime birthdate;

  const PersonalInfo({
    required super.language,
    required super.phoneNumber,
    required super.documents,
    required super.address,
    required this.firstName,
    required this.lastName,
    required this.sex,
    required this.nationality,
    required this.birthdate,
    required this.token_facebook,
    required this.token_google,
  });

  String? validateValue(String value) {
    if (value.isEmpty) {
      return 'El campo no puede estar vacío';
    } else if (value.length > 45) {
      return 'Máximo 45 caracteres';
    }
    return null;
  }

  @override
  PersonalInfo copyWith({
    Language? language,
    List<PhoneNumber>? phoneNumber,
    List<Document>? documents,
    List<Address>? address,
    String? firstName,
    String? lastName,
    String? token_facebook,
    String? token_google,

    Sex? sex,
    Country? nationality,
    DateTime? birthdate,
  }) {
    return PersonalInfo(
      language: language ?? this.language,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      documents: documents ?? this.documents,
      address: address ?? this.address,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      token_facebook: token_facebook ?? this.token_facebook,
      token_google: token_google ?? this.token_google,
      sex: sex ?? this.sex,
      nationality: nationality ?? this.nationality,
      birthdate: birthdate ?? this.birthdate,
    );
  }

  @override
  factory PersonalInfo.fromSignUp() {
    final DateTime now = DateTime.now();
    final DateTime oneYearAgo = DateTime(now.year - 18, now.month, now.day);
    return PersonalInfo(
      language: Language.es,
      phoneNumber: const [
        PhoneNumber(type: 0, phoneNumber: '', country: Country.DO)
      ],
      documents: [
        Document(
            value: '',
            country: Country.DO,
            documentType: DocumentType.idCard,
            expirationDate: DateTime.now())
      ],
      address: const [],
      firstName: '',
      token_facebook: '',
      token_google: '',
      lastName: '',
      sex: Sex.masculine,
      nationality: Country.DO,
      birthdate: oneYearAgo,
    );
  }

  @override
  List<Object?> get props => [
        language,
        phoneNumber,
        documents,
        address,
        firstName,
        lastName,
        sex,
        nationality,
        birthdate,
        token_google,
        token_facebook
      ];

  @override
  toJson() => PersonalInfoModel.fromEntity(this).toJson();

  @override
  fromJson(Map<String, dynamic> json) => PersonalInfoModel.fromJson(json);
}
