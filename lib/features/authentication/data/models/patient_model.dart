import 'package:json_annotation/json_annotation.dart';
import 'package:medired/core/core_export.dart';
import 'package:medired/features/authentication/data/models/authentication_model_export.dart';
import 'package:medired/features/authentication/domain/entities/authentication_entities.dart';

part 'patient_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PatientModel extends Patient {
  @JsonKey(name: 'memberInfo')
  final MemberInfoModel memberInfoModel;

  @JsonKey(name: 'personalInfo')
  final PersonalInfoModel personalInfoModel;

  @JsonKey(name: 'authInfo')
  final AuthInfoModel authInfoModel;

  const PatientModel({
    // required super.medicalCondition,
    // required super.weight,
    // required super.socialSecurity,
    // required super.symptomps,
    required this.memberInfoModel,
    required this.personalInfoModel,
    required super.arsuid,
    required super.company,
    required super.contractNumber,
    required super.points,
    required this.authInfoModel,
    // required super.montoTotal,
    // required super.montoNoConvertido,
  }) : super(
          memberInfo: memberInfoModel,
          personalInfo: personalInfoModel,
          authInfo: authInfoModel,
        );

  // factory PatientModel.fromMemberEntity({
  //   required MemberInfoModel memberInfoModel,
  //   required PersonalInfoModel personalInfoModel,
  //   required AuthInfoModel authInfoModel,
  //   required String arsuid,
  //   required String company,
  //   required String contractNumber,
  //   required int points,
  // }) {
  //   return PatientModel(
  //     memberInfoModel: memberInfoModel,
  //     authInfoModel: authInfoModel,
  //     personalInfoModel: personalInfoModel,
  //     arsuid: arsuid,
  //     company: company,
  //     contractNumber: contractNumber,
  //     points: points,
  //     montoTotal: 0,
  //     montoNoConvertido: 0,
  //   );
  // }

  factory PatientModel.fromEntity(Patient patient) {
    return PatientModel(
      // medicalCondition: patient.medicalCondition,
      // socialSecurity: patient.socialSecurity,
      // symptomps: patient.symptomps,
      // weight: patient.weight,
      memberInfoModel: MemberInfoModel.fromEntity(patient.memberInfo),
      personalInfoModel: PersonalInfoModel.fromEntity(patient.personalInfo),
      authInfoModel: AuthInfoModel.fromEntity(patient.authInfo),
      arsuid: patient.arsuid,
      company: patient.company,
      contractNumber: patient.contractNumber,
      points: patient.points,
      // montoTotal: patient.montoTotal,
      // montoNoConvertido: patient.montoNoConvertido,
    );
  }

  factory PatientModel.fromJson(Map<String, dynamic> json) =>
      _$PatientModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PatientModelToJson(this);

  factory PatientModel.fromExcel({
    required String firstName,
    required String lastName,
    required String token_facebook,
    required String token_google,
    required String email,
    required DateTime birthDate,
    required String documentValue,
    required String phoneNumberValue,
    required Sex sex,
    required SubscriptionType subscriptionType,
    required String arsuid,
    required String company,
    required String contractNumber,
    Language language = Language.es,
    Country nationality = Country.DO,
    int points = 0,
  }) =>
      PatientModel(
        authInfoModel: AuthInfoModel(
          email: email,
          password: '',
        ),
        memberInfoModel: MemberInfoModel(
          memberType: UserType.patient,
          subscriptionType: subscriptionType,
          payments: const [],
          sessionsModel: const [],
        ),
        arsuid: arsuid,
        company: company,
        contractNumber: contractNumber,
        personalInfoModel: PersonalInfoModel(
          token_facebook:token_facebook,
          token_google:token_google,
          firstName: firstName,
          lastName: lastName,
          language: language,
          nationality: nationality,
          sex: sex,
          addressModel: const [],
          birthdate: birthDate,
          documentsModel: [
            DocumentModel(
              value: documentValue,
              country: nationality,
              documentType: DocumentType.idCard,
              expirationDate: DateTime.now(),
            ),
          ],
          phoneNumberModel: [
            PhoneNumberModel(
              type: 0,
              phoneNumber: phoneNumberValue,
              country: nationality,
            ),
          ],
        ),
        points: points,
        // montoTotal: 0,
        // montoNoConvertido: 0,
      );
}
