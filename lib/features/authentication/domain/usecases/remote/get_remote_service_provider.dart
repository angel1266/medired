import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/authentication/domain/entities/service_provider.dart';
import 'package:medired/features/authentication/domain/repository/service_provider_repository.dart';

class GetRemoteServiceProviderUseCase {
  final ServiceProviderRepository _serviceProviderRepository;

  GetRemoteServiceProviderUseCase(this._serviceProviderRepository);

  Future<DataState<ServiceProvider>> call({required String uid}) async {
    return await _serviceProviderRepository.getRemoteServiceProvider(uid);
  }
}
