import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:medired/core/database/collections.dart';
import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/core/value_objects/subscription_type.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/features/authentication/data/models/member_model.dart';

class MemberRepositoryImpl implements MemberRepository {
  final firestore.FirebaseFirestore _firestore;
  final storage.FirebaseStorage _firebaseStorage;

  MemberRepositoryImpl(this._firestore, this._firebaseStorage);

  @override
  Future<DataState<Member>> getRemoteMember(String uid) async {
    log('getRemoteMember $uid');
    try {
      firestore.DocumentSnapshot documentSnapshot =
          await _firestore.collection(Collections.member).doc(uid).get();
      Map<String, dynamic>? json =
          documentSnapshot.data() as Map<String, dynamic>?;
      if (json == null) {
        return const Left('Error while getting your credentials');
      }
      log('getRemoteMember ${json['authInfo']['email']}');
      Member member = MemberModel.fromJson(json);
      return Right(member);
    } on firestore.FirebaseException catch (error) {
      return Left(error.message!);
    }
  }

  @override
  Future<DataState<String>> updateProfilePhoto(
      String uid, Uint8List imageBytes) async {
    try {
      // Upload the file to Firebase Storage
      await _firebaseStorage
          .ref('$uid/profile/profile.jpg')
          .putData(imageBytes);

      // Get the download URL
      String url = await _firebaseStorage
          .ref('$uid/profile/profile.jpg')
          .getDownloadURL();

      // Save the URL in Firestore
      await _firestore.collection(Collections.member).doc(uid).update({
        'authInfo.photoUrl': url,
      });

      return Right(url);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<DataState<Unit>> updateRemoteSubscription(
    String uid,
    SubscriptionType subscriptionType,
  ) async {
    try {
      await _firestore
          .collection(Collections.member)
          .doc(uid)
          .update({'subscriptionType': subscriptionType.index});
      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<DataState<Unit>> savePoints(String uid, int amount) async {
    try {
      await _firestore
          .collection(Collections.member)
          .doc(uid)
          .update({'points': FieldValue.increment(amount)});
      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<DataState<Unit>> updateRemoteMember<T extends Member>(T member) async {
    try {
      await _firestore
          .collection(Collections.member)
          .doc(member.authInfo.uid)
          .update(member.toJson());
      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
