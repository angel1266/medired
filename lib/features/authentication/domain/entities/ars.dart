import 'package:medired/features/authentication/authentication_export.dart';

class ARS extends Company {
  final List<String> memberIdList;
  final String amountDue;

  const ARS({
    required super.authInfo,
    required super.companyInfo,
    required super.memberInfo,
    required this.memberIdList,
    required this.amountDue,
  });

  factory ARS.fromEntity(ARSModel arsModel) {
    return ARS(
      authInfo: arsModel.authInfo,
      memberInfo: arsModel.memberInfo,
      companyInfo: arsModel.companyInfo,
      memberIdList: arsModel.memberIdList,
      amountDue: arsModel.amountDue,
    );
  }

  factory ARS.fromSignUp({
    required AuthInfo authInfo,
    required MemberInfo memberInfo,
    required CompanyInfo companyInfo,
  }) {
    return ARS(
      authInfo: authInfo,
      memberInfo: memberInfo,
      companyInfo: companyInfo,
      memberIdList: const [],
      amountDue: '0',
    );
  }

  @override
  List<Object?> get props => [
        memberInfo,
        memberIdList,
        amountDue,
      ];

  @override
  toJson() => ARSModel.fromEntity(this).toJson();

  @override
  fromJson(Map<String, dynamic> json) => ARSModel.fromJson(json);
}
