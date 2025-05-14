part of 'single_appointment_bloc.dart';

sealed class AppointmentEvent extends Equatable implements Mappable {
  const AppointmentEvent();

  @override
  List<Object> get props => [];

  @override
  Map<String, dynamic> toMap() => {};
}

final class UpdateServiceType extends AppointmentEvent {
  final ServiceType? serviceType;

  const UpdateServiceType({
    required this.serviceType,
  });

  @override
  Map<String, dynamic> toMap() => {
        'serviceType': serviceType,
      };
}

final class GetSpecializations extends AppointmentEvent {
  const GetSpecializations();
}

final class GetTests extends AppointmentEvent {
  const GetTests();
}

final class UpdateSpecializationOption extends AppointmentEvent {
  final List<MedicalSpecialization> specializations;
  final MedicalSpecialization? specialization;

  const UpdateSpecializationOption(
    this.specializations, {
    required this.specialization,
  });
}

final class UpdateTestOption extends AppointmentEvent {
  final List<MedicalTest> tests;
  final MedicalTest? test;

  const UpdateTestOption(
    this.tests, {
    required this.test,
  });
}

final class GetServiceProviders extends AppointmentEvent {
  final ServiceType serviceType;
  const GetServiceProviders({required this.serviceType});
}

final class GetTestProviders extends GetServiceProviders {
  final MedicalTest test;
  const GetTestProviders(
      {super.serviceType = ServiceType.test, required this.test});
}

final class GetSpecializationProviders extends GetServiceProviders {
  final MedicalSpecialization specialization;
  const GetSpecializationProviders(
      {super.serviceType = ServiceType.medicalConsultation,
      required this.specialization});
}

final class UpdateServiceProvider extends AppointmentEvent {
  final ServiceProvider? serviceProvider;
  final List<ServiceProvider> serviceProviders;
  final ServiceType serviceType;

  const UpdateServiceProvider(
    this.serviceProviders, {
    required this.serviceProvider,
    required this.serviceType,
  });
}

final class UpdateSpecializationProvider extends UpdateServiceProvider {
  final MedicalSpecialization? medicalSpecialization;
  const UpdateSpecializationProvider(super.serviceProviders,
      {required super.serviceProvider,
      required super.serviceType,
      required this.medicalSpecialization});
}

final class UpdateTestProvider extends UpdateServiceProvider {
  final MedicalTest? medicalTest;
  const UpdateTestProvider(super.serviceProviders,
      {required super.serviceProvider,
      required super.serviceType,
      required this.medicalTest});
}

sealed class AddAppointment extends AppointmentEvent {
  final AppointmentInfo appointmentInfo;

  const AddAppointment({
    required this.appointmentInfo,
  });

  @override
  Map<String, dynamic> toMap() => {
        'appointment':
            AppointmentInfoModel.fromEntity(appointmentInfo).toJson(),
      };
}

final class AddConsultationAppointment extends AddAppointment {
  final dynamic? medicalSpecialization;
  const AddConsultationAppointment({
    required super.appointmentInfo,
    required this.medicalSpecialization,
  });
}

final class AddTestAppointment extends AddAppointment {
  final MedicalTest? medicalTest;
  const AddTestAppointment({
    required super.appointmentInfo,
    required this.medicalTest,
  });
}
