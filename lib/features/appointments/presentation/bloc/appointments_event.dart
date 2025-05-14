part of 'appointments_bloc.dart';

sealed class AppointmentsEvent extends Equatable {
  const AppointmentsEvent();

  @override
  List<Object> get props => [];
}

// class Initialize extends AppointmentsEvent {}

class GetUpcomingPatientAppointments extends AppointmentsEvent {
  final String uid;
  const GetUpcomingPatientAppointments({required this.uid});
}

class GetUpcomingServiceProviderAppointments extends AppointmentsEvent {
  final String uid;
  const GetUpcomingServiceProviderAppointments({required this.uid});
}

class GetPendingAppointments extends AppointmentsEvent {
  const GetPendingAppointments();
}

final class UpdateAppointmentStatus extends AppointmentsEvent {
  final String id;
  final AppointmentStatus status;

  const UpdateAppointmentStatus({
    required this.id,
    required this.status,
  });
}
