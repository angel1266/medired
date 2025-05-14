import 'package:medired/core/core_export.dart';
import 'package:medired/features/authentication/authentication_export.dart';

class CreateRemoteARSUseCase {
  final ARSRepository _arsRepository;
  CreateRemoteARSUseCase(this._arsRepository);
  Future<DataState<ARS>> call({required ARS ars}) async {
    return await _arsRepository.createRemoteARS(ars);
  }
}