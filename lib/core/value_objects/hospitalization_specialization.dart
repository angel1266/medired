import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'hospitalizationSpecialization')
enum HospitalizationSpecialization {
  @JsonValue(0)
  hospitalBed,
  @JsonValue(1)
  intensiveCare,
}

final Map<HospitalizationSpecialization, String>
    hospitalizationSpecializationToString = {
  HospitalizationSpecialization.hospitalBed: 'Cama',
  HospitalizationSpecialization.intensiveCare: 'Cuidados Intensivos',
};

final Map<String, HospitalizationSpecialization>
    stringToHospitalizationSpecialization = {
  'Cama': HospitalizationSpecialization.hospitalBed,
  'Cuidados Intensivos': HospitalizationSpecialization.intensiveCare,
};
