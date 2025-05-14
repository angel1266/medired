import 'package:medired/core/utils/json_serializable/serializable.dart';
import 'package:medired/features/authentication/data/models/transaction_response_model.dart';

class TransactionResponse extends Serializable {
  final String ordenID;
  final String authorizationCode;
  final String txToken;
  final String responseCode;
  final String creditcardNumber;
  final String retrivalReferenceNumber;
  final String remoteResponseCode;
  final String transactionID;

  TransactionResponse({
    required this.ordenID,
    required this.authorizationCode,
    required this.txToken,
    required this.responseCode,
    required this.creditcardNumber,
    required this.retrivalReferenceNumber,
    required this.remoteResponseCode,
    required this.transactionID,
  });

  @override
  Serializable fromJson(Map<String, dynamic> json) =>
      TransactionResponseModel.fromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      TransactionResponseModel.fromEntity(this).toJson();
}
