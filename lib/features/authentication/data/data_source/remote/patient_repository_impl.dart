import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medired/core/core_export.dart';
import 'package:medired/core/database/collections.dart';
import 'package:medired/features/authentication/data/models/member_info_model.dart';
import 'package:medired/features/authentication/data/models/patient_model.dart';
import 'package:medired/features/authentication/domain/entities/member_info.dart';
import 'package:medired/features/authentication/domain/entities/patient.dart';
import 'package:medired/features/authentication/domain/repository/patient_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

class PatientRepositoryImpl extends PatientRepository {
  // final UserDao _dao;
  final firestore.FirebaseFirestore _firestore;

  PatientRepositoryImpl(this._firestore);

  @override
  Future<DataState<Patient>> createRemotePatient(Patient patient) async {
    try {
      PatientModel patientModel = PatientModel.fromEntity(patient);
      await _firestore
          .collection(Collections.member)
          .doc(patientModel.authInfoModel.uid)
          .set(patientModel.toJson());

      return Right(Patient.toEntity(patientModel));
    } catch (e) {
      return const Left('Ha ocurrido un error al crear el usuario');
    }
  }

  @override
  Future<DataState<Patient>> updateRemotePatient(Patient patient) async {
    try {
      PatientModel patientModel = PatientModel.fromEntity(patient);
      await _firestore
          .collection(Collections.member)
          .doc(patientModel.authInfoModel.uid)
          .update(patientModel.toJson());

      return Right(Patient.toEntity(patientModel));
    } catch (e) {
      return const Left('Ha ocurrido un error al crear el usuario');
    }
  }

  @override
  Stream<DataState<Patient>> listenRemotePatient(String uid) {
    return _firestore.collection(Collections.member).doc(uid).snapshots().map(
      (documentSnapshot) {
        Map<String, dynamic>? json = documentSnapshot.data();

        if (json == null) {
          return const Left('Ha ocurrido un error al obtener este usuario');
        } else {
          PatientModel patient = PatientModel.fromJson(json);
          return Right(patient);
        }
      },
    );
  }

  @override
  Future<DataState<MemberInfo>> getRemoteMember(String uid) async {
    try {
      var documentSnapshot =
          await _firestore.collection(Collections.member).doc(uid).get();

      Map<String, dynamic>? json = documentSnapshot.data();

      if (json == null) {
        return const Left('El usuario no existe');
      }

      MemberInfo member = MemberInfoModel.fromJson(json);

      return Right(member);
    } catch (e) {
      return const Left('Ha ocurrido un error al obtener un usuario');
    }
  }

  @override
  Future<DataState<Patient>> getRemotePatient(String uid) async {
    try {
      var documentSnapshot =
          await _firestore.collection(Collections.member).doc(uid).get();

      Map<String, dynamic>? json = documentSnapshot.data();

      if (json == null) {
        QuerySnapshot documentSnapshot1 = await _firestore
            .collection(Collections.member)
            .where('personalInfo.token_google', isEqualTo: uid)
            .get();

        if (documentSnapshot1.docs.isEmpty) {
          QuerySnapshot documentSnapshot1 = await _firestore
              .collection(Collections.member)
              .where('personalInfo.token_facebook', isEqualTo: uid)
              .get();

          if (documentSnapshot1.docs.isEmpty) {
            return const Left('El usuario no existe');
          } else {
            for (QueryDocumentSnapshot document in documentSnapshot1.docs) {
              json = document.data() as Map<String, dynamic>;
              // Process the retrieved data
            }
          }
        } else {
          for (QueryDocumentSnapshot document in documentSnapshot1.docs) {
            json = document.data() as Map<String, dynamic>;
            // Process the retrieved data
          }
        }
      }
      Patient patient = PatientModel.fromJson(json!);

      return Right(patient);
    } catch (e) {
      print('$e');
      return const Left('Ha ocurrido un error al obtener el usuario ');
    }
  }
}
