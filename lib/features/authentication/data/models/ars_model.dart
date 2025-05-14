import 'package:json_annotation/json_annotation.dart';
import 'package:medired/features/authentication/data/models/authentication_model_export.dart';
import 'package:medired/features/authentication/domain/entities/authentication_entities.dart';

part 'ars_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ARSModel extends ARS {
  @JsonKey(name: 'companyInfo')
  final CompanyInfoModel companyInfoModel;

  @JsonKey(name: 'memberInfo')
  final MemberInfoModel memberInfoModel;

  @JsonKey(name: 'authInfo')
  final AuthInfoModel authInfoModel;

  const ARSModel({
    required super.memberIdList,
    required this.companyInfoModel,
    required this.memberInfoModel,
    required this.authInfoModel,
    required super.amountDue,
  }) : super(
          memberInfo: memberInfoModel,
          companyInfo: companyInfoModel,
          authInfo: authInfoModel,
        );

  factory ARSModel.fromAuthEntity({
    required MemberInfoModel memberInfoModel,
    required AuthInfoModel authInfoModel,
    required CompanyInfoModel companyInfoModel,
    required List<String> memberIdList,
    required List<String> payments,
    required String amountDue,
  }) =>
      ARSModel(
        memberIdList: memberIdList,
        companyInfoModel: companyInfoModel,
        memberInfoModel: memberInfoModel,
        authInfoModel: authInfoModel,
        amountDue: amountDue,
      );

  factory ARSModel.fromEntity(ARS ars) {
    return ARSModel(
      memberIdList: ars.memberIdList,
      companyInfoModel: CompanyInfoModel.fromEntity(ars.companyInfo),
      memberInfoModel: MemberInfoModel.fromEntity(ars.memberInfo),
      authInfoModel: AuthInfoModel.fromEntity(ars.authInfo),
      amountDue: ars.amountDue,
    );
  }

  factory ARSModel.fromJson(Map<String, dynamic> json) =>
      _$ARSModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ARSModelToJson(this);
}
