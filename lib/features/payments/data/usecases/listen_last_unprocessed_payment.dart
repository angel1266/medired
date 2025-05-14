import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/payment/domain/entities/payment.dart';
import 'package:medired/features/payments/data/services/payments_service.dart';

class ListenLastUnprocessedPaymentUseCase {
  ListenLastUnprocessedPaymentUseCase(this._service);
  final PaymentsService _service;

  Stream<DataState<Payment>> execute() {
    return _service.listenLastUnprocessedPayment();
  }
}
