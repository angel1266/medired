import 'package:medired/features/authentication/domain/entities/patient.dart';
import 'package:medired/features/authentication/domain/entities/service_provider.dart';
import 'package:medired/features/single_appointment/domain/entities/appointed_patient.dart';
import 'package:medired/features/single_appointment/domain/entities/appointed_service_provider.dart';

extension ProviderConverter on ServiceProvider {
  AppointedServiceProvider toAppointedServiceProvider() =>
      AppointedServiceProvider(
        uid: authInfo.uid!,
        firstName: companyInfo.name,
        lastName: personalInfo.lastName,
      );
}

extension PatientConverter on Patient {
  AppointedPatient toAppointedPatient() => AppointedPatient(
        uid: authInfo.uid!,
        firstName: personalInfo.firstName,
        lastName: personalInfo.lastName,
      );
}
