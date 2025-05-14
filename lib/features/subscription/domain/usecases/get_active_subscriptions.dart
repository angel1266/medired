import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/authentication/domain/entities/patient.dart';
import 'package:medired/features/subscription/domain/repository/subscription_repo.dart';

class GetActiveSubscriptionsUseCase {
  final SubscriptionRepo _repo;

  GetActiveSubscriptionsUseCase(this._repo);

  Future<DataState<List<Patient>>> call() async {
    return await _repo.getActiveSubscriptions();
  }
}
