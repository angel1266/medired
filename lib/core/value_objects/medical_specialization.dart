import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'medicalSpecialization')
enum MedicalSpecialization {
  @JsonValue(0)
  gynecology,
  @JsonValue(1)
  internalMedicine,
  @JsonValue(2)
  pediatrics,
  @JsonValue(3)
  generalMedicine,
  @JsonValue(4)
  urology,
  @JsonValue(5)
  ophthalmology,
  @JsonValue(6)
  dentistry,
  @JsonValue(7)
  audiology,
}

final Map<MedicalSpecialization, String> medicalSpecializationToString = {
  MedicalSpecialization.gynecology: 'Ginecología',
  MedicalSpecialization.internalMedicine: 'Medicina Interna',
  MedicalSpecialization.pediatrics: 'Pediatría',
  MedicalSpecialization.generalMedicine: 'Medicina General',
  MedicalSpecialization.urology: 'Urología',
  MedicalSpecialization.ophthalmology: 'Oftalmología',
  MedicalSpecialization.dentistry: 'Odontología',
  MedicalSpecialization.audiology: 'Audiometría',
};

final Map<String, MedicalSpecialization> stringToMedicalSpecialization = {
  'Ginecología': MedicalSpecialization.gynecology,
  'Medicina Interna': MedicalSpecialization.internalMedicine,
  'Pediatría': MedicalSpecialization.pediatrics,
  'Medicina General': MedicalSpecialization.generalMedicine,
  'Urología': MedicalSpecialization.urology,
  'Oftalmología': MedicalSpecialization.ophthalmology,
  'Odontología': MedicalSpecialization.dentistry,
  'Audiometría': MedicalSpecialization.audiology,
};
