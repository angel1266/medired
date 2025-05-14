import 'package:medired/core/core_export.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/features/subscription/domain/entities/subscription.dart';

abstract class SubscriptionRepo {
  Future<DataState<Subscription>> updateSubscription(
      Subscription subscription, String uid);

  Future<DataState<bool>> updatePayedSubscription(String subscriptionId,
      String uid, String amount, String subscriptionType);

  Future<DataState<Subscription>> createSubscription(
      Subscription subscription, String uid);

  Future<DataState<Subscription>> getSubscription(String uid);

  Stream<DataState<Subscription>> listenSubscription(String uid);

  Future<DataState<List<Patient>>> getActiveSubscriptions();
}
