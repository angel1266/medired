import 'package:medired/core/core_export.dart';
import 'package:medired/features/subscription/domain/entities/subscription.dart';
import 'package:medired/features/subscription/domain/repository/subscription_repo.dart';

class GetSubscriptionUseCase {
  final SubscriptionRepo _subscriptionRepo;

  GetSubscriptionUseCase(this._subscriptionRepo);

  Future<DataState<Subscription>> call({required String uid}) async {
    return await _subscriptionRepo.getSubscription(uid);
  }

}