import 'package:flutter_bloc_devtools/flutter_bloc_devtools.dart';
import 'package:medired/core/core_export.dart';
import 'package:medired/core/value_objects/medical_specialization.dart';
import 'package:medired/core/value_objects/service_type.dart';
import 'package:medired/features/appointments/data/models/medical_test_model.dart';
import 'package:medired/features/appointments/domain/entities/medical_test.dart';
import 'package:medired/features/appointments/domain/usecases/get_remote_medical_tests.dart';
import 'package:medired/features/authentication/domain/entities/authentication_entities.dart';
import 'package:medired/features/single_appointment/data/models/appointment_info_model.dart';
import 'package:medired/features/single_appointment/domain/entities/appointment_info.dart';
import 'package:medired/features/single_appointment/domain/entities/consultation_appointment.dart';
import 'package:medired/features/single_appointment/domain/entities/test_appointment.dart';
import 'package:medired/features/single_appointment/domain/usecases/single_appointment_usecases.dart';

part 'single_appointment_event.dart';
part 'single_appointment_state.dart';

class SingleAppointmentBloc
    extends Bloc<AppointmentEvent, SingleAppointmentState> {
  final CreateRemoteSingleAppointmentUseCase _createRemoteSingleAppointment;
  final GetRemoteServiceProvidersUseCase _getRemoteServiceProviders;
  final GetRemoteMedicalTestsUseCase _getRemoteMedicalTests;

  SingleAppointmentBloc(
    this._createRemoteSingleAppointment,
    this._getRemoteServiceProviders,
    this._getRemoteMedicalTests,
  ) : super(const UnloadedSingleAppointment()) {
    on<UpdateServiceType>(_updateServiceType);
    on<GetSpecializations>(_getSpecializations);
    on<GetTests>(_getTests);
    on<UpdateTestOption>(_updateTestOption);
    on<UpdateSpecializationOption>(_updateSpecializationOption);
    on<GetTestProviders>(_getTestProviders);
    on<GetSpecializationProviders>(_getSpecializationProviders);
    on<UpdateSpecializationProvider>(_updateSpecializationProvider);
    on<UpdateTestProvider>(_updateTestProvider);
    on<AddConsultationAppointment>(_addConsultationAppointment);
    on<AddTestAppointment>(_addTestAppointment);
  }

  Future<void> _updateServiceType(
    UpdateServiceType event,
    Emitter<SingleAppointmentState> emit,
  ) async {
    if (event.serviceType != null) {
      if (event.serviceType == ServiceType.medicalConsultation) {
        emit(const SuccessUpdateConsultationType());
      } else if (event.serviceType == ServiceType.test) {
        emit(const SuccessUpdateTestType());
      }
    } else {
      emit(SuccessUpdateServiceType(serviceType: event.serviceType));
    }
  }

  Future<void> _getSpecializations(
    GetSpecializations event,
    Emitter<SingleAppointmentState> emit,
  ) async {
    emit(const LoadingGetSpecializations());
    emit(SuccessGetSpecializations(
        specializations: medicalSpecializationToString.keys.toList()));
  }

  Future<void> _getTests(
    GetTests event,
    Emitter<SingleAppointmentState> emit,
  ) async {
    emit(const LoadingGetTests());
    var result = await _getRemoteMedicalTests.call();
    result.fold(
      (l) => emit(ErrorGetTests(l)),
      (r) => emit(SuccessGetTests(tests: r)),
    );
  }

  Future<void> _updateTestOption(
    UpdateTestOption event,
    Emitter<SingleAppointmentState> emit,
  ) async {
    var test = event.test;
    if (test != null) {
      if (test.name == 'Rayos X' ||
          test.name == 'Sonografía' ||
          test.name == 'Eco cardíaco') {
        emit(SuccessUpdateImageTestOption(
          medicalTest: test,
          tests: event.tests,
        ));
      } else {
        emit(SuccessUpdateMedicalTestOption(
          medicalTest: test,
          tests: event.tests,
        ));
      }
    }
  }

  Future<void> _updateSpecializationOption(
    UpdateSpecializationOption event,
    Emitter<SingleAppointmentState> emit,
  ) async {
    var specialization = event.specialization;
    if (specialization != null) {
      emit(SuccessUpdateSpecializationOption(
        specialization: specialization,
        specializations: event.specializations,
      ));
    } else {
      emit(const ErrorUpdateSpecializationOption(
          'Error update specialization option'));
    }
  }

  Future<void> _getTestProviders(
    GetTestProviders event,
    Emitter<SingleAppointmentState> emit,
  ) async {
    emit(const LoadingGetTestProviders());
    var result = await _getRemoteServiceProviders.call();
    result.fold(
      (l) => emit(ErrorGetTestProviders(l)),
      (r) => emit(SuccessGetTestProviders(
          medicalTest: event.test,
          serviceProviders: r
              .where((e) =>
                  e.isTestProvider && e.medicalTests.contains(event.test))
              .toList())),
    );
  }

  Future<void> _getSpecializationProviders(
    GetSpecializationProviders event,
    Emitter<SingleAppointmentState> emit,
  ) async {
    emit(const LoadingGetSpecializationProviders());
    var result = await _getRemoteServiceProviders.call();
    result.fold(
      (l) => emit(ErrorGetSpecializationProviders(l)),
      (r) => emit(SuccessGetSpecializationProviders(
          medicalSpecialization: event.specialization,
          serviceProviders: r
              .where((e) =>
                  e.isSpecializationProvider &&
                  e.medicalSpecializations.contains(event.specialization))
              .toList())),
    );
  }

  Future<void> _updateServiceProvider(
    UpdateServiceProvider event,
    Emitter<SingleAppointmentState> emit,
  ) async {
    var serviceProvider = event.serviceProvider;
    if (serviceProvider != null) {
      emit(SuccessUpdateServiceProvider(
        serviceProvider: serviceProvider,
        serviceProviders: event.serviceProviders,
        serviceType: event.serviceType,
      ));
    } else {
      emit(const ErrorUpdateServiceProvider('Error update service provider'));
    }
  }

  Future<void> _updateSpecializationProvider(
    UpdateSpecializationProvider event,
    Emitter<SingleAppointmentState> emit,
  ) async {
    var serviceProvider = event.serviceProvider;
    var specialization = event.medicalSpecialization;
    if (serviceProvider != null && specialization != null) {
      emit(SuccessUpdateSpecializationProvider(
        medicalSpecialization: specialization,
        serviceProvider: serviceProvider,
        serviceProviders: event.serviceProviders,
        serviceType: event.serviceType,
      ));
    } else {
      emit(const ErrorUpdateSpecializationProvider(
          'Error update specialization provider'));
    }
  }

  Future<void> _updateTestProvider(
    UpdateTestProvider event,
    Emitter<SingleAppointmentState> emit,
  ) async {
    var serviceProvider = event.serviceProvider;
    var test = event.medicalTest;
    if (serviceProvider != null && test != null) {
      emit(SuccessUpdateTestProvider(
        medicalTest: test,
        serviceProvider: serviceProvider,
        serviceProviders: event.serviceProviders,
        serviceType: event.serviceType,
      ));
    } else {
      emit(const ErrorUpdateTestProvider('Error update test provider'));
    }
  }

  Future<void> _addConsultationAppointment(
    AddConsultationAppointment event,
    Emitter<SingleAppointmentState> emit,
  ) async {
    var specialization = event.medicalSpecialization;
    if (specialization != null) {
      DataState<Unit> result =
          await _createRemoteSingleAppointment.call<ConsultationAppointment>(
              appointment: ConsultationAppointment(
                  medicalSpecialization: specialization,
                  id: '',
                  appointmentInfo: event.appointmentInfo));

      return await result.fold(
        (l) => emit(ErrorAddAppointment(l)),
        (r) => emit(const SuccessAddConsultationAppointment(
            message: 'Se ha agregado una cita exitosamente')),
      );
    } else {
      emit(const ErrorAddConsultationAppointment(
          'Error add consultation appointment'));
    }
  }

  Future<void> _addTestAppointment(
    AddTestAppointment event,
    Emitter<SingleAppointmentState> emit,
  ) async {
    var test = event.medicalTest;
    if (test != null) {
      DataState<Unit> result =
          await _createRemoteSingleAppointment.call<TestAppointment>(
              appointment: TestAppointment(
                  medicalTest: test,
                  id: '',
                  appointmentInfo: event.appointmentInfo));

      return await result.fold(
        (l) => emit(ErrorAddTestAppointment(l)),
        (r) => emit(const SuccessAddTestAppointment(
            message: 'Se ha agregado una cita exitosamente')),
      );
    } else {
      emit(const ErrorAddAppointment('Error add test appointment'));
    }
  }
}
