import 'package:dio/dio.dart';
import 'package:medired/core/constants/constants.dart';
import 'package:medired/features/payment/data/models/cardnet_session_model.dart';
import 'package:retrofit/retrofit.dart';

part 'payment_ds.g.dart';

@RestApi(baseUrl: Constants.baseUrl)
abstract class PaymentDs {
  factory PaymentDs(Dio dio, {String baseUrl}) = _PaymentDs;

  @GET('/postToCardnetApi')
  Future<HttpResponse<CardnetSessionModel>> postToCardnet(
    @Query('amount') String amount,
    @Query('pass') String pass,
  );
  @GET('/fetchResponseCodeFromFirestore')
  Future<HttpResponse<String>> getResponseCode(
    @Query('session') String session,
    @Query('sessionKey') String sessionKey,
  );
  @GET('/postTestToCardnetApi')
  Future<HttpResponse<CardnetSessionModel>> postTestToCardnet(
    @Query('amount') String amount,
    @Query('pass') String pass,
    @Query('uid') String uid,
    @Query('transactionType') int transactionType,
  );
  @GET('/fetchTestResponseCodeFromFirestore')
  Future<HttpResponse<String>> getTestResponseCode(
    @Query('session') String session,
    @Query('sessionKey') String sessionKey,
  );
  @GET('/email')
  Future<HttpResponse<String>> sendEmail(
    @Query('to') String to,
    @Query('subject') String subject,
    @Query('text') String text,
  );
}
