part of 'appointments_bloc.dart';

@immutable
sealed class AppointmentsState extends Equatable {
  const AppointmentsState();

  @override
  List<Object> get props => [];
}

final class UnloadedAppointments extends AppointmentsState {}

/*
--- 🌟⏳ Loading ⏳🌟 ---
*/

final class LoadingAppointments extends AppointmentsState {}

final class LoadingUpcomingAppointments extends LoadingAppointments {}

final class LoadingPendingAppointments extends LoadingAppointments {}

/*
--- 🌟✅ Success ✅🌟 ---
*/

final class SuccessAppointments extends AppointmentsState {
  const SuccessAppointments();
}

final class SuccessUpcomingAppointments extends SuccessAppointments {
  final List<Appointment> _appointments;

  SuccessUpcomingAppointments({required List<Appointment> appointments})
      : _appointments = appointments
          ..sort((a, b) =>
              b.appointmentInfo.date.compareTo(a.appointmentInfo.date));

  List<Appointment> get appointments => _appointments;

  @override
  List<Object> get props => [_appointments];
}

final class SuccessPendingAppointments extends SuccessAppointments {
  final List<Appointment> appointments;

  const SuccessPendingAppointments({required this.appointments});

  @override
  List<Object> get props => [appointments];
}

/*
--- 🌟🚨 Error 🚨🌟 ---
*/

final class ErrorAppointmentState extends AppointmentsState {
  final String error;

  const ErrorAppointmentState(this.error);

  String get genericMesage => 'Error in appointments';

  @override
  List<Object> get props => [error];
}

final class ErrorUpcomingAppointments extends ErrorAppointmentState {
  const ErrorUpcomingAppointments(super.error);

  @override
  String get genericMesage => 'Error in upcoming appointments';
}

final class ErrorPendingAppointments extends ErrorAppointmentState {
  const ErrorPendingAppointments(super.error);

  @override
  String get genericMesage => 'Error in pending appointments';
}
