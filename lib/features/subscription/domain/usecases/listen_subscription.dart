import 'package:medired/core/core_export.dart';
import 'package:medired/features/subscription/domain/entities/subscription.dart';
import 'package:medired/features/subscription/domain/services/subscription_service.dart';

class ListenSubscriptionUseCase {
  final SubscriptionService _service;

  ListenSubscriptionUseCase(this._service);

  Stream<DataState<Subscription>> call() => _service.listenToSubscription();
}
