import 'package:medired/core/core_export.dart';
import 'package:medired/features/authentication/domain/entities/authentication_entities.dart';

abstract class MemberRepository {
  Future<DataState<Member>> getRemoteMember(String uid);

  Future<DataState<Unit>> updateRemoteMember<T extends Member>(T member);

  Future<DataState<String>> updateProfilePhoto(
      String uid, Uint8List imageBytes);

  Future<DataState<Unit>> updateRemoteSubscription(
      String uid, SubscriptionType subscriptionType);

  Future<DataState<Unit>> savePoints(String uid, int amount);
}
