import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:medired/core/core_export.dart';
import 'package:medired/core/database/collections.dart';
import 'package:medired/features/appointments/domain/repository/appointments_repository.dart';
import 'package:medired/features/single_appointment/data/models/appointment_model.dart';
import 'package:medired/features/single_appointment/domain/entities/appointment.dart';

class AppointmentsRepositoryImpl extends AppointmentsRepository {
  final firestore.FirebaseFirestore _firestore;

  AppointmentsRepositoryImpl(this._firestore);

  @override
  Stream<DataState<List<Appointment>>> getUpcomingPatientAppointments(
    String uid,
  ) {
    return _getAppointments(
      _firestore
          .collection(Collections.appointment)
          .where('appointmentInfo.patient.uid', isEqualTo: uid)
          .snapshots(),
    );
  }

  @override
  Stream<DataState<List<Appointment>>> getUpcomingServiceProviderAppointments(
    String uid,
  ) {
    return _getAppointments(
      _firestore
          .collection(Collections.appointment)
          .where('appointmentInfo.serviceProvider.uid', isEqualTo: uid)
          .snapshots(),
    );
  }

  @override
  Stream<DataState<List<Appointment>>> getPendingPatientAppointments() {
    return _getAppointments(
      _firestore
          .collection(Collections.appointment)
          .where('status', isEqualTo: AppointmentStatus.pending.index)
          .snapshots(),
    );
  }

  Stream<DataState<List<Appointment>>> _getAppointments(
    Stream<firestore.QuerySnapshot> querySnapshotStream,
  ) {
    return querySnapshotStream.map((querySnapshot) {
      try {
        if (querySnapshot.docs.any((element) => element.data() == null)) {
          return const Left('An error ocurred while parsing appointments');
        } else {
          List<Appointment> appointments = querySnapshot.docs
              .map((doc) =>
                  AppointmentModel.fromJson(doc.data() as Map<String, dynamic>))
              .toList();
          return Right(appointments);
        }
      } on firestore.FirebaseException catch (error) {
        return Left(
            error.message ?? 'An error occurred while getting appointments');
      }
    });
  }
}
