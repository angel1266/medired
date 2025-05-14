import 'package:medired/core/core_export.dart';
import 'package:medired/features/authentication/authentication_export.dart';

class Patient extends Member {
  // //TODO: Medical condition has to be tied to another class
  // final String medicalCondition;
  // //TODO: History has to be tied to another class
  // final Map<DateTime, double> weight;
  // //TODO: SSN has to be tied to another class
  // final String socialSecurity;
  // //TODO: Symptoms have to be tied to another class
  // //The key indicates the symptomp and the value indicates the level of pain
  // final Map<String, int> symptomps;

  // required this.medicalCondition,
  // required this.weight,
  // required this.socialSecurity,
  // required this.symptomps,
  final PersonalInfo personalInfo;
  final String arsuid;
  final String contractNumber;
  final String company;
  final int points;
  // final int montoTotal;
  // final int montoNoConvertido;

  const Patient({
    required this.personalInfo,
    required this.arsuid,
    required this.company,
    required this.points,
    required this.contractNumber,
    required super.memberInfo,
    required super.authInfo,
    // required this.montoTotal,
    // required this.montoNoConvertido,
  });

  int calculateAge() {
    final currentDate = DateTime.now();
    int age = personalInfo.birthdate.year - personalInfo.birthdate.year;
    if (currentDate.month < personalInfo.birthdate.month ||
        (currentDate.month == personalInfo.birthdate.month &&
            currentDate.day < personalInfo.birthdate.day)) {
      age--;
    }
    return age;
  }

  String get fullName => '${personalInfo.firstName} ${personalInfo.lastName}';

  @override
  Patient copyWith({
    int? id,
    PersonalInfo? personalInfo,
    String? arsuid,
    String? company,
    String? contractNumber,
    MemberInfo? memberInfo,
    AuthInfo? authInfo,
    int? points,
    // int? montoTotal,
    // int? montoNoConvertido,
  }) {
    return Patient(
      memberInfo: memberInfo ?? this.memberInfo,
      personalInfo: personalInfo ?? this.personalInfo,
      arsuid: arsuid ?? this.arsuid,
      company: company ?? this.company,
      contractNumber: contractNumber ?? this.contractNumber,
      authInfo: authInfo ?? this.authInfo,
      points: points ?? this.points,
      // montoTotal: montoTotal ?? this.montoTotal,
      // montoNoConvertido: montoNoConvertido ?? this.montoNoConvertido,
    );
  }

  factory Patient.toEntity(PatientModel patientModel) {
    return Patient(
      personalInfo: patientModel.personalInfo,
      arsuid: patientModel.arsuid,
      company: patientModel.company,
      contractNumber: patientModel.contractNumber,
      memberInfo: patientModel.memberInfoModel,
      authInfo: patientModel.authInfoModel,
      points: patientModel.points,
      // montoTotal: patientModel.montoTotal,
      // montoNoConvertido: patientModel.montoNoConvertido,
    );
  }

  // factory Patient.fromEmpty() {
  //   return Patient(
  //     authInfo: const AuthInfo(
  //       email: '',
  //       password: '',
  //       uid: '',
  //       providerId: '',
  //       photoUrl: '',
  //       isEnabled: false,
  //     ),
  //     memberInfo: const MemberInfo(
  //       payments: [],
  //       sessions: [],
  //       subscriptionType: SubscriptionType.mensual,
  //       memberType: UserType.patient,
  //     ),
  //     personalInfo: PersonalInfo(
  //       address: const [],
  //       birthdate: DateTime.now(),
  //       documents: const [],
  //       firstName: '',
  //       language: Language.es,
  //       lastName: '',
  //       nationality: Country.AD,
  //       phoneNumber: const [],
  //       sex: Sex.masculine,
  //     ),
  //     arsuid: '',
  //     company: '',
  //     contractNumber: '',
  //     points: 0,
  //     montoTotal: 0,
  //     montoNoConvertido: 0,
  //   );
  // }

  factory Patient.fromSignUp({
    required AuthInfo authInfo,
    required PersonalInfo personalInfo,
    required String arsuid,
    required String company,
    required String contractNumber,
  }) {
    return Patient(
      personalInfo: personalInfo,
      authInfo: authInfo,
      memberInfo: MemberInfo.fromEmpty(memberType: UserType.patient),
      arsuid: arsuid,
      company: company,
      contractNumber: contractNumber,
      points: 0,
      // montoTotal: 0,
      // montoNoConvertido: 0,
    );
  }
  

  @override
  List<Object?> get props => [
        memberInfo,
        personalInfo,
        arsuid,
        company,
        contractNumber,
        points,
        // montoTotal,
        // montoNoConvertido,
      ];

  @override
  toJson() => PatientModel.fromEntity(this).toJson();

  @override
  fromJson(Map<String, dynamic> json) => PatientModel.fromJson(json);
}
