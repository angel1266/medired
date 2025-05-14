import 'package:medired/features/subscription/domain/services/subscription_service.dart';

class StartListeningSubscriptionUseCase {
  final SubscriptionService _service;

  StartListeningSubscriptionUseCase(this._service);

  void call(String uid) => _service.startListening(uid);
}
