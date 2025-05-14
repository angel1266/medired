import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/appointments/domain/repository/appointments_repository.dart';
import 'package:medired/features/single_appointment/domain/entities/appointment.dart';

class GetRemoteServiceProviderAppointmentsUseCase {
  final AppointmentsRepository _appointmentsRepository;

  GetRemoteServiceProviderAppointmentsUseCase(this._appointmentsRepository);

  Stream<DataState<List<Appointment>>> call({required String uid}) {
    return _appointmentsRepository.getUpcomingServiceProviderAppointments(uid);
  }
}
