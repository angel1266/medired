import 'package:medired/core/core_export.dart';
import 'package:medired/features/authentication/domain/entities/ars.dart';

import '../../repository/authentication_repository_export.dart';

class GetRemoteARSUseCase {
  final ARSRepository _arsRepository;

  GetRemoteARSUseCase(this._arsRepository);

  Future<DataState<ARS>> call({required String uid}) async {
    return await _arsRepository.getRemoteARS(uid);
  }
}
