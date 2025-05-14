import 'package:medired/core/core_export.dart';
import 'package:medired/features/subscription/domain/entities/subscription.dart';
import 'package:medired/features/subscription/domain/repository/subscription_repo.dart';

class UpdateSubscriptionUseCase {
  final SubscriptionRepo _subscriptionRepo;

  UpdateSubscriptionUseCase(this._subscriptionRepo);

  Future<DataState<Subscription>> call(
      {required Subscription subscription, required String uid}) async {
    return await _subscriptionRepo.updateSubscription(subscription, uid);
  }
}
