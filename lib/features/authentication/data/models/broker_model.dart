import 'package:json_annotation/json_annotation.dart';
import 'package:medired/features/authentication/data/models/authentication_model_export.dart';
import 'package:medired/features/authentication/domain/entities/authentication_entities.dart';

part 'broker_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BrokerModel extends Broker {
  @JsonKey(name: 'companyInfo')
  final CompanyInfoModel companyInfoModel;

  @JsonKey(name: 'members')
  final List<MemberInfoModel> memberModelList;

  @JsonKey(name: 'memberInfo')
  final MemberInfoModel memberInfoModel;

  @JsonKey(name: 'authInfo')
  final AuthInfoModel authInfoModel;

  const BrokerModel({
    required this.companyInfoModel,
    required this.memberModelList,
    required this.memberInfoModel,
    required this.authInfoModel,
    required super.amountDue,
  }) : super(
          companyInfo: companyInfoModel,
          authInfo: authInfoModel,
          memberInfo: memberInfoModel,
          memberList: memberModelList,
        );

  factory BrokerModel.fromAuthEntity({
    required AuthInfoModel authInfoModel,
    required CompanyInfoModel companyInfoModel,
    required MemberInfoModel memberInfoModel,
    required List<MemberInfoModel> memberModelList,
    required String amountDue,
  }) =>
      BrokerModel(
        authInfoModel: authInfoModel,
        memberInfoModel: memberInfoModel,
        companyInfoModel: companyInfoModel,
        memberModelList:
            memberModelList.map((e) => MemberInfoModel.fromEntity(e)).toList(),
        amountDue: amountDue,
      );

  factory BrokerModel.fromEntity(Broker broker) {
    return BrokerModel(
      authInfoModel: AuthInfoModel.fromEntity(broker.authInfo),
      memberInfoModel: MemberInfoModel.fromEntity(broker.memberInfo),
      companyInfoModel: CompanyInfoModel.fromEntity(broker.companyInfo),
      memberModelList:
          broker.memberList.map((e) => MemberInfoModel.fromEntity(e)).toList(),
      amountDue: broker.amountDue,
    );
  }

  factory BrokerModel.fromJson(Map<String, dynamic> json) =>
      _$BrokerModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BrokerModelToJson(this);
}
