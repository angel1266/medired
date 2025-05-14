import 'package:medired/core/core_export.dart';
import 'package:medired/core/value_objects/service_type.dart';
import 'package:medired/features/single_appointment/domain/entities/appointed_patient.dart';
import 'package:medired/features/single_appointment/domain/entities/appointed_service_provider.dart';

class AppointmentInfo extends Equatable {
  final AppointedPatient patient;
  final AppointedServiceProvider serviceProvider;
  final DateTime date;
  final String description;
  final AppointmentStatus status;
  final dynamic serviceType;

  const AppointmentInfo({
    required this.patient,
    required this.serviceProvider,
    required this.date,
    required this.description,
    required this.status,
    required this.serviceType,
  });

  AppointmentInfo copyWith(
          {String? id,
          AppointedPatient? patient,
          AppointedServiceProvider? serviceProvider,
          DateTime? date,
          String? description,
          AppointmentStatus? status,
          ServiceType? serviceType}) =>
      AppointmentInfo(
          patient: patient ?? this.patient,
          serviceProvider: serviceProvider ?? this.serviceProvider,
          date: date ?? this.date,
          description: description ?? this.description,
          status: status ?? this.status,
          serviceType: serviceType ?? this.serviceType);

  @override
  List<Object?> get props => [
        patient,
        serviceProvider,
        date,
        description,
        status,
        serviceType,
      ];
}
