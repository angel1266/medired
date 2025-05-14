import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'dentistrySpecialization')
enum DentistrySpecialization {
  @JsonValue(0)
  generalConsultation,
  @JsonValue(1)
  dentalCleaning,
  @JsonValue(2)
  whitening,
  @JsonValue(3)
  orthodontics,
}

final Map<DentistrySpecialization, String> dentistrySpecializationToString = {
  DentistrySpecialization.generalConsultation: 'Consulta General',
  DentistrySpecialization.dentalCleaning: 'Limpieza Dental',
  DentistrySpecialization.whitening: 'Blanqueamiento',
  DentistrySpecialization.orthodontics: 'Ortodoncia',
};

final Map<String, DentistrySpecialization> stringToDentistrySpecialization = {
  'Consulta General': DentistrySpecialization.generalConsultation,
  'Limpieza Dental': DentistrySpecialization.dentalCleaning,
  'Blanqueamiento': DentistrySpecialization.whitening,
  'Ortodoncia': DentistrySpecialization.orthodontics,
};
