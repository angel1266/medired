import 'package:medired/core/core_export.dart';
import 'package:medired/features/authentication/domain/repository/member_repository.dart';

class UpdateRemoteMemberSubscriptionUseCase {
  final MemberRepository _memberRepository;
  UpdateRemoteMemberSubscriptionUseCase(this._memberRepository);

  Future<DataState<Unit>> call({
    required String uid,
    required SubscriptionType subscriptionType,
  }) async {
    return await _memberRepository.updateRemoteSubscription(
      uid,
      subscriptionType,
    );
  }
}
