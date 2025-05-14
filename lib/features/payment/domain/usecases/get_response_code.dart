import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/authentication/domain/entities/transaction_response.dart';
import 'package:medired/features/payment/domain/repository/payment_repo.dart';

class GetResponseCodeUseCase {
  final PaymentRepo _repo;

  GetResponseCodeUseCase(this._repo);

  Future<DataState<TransactionResponse>> execute(
      String session, String sessionKey) async {
    return await _repo.getResponseCode(session, sessionKey);
  }
}
