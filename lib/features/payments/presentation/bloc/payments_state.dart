part of 'payments_bloc.dart';

sealed class PaymentsState extends Equatable {
  const PaymentsState();

  @override
  List<Object> get props => [];
}

final class UnloadedPayments extends PaymentsState {}

/*
--- 🌟⏳ Loading ⏳🌟 ---
*/
final class LoadingPayments extends PaymentsState {}

final class LoadingListenPayments extends LoadingPayments {}

final class LoadingStartListeningPayments extends LoadingPayments {}

final class LoadingStopListeningPayments extends LoadingPayments {}

/*
--- 🌟✅ Success ✅🌟 ---
*/

final class SuccessPayments extends PaymentsState {
  const SuccessPayments();
}

final class SuccessStartListeningPayments extends SuccessPayments {}

final class SuccessStopListeningPayments extends SuccessPayments {}

final class SuccessListenPayments extends SuccessPayments {
  final Payment payment;

  const SuccessListenPayments({required this.payment});

  @override
  List<Object> get props => [payment];
}

/*
--- 🌟🚨 Error 🚨🌟 ---
*/
final class ErrorPayments extends PaymentsState {
  final String error;

  const ErrorPayments(this.error);

  String get genericError => 'Error payment';

  @override
  List<Object> get props => [error];
}

final class ErrorListenPayments extends ErrorPayments {
  const ErrorListenPayments(super.error);

  @override
  String get genericError => 'Error listen payments';
}

final class ErrorStartListeningPayments extends ErrorPayments {
  const ErrorStartListeningPayments(super.error);

  @override
  String get genericError => 'Error start listening payments';
}

final class ErrorStopListeningPayments extends ErrorPayments {
  const ErrorStopListeningPayments(super.error);

  @override
  String get genericError => 'Error stop listening payments';
}
