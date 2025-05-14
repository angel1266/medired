import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/single_appointment/domain/entities/appointment.dart';

abstract class AppointmentsRepository {
  Stream<DataState<List<Appointment>>> getUpcomingPatientAppointments(
    String uid,
  );
  Stream<DataState<List<Appointment>>> getUpcomingServiceProviderAppointments(
    String uid,
  );

  Stream<DataState<List<Appointment>>> getPendingPatientAppointments();
}
