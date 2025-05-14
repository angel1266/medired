import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medired/core/core_export.dart';
import 'package:medired/core/database/collections.dart';
import 'package:medired/features/single_appointment/domain/entities/appointment.dart';
import 'package:medired/features/single_appointment/domain/repository/single_appointment_repository.dart';

class SingleAppointmentRepositoryImpl extends SingleAppointmentRepository {
  final FirebaseFirestore _firestore;

  SingleAppointmentRepositoryImpl(this._firestore);

  @override
  Future<DataState<Unit>> createAppointment<T extends Appointment>(
      T appointment) async {
    try {
      var docRef = _firestore.collection(Collections.appointment).doc();
      await docRef.set(appointment.toJson());
      await docRef.update({'id': docRef.id});

      return const Right(unit);
    } catch (e) {
      return const Left('Ha ocurrido un error al crear la cita');
    }
  }

  @override
  Future<DataState<Unit>> updateAppointmentStatus(
    String id,
    AppointmentStatus status,
  ) async {
    try {
      await _firestore.collection(Collections.appointment).doc(id).update({
        'status': status.index,
      });

      return const Right(unit);
    } on FirebaseException catch (error) {
      return Left(error.message!);
    }
  }
}
