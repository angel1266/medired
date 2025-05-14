import 'package:dio/dio.dart';
import 'package:medired/core/constants/constants.dart';
import 'package:retrofit/retrofit.dart';

part 'subscription_ds.g.dart';

@RestApi(baseUrl: Constants.baseUrl)
abstract class SubscriptionDs {
  factory SubscriptionDs(Dio dio, {String baseUrl}) = _SubscriptionDs;

  @POST('/updateSubscriptionandAmounts')
  Future<HttpResponse<String>> updateSubscriptionandAmounts(
    @Query('uid') String uid,
    @Query('subscriptionId') String subscriptionId,
    @Query('amount') String amount,
    @Query('subscriptionType') String subscriptionType,
  );
}
