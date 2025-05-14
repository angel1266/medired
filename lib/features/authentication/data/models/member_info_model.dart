import 'package:json_annotation/json_annotation.dart';
import 'package:medired/core/core_export.dart';
import 'package:medired/features/authentication/data/models/session_model.dart';
import 'package:medired/features/authentication/domain/entities/authentication_entities.dart';

part 'member_info_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MemberInfoModel extends MemberInfo {
  @JsonKey(name: 'sessions')
  final List<SessionModel> sessionsModel;

  const MemberInfoModel({
    required super.payments,
    required super.subscriptionType,
    required super.memberType,
    required this.sessionsModel,
  }) : super(
          sessions: sessionsModel,
        );

  factory MemberInfoModel.fromPersonalInfoEntity({
    required List<String> appointments,
    required List<String> payments,
    required SubscriptionType subscriptionType,
    required UserType memberType,
    required AuthInfo authInfo,
    required PersonalInfo personalInfo,
    required List<SessionModel> sessionsModel,
  }) {
    return MemberInfoModel(
      payments: payments,
      subscriptionType: subscriptionType,
      memberType: memberType,
      sessionsModel: sessionsModel,
    );
  }

  factory MemberInfoModel.fromEntity(MemberInfo member) {
    return MemberInfoModel(
      payments: member.payments,
      subscriptionType: member.subscriptionType,
      memberType: member.memberType,
      sessionsModel:
          member.sessions.map((e) => SessionModel.fromEntity(e)).toList(),
    );
  }

  factory MemberInfoModel.fromJson(Map<String, dynamic> json) =>
      _$MemberInfoModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MemberInfoModelToJson(this);
}
