import 'package:medired/core/core_export.dart';
import 'package:medired/features/authentication/domain/entities/member_info.dart';
import 'package:medired/features/authentication/domain/entities/patient.dart';

abstract class PatientRepository {
  Future<DataState<Patient>> createRemotePatient(Patient patient);

  Future<DataState<Patient>> updateRemotePatient(Patient patient);

  Stream<DataState<Patient>> listenRemotePatient(String uid);

  Future<DataState<MemberInfo>> getRemoteMember(String uid);

  Future<DataState<Patient>> getRemotePatient(String uid);
}
