import 'package:medired/core/core_export.dart';
import 'package:medired/features/authentication/domain/entities/session.dart';
import 'package:medired/features/payment/domain/repository/payment_repo.dart';

class SaveSessionUseCase {
  final PaymentRepo _repo;
  SaveSessionUseCase(this._repo);

  Future<DataState<Session>> execute(
      String uid, String session, String sessionKey, String amount) async {
    return await _repo.saveSession(uid, session, sessionKey, amount);
  }
}
