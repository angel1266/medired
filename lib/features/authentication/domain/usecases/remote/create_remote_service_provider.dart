import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/authentication/domain/entities/service_provider.dart';
import 'package:medired/features/authentication/domain/repository/service_provider_repository.dart';

class CreateRemoteServiceProviderUseCase {
  final ServiceProviderRepository _serviceProviderRepository;
  CreateRemoteServiceProviderUseCase(this._serviceProviderRepository);
  Future<DataState<ServiceProvider>> call({required ServiceProvider serviceProvider}) async {
    return await _serviceProviderRepository.createRemoteServiceProvider(serviceProvider);
  }
}
