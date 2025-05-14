
import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/authentication/authentication_export.dart';

class GetRemoteBrokerUseCase {
  final BrokerRepository _brokerRepository;

  GetRemoteBrokerUseCase(this._brokerRepository);

  Future<DataState<Broker>> call({required String uid}) async {
    return await _brokerRepository.getRemoteBroker(uid);
  }
}