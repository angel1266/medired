import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/authentication/authentication_export.dart';

class CreateRemoteBrokerUseCase {
  final BrokerRepository _brokerRepository;
  CreateRemoteBrokerUseCase(this._brokerRepository);
  Future<DataState<Broker>> call({required Broker broker}) async {
    return await _brokerRepository.createRemoteBroker(broker);
  }
}