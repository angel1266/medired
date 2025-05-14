part of 'payments_bloc.dart';

sealed class PaymentsEvent extends Equatable {
  const PaymentsEvent();

  @override
  List<Object> get props => [];
}

class ListenLastUnprocessedPayment extends PaymentsEvent {
  const ListenLastUnprocessedPayment();
}

final class StartListeningPayments extends PaymentsEvent {
  final String uid;
  const StartListeningPayments({required this.uid});
}

final class StopListeningPayments extends PaymentsEvent {}
