import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:medired/core/core_export.dart';
import 'package:medired/core/database/collections.dart';
import 'package:medired/features/appointments/data/models/medical_test_model.dart';
import 'package:medired/features/appointments/domain/entities/medical_test.dart';
import 'package:medired/features/appointments/domain/repository/medical_test_repo.dart';

class MedicalTestRepoImpl implements MedicalTestRepo {
  final firestore.FirebaseFirestore _firestore;

  MedicalTestRepoImpl(this._firestore);

  @override
  Future<DataState<List<MedicalTest>>> getMedicalTests() async {
    try {
      var snapshot = await _firestore.collection(Collections.medicalTest).get();
      List<MedicalTest> medicalTests = snapshot.docs
          .map((doc) => MedicalTestModel.fromJson(doc.data()))
          .toList();
      return Right(medicalTests);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
