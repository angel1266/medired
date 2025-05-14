import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/authentication/domain/entities/service_provider.dart';

abstract class ServiceProviderRepository {
  Future<DataState<ServiceProvider>> createRemoteServiceProvider(
    ServiceProvider serviceProvider,
  );

  Future<DataState<ServiceProvider>> getRemoteServiceProvider(String uid);

  Future<DataState<List<ServiceProvider>>> getRemoteServiceProviders();
}
