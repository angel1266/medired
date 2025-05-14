import 'dart:async';

import 'package:medired/core/core_export.dart';
import 'package:medired/features/appointments/domain/usecases/appointments_usecases.dart';
import 'package:medired/features/appointments/domain/usecases/get_remote_pending_appointments.dart';
import 'package:medired/features/single_appointment/domain/entities/appointment.dart';
import 'package:medired/features/single_appointment/domain/usecases/single_appointment_usecases.dart';

part 'appointments_event.dart';
part 'appointments_state.dart';

class AppointmentsBloc extends Bloc<AppointmentsEvent, AppointmentsState> {
  final GetRemotePatientAppointmentsUseCase
      _getRemoteUpcomingUserAppointmentsUseCase;
  final GetRemoteServiceProviderAppointmentsUseCase
      _getRemoteServiceProviderAppointmentsUseCase;
  final GetRemotePendingAppointmentsUseCase
      _getRemotePendingAppointmentsUseCase;
  final UpdateRemoteAppointmentStatusUseCase
      _updateRemoteAppointmentStatusUseCase;
  StreamSubscription? appointmentsSubscription;
  AppointmentsBloc(
    this._updateRemoteAppointmentStatusUseCase,
    this._getRemoteUpcomingUserAppointmentsUseCase,
    this._getRemoteServiceProviderAppointmentsUseCase,
    this._getRemotePendingAppointmentsUseCase,
  ) : super(UnloadedAppointments()) {
    on<GetUpcomingPatientAppointments>(getUpcomingPatientAppointments);
    on<GetUpcomingServiceProviderAppointments>(
        getUpcomingServiceProviderAppointments);
    on<UpdateAppointmentStatus>(updateAppointmentStatus);
    on<GetPendingAppointments>(getPendingAppointments);
    on<RemoveAppointment>(_onRemoveAppointment);
  }

  void _onRemoveAppointment(
      RemoveAppointment event, Emitter<AppointmentsState> emit) {
    if (state is SuccessUpcomingAppointments) {
      final currentAppointments =
          (state as SuccessUpcomingAppointments).appointments;
      final updatedAppointments = currentAppointments
          .where((appointment) => appointment.id != event.appointmentId)
          .toList();
      emit(SuccessUpcomingAppointments(appointments: updatedAppointments));
    }
  }

  Future<void> getUpcomingPatientAppointments(
    GetUpcomingPatientAppointments event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(LoadingUpcomingAppointments());
    appointmentsSubscription = await _getRemoteUpcomingUserAppointmentsUseCase
        .call(uid: event.uid)
        .listen((event) async => await event.fold(
            (l) => emit(ErrorUpcomingAppointments(l)),
            (r) => emit(SuccessUpcomingAppointments(appointments: r))))
        .asFuture();
  }

  Future<void> getUpcomingServiceProviderAppointments(
    GetUpcomingServiceProviderAppointments event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(LoadingUpcomingAppointments());
    appointmentsSubscription =
        await _getRemoteServiceProviderAppointmentsUseCase
            .call(uid: event.uid)
            .listen((event) async => await event.fold(
                (l) => emit(ErrorUpcomingAppointments(l)),
                (r) => emit(SuccessUpcomingAppointments(appointments: r))))
            .asFuture();
  }

  Future<void> getPendingAppointments(
    GetPendingAppointments event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(LoadingPendingAppointments());
    appointmentsSubscription = await _getRemotePendingAppointmentsUseCase
        .call()
        .listen(
          (event) async => await event.fold(
            (l) => emit(ErrorPendingAppointments(l)),
            (r) => emit(SuccessPendingAppointments(appointments: r)),
          ),
        )
        .asFuture();
  }

  Future<void> updateAppointmentStatus(
    UpdateAppointmentStatus event,
    Emitter<AppointmentsState> emit,
  ) async {
    // emit(LoadingAppointmentsState());
    var result = await _updateRemoteAppointmentStatusUseCase.call(
      id: event.id,
      status: event.status,
    );

    result.fold(
      (l) => null,
      (r) => null,
      // (r) => emit(
      //       const SuccessAppointmentState(
      //         message: 'Se ha actualizado el estatus de la cita',
      //       ),)
    );
  }

  @override
  Future<void> close() {
    appointmentsSubscription?.cancel();
    return super.close();
  }
}

class RemoveAppointment extends AppointmentsEvent {
  final String appointmentId;

  const RemoveAppointment({required this.appointmentId});

  @override
  List<Object> get props => [appointmentId];
}
