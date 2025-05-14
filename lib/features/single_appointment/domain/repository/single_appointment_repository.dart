import 'package:medired/core/core_export.dart';
import 'package:medired/features/single_appointment/domain/entities/appointment.dart';

abstract class SingleAppointmentRepository {
  Future<DataState<Unit>> createAppointment<T extends Appointment>(
      T appointment);

  Future<DataState<Unit>> updateAppointmentStatus(
      String id, AppointmentStatus status);
}
