import 'package:flutter/foundation.dart';
import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/authentication/authentication_export.dart';

class UpdateRemoteProfilePhotoUseCase {
  final MemberRepository _memberRepository;

  UpdateRemoteProfilePhotoUseCase(this._memberRepository);

  Future<DataState<String>> call({
    required String uid,
    required Uint8List imageBytes,
  }) async {
    return await _memberRepository.updateProfilePhoto(uid, imageBytes);
  }
}
