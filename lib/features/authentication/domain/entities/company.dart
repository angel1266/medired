import 'package:medired/features/authentication/authentication_export.dart';

class Company extends Member {
  final CompanyInfo companyInfo;

  const Company({
    required super.authInfo,
    required super.memberInfo,
    required this.companyInfo,
  });

  @override
  Company copyWith({
    int? id,
    AuthInfo? authInfo,
    CompanyInfo? companyInfo,
    MemberInfo? memberInfo,
  }) =>
      Company(
        authInfo: authInfo ?? this.authInfo,
        companyInfo: companyInfo ?? this.companyInfo,
        memberInfo: memberInfo ?? this.memberInfo,
      );

  factory Company.toEntity(CompanyModel companyModel) {
    return Company(
      authInfo: companyModel.authInfo,
      companyInfo: companyModel.companyInfo,
      memberInfo: companyModel.memberInfo,
    );
  }

  @override
  List<Object?> get props => [
        companyInfo,
        memberInfo,
      ];

  @override
  toJson() => CompanyModel.fromEntity(this).toJson();

  @override
  fromJson(Map<String, dynamic> json) => CompanyModel.fromJson(json);
}
