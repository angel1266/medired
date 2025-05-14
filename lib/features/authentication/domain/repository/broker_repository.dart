import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/authentication/domain/entities/broker.dart';

abstract class BrokerRepository {
  Future<DataState<Broker>> createRemoteBroker(
    Broker broker,
  );

  Future<DataState<Broker>> getRemoteBroker(String uid);

  Future<DataState<List<Broker>>> getRemoteListBroker();
}