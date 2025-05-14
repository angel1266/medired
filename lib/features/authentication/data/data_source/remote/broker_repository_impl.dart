import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:medired/core/core_export.dart';
import 'package:medired/core/database/collections.dart';
import 'package:medired/features/authentication/authentication_export.dart';

class BrokerRepositoryImpl implements BrokerRepository {
  final firestore.FirebaseFirestore _firestore;

  BrokerRepositoryImpl(this._firestore);
  @override
  Future<DataState<Broker>> createRemoteBroker(Broker ars) async {
    try {
      BrokerModel arsModel = BrokerModel.fromEntity(ars);

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
  Future<DataState<Broker>> getRemoteBroker(String uid) async {
    try {
      firestore.DocumentSnapshot documentSnapshot =
          await _firestore.collection(Collections.member).doc(uid).get();
      Map<String, dynamic> json =
          documentSnapshot.data() as Map<String, dynamic>;

      Broker ars = BrokerModel.fromJson(json);
      return Right(ars);
    } on firestore.FirebaseException catch (error) {
      return Left(error.message!);
    }
  }

  @override
  Future<DataState<List<Broker>>> getRemoteListBroker() async {
    try {
      firestore.QuerySnapshot querySnapshot = await _firestore
          .collection(Collections.member)
          .where('userType', isEqualTo: UserType.ars.index)
          .get();
      List<BrokerModel> arsModelList = querySnapshot.docs
          .map(
              (doc) => BrokerModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return Right(arsModelList);
    } on firestore.FirebaseException catch (error) {
      return Left(error.message!);
    }
  }
}
