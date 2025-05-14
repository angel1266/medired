import 'package:medired/core/core_export.dart';
import 'package:medired/features/authentication/authentication_export.dart';

class SavePointsUseCase {
  final MemberRepository _repo;

  SavePointsUseCase(this._repo);

  Future<DataState<Unit>> execute(String uid, int amount) async {
    return await _repo.savePoints(uid, amount);
  }
}
