import 'dart:async';
import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/payment/domain/entities/payment.dart';
import 'package:medired/features/payment/domain/repository/payment_repo.dart';

abstract class PaymentsService {
  Stream<DataState<Payment>> listenLastUnprocessedPayment();
  void startListening(String uid, [DateTime? time]);
  void stopListening();
}

class PaymentsServiceImpl implements PaymentsService {
  final PaymentRepo _repo;
  StreamController<DataState<Payment>>? _controller;
  StreamSubscription<DataState<Payment>>? _subscription;

  PaymentsServiceImpl(this._repo);

  @override
  Stream<DataState<Payment>> listenLastUnprocessedPayment() {
    _controller ??= StreamController<DataState<Payment>>.broadcast();
    return _controller!.stream;
  }

  @override
  void startListening(String uid, [DateTime? time]) {
    stopListening();
    _controller = StreamController<DataState<Payment>>.broadcast();
    _subscription = _repo.listenLastUnprocessedPayment(uid).listen(
      (dataState) {
        _controller?.add(dataState);
      },
      onError: (error) {
        _controller?.addError(error);
      },
    );
  }

  @override
  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
    _controller?.close();
    _controller = null;
  }
}
