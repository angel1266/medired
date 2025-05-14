import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'transactionType')
enum TransactionType {
  @JsonValue(0)
  subscription,
  @JsonValue(1)
  payment,
}

final Map<String, TransactionType> stringToTransactionType = {
  'subscription': TransactionType.subscription,
  'payment': TransactionType.payment,
};

final Map<TransactionType, String> transactionTypeToString = {
  TransactionType.subscription: 'subscription',
  TransactionType.payment: 'payment',
};
