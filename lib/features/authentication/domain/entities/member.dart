import 'package:medired/features/authentication/data/models/member_model.dart';
import 'package:medired/features/authentication/domain/entities/authentication_entities.dart';

class Member extends Authentication {
  final MemberInfo memberInfo;

  const Member({
    required super.authInfo,
    required this.memberInfo,
    super.id,
  });

  @override
  Member copyWith({
    int? id,
    AuthInfo? authInfo,
    MemberInfo? memberInfo,
  }) =>
      Member(
        authInfo: authInfo ?? this.authInfo,
        memberInfo: memberInfo ?? this.memberInfo,
        id: id ?? this.id,
      );

  @override
  List<Object?> get props => [authInfo, memberInfo];

  @override
  toJson() => MemberModel.fromEntity(this).toJson();

  @override
  fromJson(Map<String, dynamic> json) => MemberModel.fromJson(json);
}
