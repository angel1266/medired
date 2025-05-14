import 'package:json_annotation/json_annotation.dart';
import 'package:medired/features/authentication/domain/entities/session.dart';

part 'session_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SessionModel extends Session {
  const SessionModel({
    required super.uid,
    required super.session,
    required super.sessionKey,
    required super.amount,
    required super.status,
    required super.createdAt,
  });

  factory SessionModel.fromEntity(Session session) {
    return SessionModel(
      uid: session.uid,
      session: session.session,
      sessionKey: session.sessionKey,
      amount: session.amount,
      status: session.status,
      createdAt: session.createdAt,
    );
  }

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SessionModelToJson(this);
}
