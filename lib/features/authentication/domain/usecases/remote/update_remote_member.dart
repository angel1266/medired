import 'package:medired/core/bloc/bloc_export.dart';
import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/authentication/authentication_export.dart';

class UpdateRemoteMemberUseCase {
  final MemberRepository _repo;

  UpdateRemoteMemberUseCase(this._repo);

  Future<DataState<Unit>> call<T extends Member>(T member) async {
    return await _repo.updateRemoteMember(member);
  }
}
