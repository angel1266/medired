import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:medired/core/value_objects/transaction_type.dart';
import 'package:medired/core/utils/json_serializable/json_serializable.dart';
import 'package:medired/features/payment/domain/entities/payment.dart';

part 'payment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PaymentModel extends Payment {
  @TimestampConverter()
  @override
  DateTime get date => super.date;

  set date(DateTime value) {
    super.copyWith(date: value);
  }

  const PaymentModel({
    required super.id,
    required super.amount,
    required super.currencyCode,
    required super.date,
    required super.session,
    required super.sessionKey,
    required super.uid,
    required super.transactionType,
    required super.isProcessed,
  });

  factory PaymentModel.fromEntity(Payment entity) => PaymentModel(
        id: entity.id,
        amount: entity.amount,
        currencyCode: entity.currencyCode,
        date: entity.date,
        session: entity.session,
        sessionKey: entity.sessionKey,
        uid: entity.uid,
        transactionType: entity.transactionType,
        isProcessed: entity.isProcessed,
      );

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);
}
