import 'package:medired/features/subscription/domain/services/subscription_service.dart';

class StopListeningSubscriptionUseCase {
  final SubscriptionService _service;

  StopListeningSubscriptionUseCase(this._service);

  void call() => _service.stopListening();
}
