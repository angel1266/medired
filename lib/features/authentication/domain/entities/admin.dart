import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/features/authentication/data/models/admin_model.dart';

class Admin extends Authentication {
  final int adminType;
  final PersonalInfo personalInfo;
  const Admin({
    required super.authInfo,
    required this.adminType,
    required this.personalInfo,
  });

  @override
  Admin copyWith({
    int? id,
    int? adminType,
    List<String>? payments,
    AuthInfo? authInfo,
    PersonalInfo? personalInfo,
  }) =>
      Admin(
        adminType: adminType ?? this.adminType,
        authInfo: authInfo ?? this.authInfo,
        personalInfo: personalInfo ?? this.personalInfo,
      );

  factory Admin.toEntity(AdminModel adminModel) {
    return Admin(
      adminType: adminModel.adminType,
      authInfo: adminModel.authInfo,
      personalInfo: adminModel.personalInfo,
    );
  }

  @override
  toJson() => AdminModel.fromEntity(this).toJson();

  @override
  fromJson(Map<String, dynamic> json) => AdminModel.fromJson(json);
}
