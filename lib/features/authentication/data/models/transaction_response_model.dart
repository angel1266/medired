import 'package:json_annotation/json_annotation.dart';
import 'package:medired/features/authentication/domain/entities/transaction_response.dart';

part 'transaction_response_model.g.dart';

@JsonSerializable()
class TransactionResponseModel extends TransactionResponse {
  TransactionResponseModel({
    required super.ordenID,
    required super.authorizationCode,
    required super.txToken,
    required super.responseCode,
    required super.creditcardNumber,
    required super.retrivalReferenceNumber,
    required super.remoteResponseCode,
    required super.transactionID,
  });

  factory TransactionResponseModel.fromEntity(TransactionResponse entity) =>
      TransactionResponseModel(
        ordenID: entity.ordenID,
        authorizationCode: entity.authorizationCode,
        txToken: entity.txToken,
        responseCode: entity.responseCode,
        creditcardNumber: entity.creditcardNumber,
        retrivalReferenceNumber: entity.retrivalReferenceNumber,
        remoteResponseCode: entity.remoteResponseCode,
        transactionID: entity.transactionID,
      );

  factory TransactionResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TransactionResponseModelToJson(this);
}
