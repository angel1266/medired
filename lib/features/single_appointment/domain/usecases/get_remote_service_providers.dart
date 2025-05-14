import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/authentication/domain/entities/service_provider.dart';
import 'package:medired/features/authentication/domain/repository/service_provider_repository.dart';

class GetRemoteServiceProvidersUseCase {
  final ServiceProviderRepository _serviceProviderRepository;
  GetRemoteServiceProvidersUseCase(this._serviceProviderRepository);
  Future<DataState<List<ServiceProvider>>> call({void params}) async {
    return await _serviceProviderRepository.getRemoteServiceProviders();
  }
}
