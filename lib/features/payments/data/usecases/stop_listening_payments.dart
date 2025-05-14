import 'package:medired/features/payments/data/services/payments_service.dart';

class StopListeningPaymentsUseCase {
  final PaymentsService _service;

  StopListeningPaymentsUseCase(this._service);

  void call() {
    _service.stopListening();
  }
}
