import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:medired/core/core_export.dart';
import 'package:medired/core/database/collections.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/features/authentication/data/models/admin_model.dart';

class AdminRepoImpl implements AdminRepo {
  final firestore.FirebaseFirestore _firestore;

  AdminRepoImpl(this._firestore);

  @override
  Future<DataState<Admin>> getRemoteAdmin(String uid) async {
    try {
      firestore.DocumentSnapshot documentSnapshot =
          await _firestore.collection(Collections.admin).doc(uid).get();
      Map<String, dynamic> json =
          documentSnapshot.data() as Map<String, dynamic>;

      Admin admin = AdminModel.fromJson(json);
      return Right(admin);
    } on firestore.FirebaseException catch (error) {
      return Left(error.message!);
    }
  }
}
