import 'package:medired/features/authentication/data/models/transaction_response_model.dart';
import 'package:dio/dio.dart';
import 'package:medired/core/constants/constants.dart';
import 'package:retrofit/retrofit.dart';

part 'cardnet_ds.g.dart';

@RestApi(baseUrl: Constants.cardNetUrl)
abstract class CardNetDs {
  factory CardNetDs(Dio dio, {String baseUrl}) = _CardNetDs;

  @GET('/sessions/{sessionId}')
  Future<TransactionResponseModel> getTransactionResponse(
    @Path('sessionId') String sessionId,
    @Query('sk') String sk,
  );
}
