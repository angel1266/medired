import 'package:medired/core/bloc/bloc_export.dart';
import 'package:medired/core/utils/json_serializable/serializable.dart';
import 'package:medired/features/authentication/data/models/session_model.dart';

class Session extends Equatable implements Serializable {
  final String uid;
  final String session;
  final String sessionKey;
  final String amount;
  final int status;
  final DateTime createdAt;

  const Session({
    required this.uid,
    required this.session,
    required this.sessionKey,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  Session copyWith({
    String? uid,
    String? session,
    String? sessionKey,
    String? amount,
    int? status,
    DateTime? createdAt,
  }) {
    return Session(
      uid: uid ?? this.uid,
      session: session ?? this.session,
      sessionKey: sessionKey ?? this.sessionKey,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        session,
        sessionKey,
        amount,
        status,
        createdAt,
      ];

  @override
  toJson() => SessionModel.fromEntity(this).toJson();

  @override
  fromJson(Map<String, dynamic> json) => SessionModel.fromJson(json);
}
