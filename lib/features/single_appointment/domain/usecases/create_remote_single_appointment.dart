import 'package:fpdart/fpdart.dart';
import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/single_appointment/domain/entities/appointment.dart';
import 'package:medired/features/single_appointment/domain/repository/single_appointment_repository.dart';

class CreateRemoteSingleAppointmentUseCase {
  final SingleAppointmentRepository _appointmentRepository;
  CreateRemoteSingleAppointmentUseCase(this._appointmentRepository);
  Future<DataState<Unit>> call<T extends Appointment>(
      {required T appointment}) async {
    return await _appointmentRepository.createAppointment(appointment);
  }
}
