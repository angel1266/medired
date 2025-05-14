import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:medired/core/core_export.dart';
import 'package:medired/core/database/collections.dart';
import 'package:medired/features/authentication/authentication_export.dart';

class ARSRepositoryImpl implements ARSRepository {
  final firestore.FirebaseFirestore _firestore;

  ARSRepositoryImpl(this._firestore);

  @override
  Future<DataState<ARS>> createRemoteARS(ARS ars) async {
    try {
      ARSModel arsModel = ARSModel.fromEntity(ars);

      await _firestore
          .collection(Collections.member)
          .doc(ars.authInfo.uid)
          .set(arsModel.toJson());
      return Right(arsModel);
    } on firestore.FirebaseException catch (error) {
      return Left(error.message!);
    }
  }

  @override
  Future<DataState<ARS>> getRemoteARS(String uid) async {
    try {
      firestore.DocumentSnapshot documentSnapshot =
          await _firestore.collection(Collections.member).doc(uid).get();
      Map<String, dynamic> json =
          documentSnapshot.data() as Map<String, dynamic>;

      ARS ars = ARSModel.fromJson(json);
      return Right(ars);
    } on firestore.FirebaseException catch (error) {
      return Left(error.message!);
    }
  }

  @override
  Future<DataState<List<ARS>>> getRemoteListARS() async {
    try {
      firestore.QuerySnapshot querySnapshot = await _firestore
          .collection(Collections.member)
          .where('userType', isEqualTo: UserType.ars.index)
          .get();
      List<ARSModel> arsModelList = querySnapshot.docs
          .map((doc) => ARSModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return Right(arsModelList);
    } on firestore.FirebaseException catch (error) {
      return Left(error.message!);
    }
  }

  @override
  Future<DataState<String>> updateARS(
      String uid, Map<String, Object?> values) async {
    try {
      await _firestore.collection(Collections.member).doc(uid).update(values);
      return const Right('Ok');
    } catch (e) {
      return const Left('No Ok');
    }
  }
}
