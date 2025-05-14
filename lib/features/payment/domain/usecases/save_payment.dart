import 'package:medired/core/core_export.dart';
import 'package:medired/features/payment/domain/repository/payment_repo.dart';

class SavePaymentUseCase {
  final PaymentRepo _repo;
  SavePaymentUseCase(this._repo);

  Future<DataState<Unit>> execute(
      String uid,
      DateTime date,
      String responseCode,
      String txToken,
      String referenceNumber,
      String authorizationCode) async {
    return await _repo.savePayment(
        uid, date, responseCode, txToken, referenceNumber, authorizationCode);
  }
}
