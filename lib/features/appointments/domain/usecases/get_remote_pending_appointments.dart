import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/appointments/domain/repository/appointments_repository.dart';
import 'package:medired/features/single_appointment/domain/entities/appointment.dart';

class GetRemotePendingAppointmentsUseCase {
  final AppointmentsRepository _appointmentsRepository;

  GetRemotePendingAppointmentsUseCase(this._appointmentsRepository);

  Stream<DataState<List<Appointment>>> call({void params}) {
    return _appointmentsRepository.getPendingPatientAppointments();
  }
}