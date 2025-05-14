import 'package:medired/core/core_export.dart';
import 'package:medired/features/single_appointment/domain/repository/single_appointment_repository.dart';

class UpdateRemoteAppointmentStatusUseCase {
  final SingleAppointmentRepository _appointmentRepository;
  UpdateRemoteAppointmentStatusUseCase(this._appointmentRepository);
  Future<DataState<Unit>> call({required String id, required AppointmentStatus status}) async {
    return await _appointmentRepository.updateAppointmentStatus(id, status);
  }
}