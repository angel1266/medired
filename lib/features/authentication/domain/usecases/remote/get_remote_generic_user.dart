import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/authentication/authentication_export.dart';

class GetRemoteMemberUseCase {
  final MemberRepository _memberRepository;
  GetRemoteMemberUseCase(this._memberRepository);

  Future<DataState<Member>> call({required String uid}) async {
    return await _memberRepository.getRemoteMember(
      uid,
    );
  }
}
