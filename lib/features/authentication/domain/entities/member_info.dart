import 'package:medired/core/core_export.dart';
import 'package:medired/core/utils/json_serializable/serializable.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/features/authentication/data/models/session_model.dart';
import 'package:medired/features/authentication/domain/entities/session.dart';

class MemberInfo extends Equatable implements Serializable {
  final UserType memberType;
  final SubscriptionType subscriptionType;
  final List<String> payments;
  final List<Session> sessions;

  const MemberInfo({
    required this.memberType,
    required this.subscriptionType,
    required this.payments,
    required this.sessions,
  });

  MemberInfo copyWith({
    int? id,
    UserType? memberType,
    SubscriptionType? subscriptionType,
    List<String>? payments,
    AuthInfo? authInfo,
    List<Session>? sessions,
  }) {
    return MemberInfo(
      memberType: memberType ?? this.memberType,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      payments: payments ?? this.payments,
      sessions: sessions ?? this.sessions,
    );
  }

  factory MemberInfo.toEntity(MemberInfoModel memberModel) {
    return MemberInfo(
      payments: memberModel.payments,
      subscriptionType: memberModel.subscriptionType,
      memberType: memberModel.memberType,
      sessions: memberModel.sessions,
    );
  }

  factory MemberInfo.fromEmpty({required UserType memberType}) {
    return MemberInfo(
      payments: const [],
      subscriptionType: SubscriptionType.none,
      memberType: memberType,
      sessions: const [],
    );
  }

  @override
  List<Object?> get props => [
        payments,
        subscriptionType,
        memberType,
        sessions,
      ];

  @override
  toJson() => MemberInfoModel.fromEntity(this).toJson();

  @override
  fromJson(Map<String, dynamic> json) => MemberInfoModel.fromJson(json);
}
