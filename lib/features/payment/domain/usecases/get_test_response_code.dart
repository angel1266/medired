import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/payment/domain/repository/payment_repo.dart';

class GetTestResponseCodeUseCase {
  final PaymentRepo _repo;

  GetTestResponseCodeUseCase(this._repo);

  Future<DataState<String>> execute(String session, String sessionKey) async {
    return await _repo.getTestResponseCode(session, sessionKey);
  }
}
