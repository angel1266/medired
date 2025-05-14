import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/payment/domain/repository/payment_repo.dart';

class SendEmailUseCase {
  final PaymentRepo _repo;
  SendEmailUseCase(this._repo);

  Future<DataState<String>> execute(
      String to, String subject, String body) async {
    return await _repo.sendEmail(to, subject, body);
  }
}
