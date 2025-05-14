import 'package:medired/core/core_export.dart';
import 'package:medired/features/payment/domain/repository/payment_repo.dart';

class ValidatePaymentUseCase {
  final PaymentRepo _repo;

  ValidatePaymentUseCase(this._repo);

  Future<DataState<Unit>> execute(String id) async {
    return await _repo.validatePayment(id);
  }
}
