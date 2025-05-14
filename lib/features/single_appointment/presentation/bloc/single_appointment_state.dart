
part of 'single_appointment_bloc.dart';

sealed class SingleAppointmentState extends Equatable with Mappable {
  const SingleAppointmentState();

  @override
  List<Object?> get props => [];

  @override
  Map<String, dynamic> toMap() => {};
}

final class UnloadedSingleAppointment extends SingleAppointmentState {
  const UnloadedSingleAppointment();
}

/*
--- 🌟⏳ Loading ⏳🌟 ---
*/

final class LoadingSingleAppointmentState extends SingleAppointmentState {
  const LoadingSingleAppointmentState();
}

final class LoadingAddAppointment extends LoadingSingleAppointmentState {
  const LoadingAddAppointment();
}

final class LoadingGetSpecializations extends LoadingSingleAppointmentState {
  const LoadingGetSpecializations();
}

final class LoadingGetTests extends LoadingSingleAppointmentState {
  const LoadingGetTests();
}

final class LoadingGetServiceProviders extends LoadingSingleAppointmentState {
  const LoadingGetServiceProviders();
}

final class LoadingGetTestProviders extends LoadingGetServiceProviders {
  const LoadingGetTestProviders();
}

final class LoadingGetSpecializationProviders
    extends LoadingGetServiceProviders {
  const LoadingGetSpecializationProviders();
}

/*
--- 🌟✅ Loaded ✅🌟 ---
*/

final class SuccessSingleAppointment extends SingleAppointmentState {
  const SuccessSingleAppointment();
}

final class SuccessAddAppointment extends SuccessSingleAppointment {
  final String message;

  const SuccessAddAppointment({required this.message});

  @override
  Map<String, dynamic> toMap() => {
        'message': message,
      };
}

///
final class SuccessUpdateServiceType extends SuccessSingleAppointment {
  final ServiceType? serviceType;
  const SuccessUpdateServiceType({required this.serviceType});

  @override
  List<Object?> get props => [serviceType];

  @override
  Map<String, dynamic> toMap() => {
        'serviceType': serviceType,
      };
}

final class SuccessUpdateConsultationType extends SuccessUpdateServiceType {
  const SuccessUpdateConsultationType(
      {super.serviceType = ServiceType.medicalConsultation});
}

final class SuccessUpdateTestType extends SuccessUpdateServiceType {
  const SuccessUpdateTestType({super.serviceType = ServiceType.test});
}

final class SuccessGetSpecializations extends SuccessSingleAppointment {
  final List<MedicalSpecialization> specializations;

  Map<MedicalSpecialization, String> get specializationOptions =>
      medicalSpecializationToString;

  const SuccessGetSpecializations({required this.specializations});

  @override
  List<Object> get props => [specializations];

  @override
  Map<String, dynamic> toMap() => {
        'specializations': specializations.map((e) => e.name).toList(),
      };
}

final class SuccessGetTests extends SuccessSingleAppointment {
  final List<MedicalTest> tests;

  Map<MedicalTest, String> get testOptions => {
        for (var e in tests) e: e.name,
      };
  const SuccessGetTests({required this.tests});

  @override
  List<Object> get props => [tests];

  @override
  Map<String, dynamic> toMap() => {
        'tests':
            tests.map((e) => MedicalTestModel.fromEntity(e).toJson()).toList(),
      };
}

final class SuccessUpdateSpecializationOption
    extends SuccessGetSpecializations {
  final MedicalSpecialization specialization;
  const SuccessUpdateSpecializationOption(
      {required super.specializations, required this.specialization});
}

final class SuccessUpdateMedicalTestOption extends SuccessGetTests {
  final MedicalTest medicalTest;
  const SuccessUpdateMedicalTestOption(
      {required super.tests, required this.medicalTest});
}

final class SuccessUpdateImageTestOption
    extends SuccessUpdateMedicalTestOption {
  const SuccessUpdateImageTestOption({
    required super.tests,
    required super.medicalTest,
  });
}

final class SuccessGetServiceProviders extends SuccessSingleAppointment {
  final List<ServiceProvider> serviceProviders;
  final ServiceType serviceType;

  Map<ServiceProvider, String> get serviceProviderOptions => {
        for (var e in serviceProviders)
          e: '${e.personalInfo.firstName} ${e.companyInfo.name}',
      };
  const SuccessGetServiceProviders(
      {required this.serviceProviders, required this.serviceType});
}

