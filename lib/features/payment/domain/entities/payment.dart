import 'package:medired/core/core_export.dart';
import 'package:medired/core/value_objects/pay_frequency.dart';
import 'package:medired/core/value_objects/transaction_type.dart';

class Payment extends Equatable {
  final String id;
  final String amount;
  final String currencyCode;
  final DateTime date;
  final String session;
  final String sessionKey;
  final String uid;
  final TransactionType transactionType;
  final bool isProcessed;

  const Payment({
    required this.id,
    required this.amount,
    required this.currencyCode,
    required this.date,
    required this.session,
    required this.sessionKey,
    required this.uid,
    required this.transactionType,
    required this.isProcessed,
  });

  PayFrequency get payFrequency {
    if (amount == '500') {
      return PayFrequency.monthly;
    } else if (amount == '1500') {
      return PayFrequency.quarterly;
    } else if (amount == '3000') {
      return PayFrequency.semiAnnual;
    } else if (amount == '6000') {
      return PayFrequency.annual;
    }
    return PayFrequency.monthly;
  }

  Payment copyWith({
    String? id,
    String? amount,
    String? currencyCode,
    DateTime? date,
    String? session,
    String? sessionKey,
    String? uid,
    TransactionType? transactionType,
    bool? isProcessed,
  }) {
    return Payment(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      currencyCode: currencyCode ?? this.currencyCode,
      date: date ?? this.date,
      session: session ?? this.session,
      sessionKey: sessionKey ?? this.sessionKey,
      uid: uid ?? this.uid,
      transactionType: transactionType ?? this.transactionType,
      isProcessed: isProcessed ?? this.isProcessed,
    );
  }

  @override
  List<Object?> get props => [];
}
