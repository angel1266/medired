import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/payment/domain/entities/cardnet_session.dart';
import 'package:medired/features/payment/domain/repository/payment_repo.dart';

class PostToCardnetUseCase {
  final PaymentRepo _repo;

  PostToCardnetUseCase(this._repo);

  Future<DataState<CardnetSession>> execute(String amount, String pass) async {
    return await _repo.postToCardnet(amount, pass);
  }
}