final class SuccessGetTestProviders extends SuccessGetServiceProviders {
  final MedicalTest medicalTest;
  const SuccessGetTestProviders(
      {required super.serviceProviders,
      required this.medicalTest,
      super.serviceType = ServiceType.test});
}

final class SuccessGetSpecializationProviders
    extends SuccessGetServiceProviders {
  final MedicalSpecialization medicalSpecialization;
  const SuccessGetSpecializationProviders(
      {required super.serviceProviders,
      required this.medicalSpecialization,
      super.serviceType = ServiceType.medicalConsultation});
}

final class SuccessUpdateServiceProvider extends SuccessGetServiceProviders {
  final ServiceProvider serviceProvider;

  const SuccessUpdateServiceProvider({
    required super.serviceProviders,
    required this.serviceProvider,
    required super.serviceType,
  });
}

final class SuccessUpdateSpecializationProvider
    extends SuccessUpdateServiceProvider {
  final MedicalSpecialization medicalSpecialization;
  const SuccessUpdateSpecializationProvider({
    required super.serviceProvider,
    required this.medicalSpecialization,
    required super.serviceProviders,
    required super.serviceType,
  });
}

final class SuccessUpdateTestProvider extends SuccessUpdateServiceProvider {
  final MedicalTest medicalTest;
  const SuccessUpdateTestProvider({
    required super.serviceProvider,
    required this.medicalTest,
    required super.serviceProviders,
    required super.serviceType,
  });
}

final class SuccessAddConsultationAppointment extends SuccessSingleAppointment {
  final String message;
  const SuccessAddConsultationAppointment({required this.message});
}

final class SuccessAddTestAppointment extends SuccessSingleAppointment {
  final String message;
  const SuccessAddTestAppointment({required this.message});
}

/*
--- 🌟🚨 Error 🚨🌟 ---
*/

final class ErrorSingleAppointment extends SingleAppointmentState {
  final String message;

  const ErrorSingleAppointment(this.message);

  String get genericError => 'Error single appointment';

  @override
  List<Object?> get props => [message];

  @override
  Map<String, dynamic> toMap() => {
        'message': message,
      };
}

final class ErrorAddAppointment extends ErrorSingleAppointment {
  const ErrorAddAppointment(super.message);

  @override
  String get genericError => 'Error add appointment';
}

final class ErrorGetSpecializations extends ErrorSingleAppointment {
  const ErrorGetSpecializations(super.message);

  @override
  String get genericError => 'Error get specializations';
}

final class ErrorGetTests extends ErrorSingleAppointment {
  const ErrorGetTests(super.message);

  @override
  String get genericError => 'Error get tests';
}

final class ErrorUpdateSpecializationOption extends ErrorGetSpecializations {
  const ErrorUpdateSpecializationOption(super.message);

  @override
  String get genericError => 'Error update specialization option';
}

final class ErrorUpdateMedicalTestOption extends ErrorGetTests {
  const ErrorUpdateMedicalTestOption(super.message);

  @override
  String get genericError => 'Error update medical test option';
}

final class ErrorGetServiceProviders extends ErrorSingleAppointment {
  const ErrorGetServiceProviders(super.message);

  @override
  String get genericError => 'Error get service providers';
}

final class ErrorGetTestProviders extends ErrorGetServiceProviders {
  const ErrorGetTestProviders(super.message);

  @override
  String get genericError => 'Error get test providers';
}

final class ErrorGetSpecializationProviders extends ErrorGetServiceProviders {
  const ErrorGetSpecializationProviders(super.message);

  @override
  String get genericError => 'Error get specialization providers';
}

final class ErrorUpdateServiceProvider extends ErrorSingleAppointment {
  const ErrorUpdateServiceProvider(super.message);

  @override
  String get genericError => 'Error update service provider';
}

final class ErrorUpdateSpecializationProvider
    extends ErrorUpdateServiceProvider {
  const ErrorUpdateSpecializationProvider(super.message);

  @override
  String get genericError => 'Error update specialization provider';
}

final class ErrorUpdateTestProvider extends ErrorUpdateServiceProvider {
  const ErrorUpdateTestProvider(super.message);

  @override
  String get genericError => 'Error update test provider';
}

final class ErrorAddConsultationAppointment extends ErrorSingleAppointment {
  const ErrorAddConsultationAppointment(super.message);

  @override
  String get genericError => 'Error add consultation appointment';
}

final class ErrorAddTestAppointment extends ErrorSingleAppointment {
  const ErrorAddTestAppointment(super.message);

  @override
  String get genericError => 'Error add test appointment';
}
