import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/payment/domain/entities/cardnet_session.dart';
import 'package:medired/features/payment/domain/repository/payment_repo.dart';

class PostTestToCardnetUseCase {
  final PaymentRepo _repo;

  PostTestToCardnetUseCase(this._repo);

  Future<DataState<CardnetSession>> execute(
      String amount, String pass, String uid, int transactionType) async {
    return await _repo.postTestToCardnet(amount, pass, uid, transactionType);
  }
}
