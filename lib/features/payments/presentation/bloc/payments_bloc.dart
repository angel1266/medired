import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medired/features/payment/domain/entities/payment.dart';
import 'package:medired/features/payments/data/usecases/listen_last_unprocessed_payment.dart';
import 'package:medired/features/payments/data/usecases/start_listening_payments.dart';
import 'package:medired/features/payments/data/usecases/stop_listening_payments.dart';

part 'payments_event.dart';
part 'payments_state.dart';

class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  final ListenLastUnprocessedPaymentUseCase _listenLastUnprocessed;
  final StartListeningPaymentsUseCase _startListening;
  final StopListeningPaymentsUseCase _stopListening;
  PaymentsBloc(
      this._listenLastUnprocessed, this._startListening, this._stopListening)
      : super(UnloadedPayments()) {
    on<StartListeningPayments>(_startListeningPayments);
    on<ListenLastUnprocessedPayment>(_listenLastUnprocessedPayment);
    on<StopListeningPayments>(_stopListeningPayments);
  }

  Future<void> _startListeningPayments(
      StartListeningPayments event, Emitter<PaymentsState> emit) async {
    _startListening.call(event.uid);
    emit(SuccessStartListeningPayments());
  }

  Future<void> _listenLastUnprocessedPayment(
      ListenLastUnprocessedPayment event, Emitter<PaymentsState> emit) async {
    emit(LoadingListenPayments());
    await emit.forEach(
      _listenLastUnprocessed.execute().asBroadcastStream(),
      onData: (result) => result.fold(
        (l) => ErrorListenPayments(l),
        (r) => SuccessListenPayments(payment: r),
      ),
      onError: (error, stackTrace) => ErrorListenPayments(error.toString()),
    );
  }

  Future<void> _stopListeningPayments(
      StopListeningPayments event, Emitter<PaymentsState> emit) async {
    emit(UnloadedPayments());
    _stopListening.call();
    emit(SuccessStopListeningPayments());
  }
}
