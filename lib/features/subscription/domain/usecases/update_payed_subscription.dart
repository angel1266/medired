import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/subscription/domain/repository/subscription_repo.dart';

class UpdatePayedSubscriptionUseCase {
  final SubscriptionRepo _repo;

  UpdatePayedSubscriptionUseCase(this._repo);

  Future<DataState<bool>> call({
    required String subscriptionId,
    required String uid,
    required String amount,
    required String subscriptionType,
  }) async {
    return await _repo.updatePayedSubscription(
        subscriptionId, uid, amount, subscriptionType);
  }
}
