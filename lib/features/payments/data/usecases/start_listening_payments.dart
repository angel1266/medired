import 'package:medired/features/payments/data/services/payments_service.dart';

class StartListeningPaymentsUseCase {
  final PaymentsService _service;

  StartListeningPaymentsUseCase(this._service);

  void call(String uid) {
    _service.startListening(uid);
  }
}
