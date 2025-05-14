part of 'payment_bloc.dart';

sealed class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

final class UnloadedPayment extends PaymentState {}

/*
--- 🌟⏳ Loading ⏳🌟 ---
*/
final class LoadingPayment extends PaymentState {}

final class LoadingTestCardnetPayment extends LoadingPayment {}

final class LoadingTestResponseCodePayment extends LoadingPayment {}

final class LoadingCardnetPayment extends LoadingPayment {}

final class LoadingResponseCodePayment extends LoadingPayment {}

final class LoadingSendEmail extends LoadingPayment {}

final class LoadingSavePayment extends LoadingPayment {}

final class LoadingSaveSession extends LoadingPayment {}

final class LoadingValidatePayment extends LoadingPayment {}

final class LoadingUpdateSession extends LoadingPayment {}

final class LoadingUpdateSubscriptionType extends LoadingPayment {}

/*
--- 🌟✅ Success ✅🌟 ---
*/
final class SuccessPayment extends PaymentState {
  const SuccessPayment();
}

final class SuccessTestCardnetPayment extends SuccessPayment {
  final CardnetSession cardnetSession;
  final int amount;

  const SuccessTestCardnetPayment(
      {required this.cardnetSession, required this.amount});

  @override
  List<Object> get props => [cardnetSession];
}

final class SuccessTestResponseCodePayment extends SuccessPayment {}

final class SuccessCardnetPayment extends SuccessPayment {}

final class SuccessResponseCodePayment extends SuccessPayment {
  final TransactionResponse response;

  const SuccessResponseCodePayment({required this.response});

  @override
  List<Object> get props => [response];
}

final class SuccessSendEmail extends SuccessPayment {}

final class SuccessSavePayment extends SuccessPayment {}

final class SuccessSaveSession extends SuccessPayment {
  final Session session;

  const SuccessSaveSession({required this.session});

  @override
  List<Object> get props => [session];
}

final class SuccessValidatePayment extends SuccessPayment {}

final class SuccessUpdateSession extends SuccessPayment {
  final Patient patient;
  final Session session;
  String get url => 'https://pagosmedired.web.app/?SESSION=${session.session}';

  const SuccessUpdateSession({required this.patient, required this.session});
}

final class SuccessUpdateSubscriptionType extends SuccessPayment {
  final Payment payment;

  const SuccessUpdateSubscriptionType({required this.payment});
}

/*
--- 🌟🚨 Error 🚨🌟 ---
*/
final class ErrorPayment extends PaymentState {
  final String error;

  const ErrorPayment(this.error);

  String get genericError => 'Error payment';

  @override
  List<Object> get props => [error];
}

final class ErrorTestCardnetPayment extends ErrorPayment {
  const ErrorTestCardnetPayment(super.error);

  @override
  String get genericError => 'Error test cardnet';
}

final class ErrorTestResponseCodePayment extends ErrorPayment {
  const ErrorTestResponseCodePayment(super.error);

  @override
  String get genericError => 'Error test response code';
}

final class ErrorCardnetPayment extends ErrorPayment {
  const ErrorCardnetPayment(super.error);

  @override
  String get genericError => 'Error cardnet';
}

final class ErrorResponseCodePayment extends ErrorPayment {
  const ErrorResponseCodePayment(super.error);

  @override
  String get genericError => 'Error response code';
}

final class ErrorSendEmail extends ErrorPayment {
  const ErrorSendEmail(super.error);

  @override
  String get genericError => 'Error send email';
}

final class ErrorSavePayment extends ErrorPayment {
  const ErrorSavePayment(super.error);

  @override
  String get genericError => 'Error save payment';
}

final class ErrorSaveSession extends ErrorPayment {
  const ErrorSaveSession(super.error);

  @override
  String get genericError => 'Error save session';
}

final class ErrorValidatePayment extends ErrorPayment {
  const ErrorValidatePayment(super.error);

  @override
  String get genericError => 'Error validate payment';
}

final class ErrorUpdateSession extends ErrorPayment {
  const ErrorUpdateSession(super.error);

  @override
  String get error => 'Error update session';
}

final class ErrorUpdateSubscriptionType extends ErrorPayment {
  const ErrorUpdateSubscriptionType(super.error);

  @override
  String get error => 'Error update subscription type';
}
