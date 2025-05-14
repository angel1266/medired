part of 'payment_bloc.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

sealed class ProfilePaymentEvent extends PaymentEvent {
  final Patient patient;

  const ProfilePaymentEvent({required this.patient});
}

class Pay extends PaymentEvent {
  final int amount;
  final String pass;
  const Pay({required this.amount, required this.pass});

  @override
  List<Object> get props => [amount, pass];
}

class PayTest extends PaymentEvent {
  final int amount;
  final String pass;
  final String uid;
  final TransactionType transactionType;
  const PayTest(
      {required this.amount,
      required this.pass,
      required this.uid,
      required this.transactionType});

  @override
  List<Object> get props => [amount, pass];
}

class GetResponseCode extends PaymentEvent {
  final String session;
  final String sessionKey;
  const GetResponseCode({required this.session, required this.sessionKey});

  @override
  List<Object> get props => [session, sessionKey];
}

class GetTestResponseCode extends PaymentEvent {
  final String session;
  final String sessionKey;
  const GetTestResponseCode({required this.session, required this.sessionKey});

  @override
  List<Object> get props => [session, sessionKey];
}

class SendEmail extends PaymentEvent {
  final String to;
  final String subject;
  final String body;
  const SendEmail(
      {required this.to, required this.subject, required this.body});

  @override
  List<Object> get props => [to, subject, body];
}

class SavePayment extends PaymentEvent {
  final String uid;
  final DateTime date;
  final String responseCode;
  final String txToken;
  final String referenceNumber;
  final String authorizationCode;
  const SavePayment({
    required this.uid,
    required this.date,
    required this.responseCode,
    required this.txToken,
    required this.referenceNumber,
    required this.authorizationCode,
  });

  @override
  List<Object> get props => [
        uid,
        date,
        responseCode,
        txToken,
        referenceNumber,
        authorizationCode,
      ];
}

class SaveSession extends PaymentEvent {
  final String uid;
  final String session;
  final String sessionKey;
  final int amount;
  const SaveSession(
      {required this.uid,
      required this.session,
      required this.sessionKey,
      required this.amount});

  @override
  List<Object> get props => [uid, session, sessionKey, amount];
}

final class ValidatePayment extends PaymentEvent {
  final Payment payment;
  const ValidatePayment({required this.payment});

  @override
  List<Object> get props => [payment];
}

final class UpdateSession extends ProfilePaymentEvent {
  final Session session;

  const UpdateSession({required this.session, required super.patient});

  @override
  List<Object> get props => [patient, session];
}

final class UpdateSubscriptionType extends ProfilePaymentEvent {
  final SubscriptionType subscriptionType;
  final Payment payment;

  const UpdateSubscriptionType(
      {required this.subscriptionType,
      required this.payment,
      required super.patient});

  @override
  List<Object> get props => [patient, subscriptionType];
}

final class RestartPayment extends PaymentEvent {}
