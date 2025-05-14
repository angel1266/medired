import 'package:json_annotation/json_annotation.dart';
import 'package:medired/features/authentication/data/models/auth_info_model.dart';
import 'package:medired/features/authentication/data/models/member_info_model.dart';
import 'package:medired/features/authentication/domain/entities/authentication_entities.dart';

part 'member_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MemberModel extends Member {
  @JsonKey(name: 'authInfo')
  final AuthInfoModel authInfoModel;

  @JsonKey(name: 'memberInfo')
  final MemberInfoModel memberInfoModel;
  const MemberModel({
    required this.authInfoModel,
    required this.memberInfoModel,
  }) : super(
          authInfo: authInfoModel,
          memberInfo: memberInfoModel,
        );

  factory MemberModel.fromEntity(Member entity) => MemberModel(
        authInfoModel: AuthInfoModel.fromEntity(entity.authInfo),
        memberInfoModel: MemberInfoModel.fromEntity(entity.memberInfo),
      );

  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MemberModelToJson(this);
}
