import 'package:json_annotation/json_annotation.dart';
import 'package:medired/features/payment/domain/entities/cardnet_session.dart';

part 'cardnet_session_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CardnetSessionModel extends CardnetSession {
  @JsonKey(name: 'SESSION')
  @override
  String get session;

  @JsonKey(name: 'session-key')
  @override
  String get sessionKey => super.sessionKey;

  CardnetSessionModel({required super.session, required super.sessionKey});

  CardnetSessionModel.fromEntity(CardnetSession entity)
      : this(session: entity.session, sessionKey: entity.sessionKey);

  factory CardnetSessionModel.fromJson(Map<String, dynamic> json) =>
      _$CardnetSessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$CardnetSessionModelToJson(this);
}
