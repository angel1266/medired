import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'medicalTestType')
enum MedicalTestType {
  @JsonValue(0)
  imaging,
  @JsonValue(1)
  bloodTest,
  @JsonValue(2)
  urineTest,
  @JsonValue(3)
  stoolTest,
  @JsonValue(4)
  cardiovascular,
  @JsonValue(5)
  endoscopic,
  @JsonValue(6)
  biopsy,
  @JsonValue(7)
  pulmonaryFunction,
  @JsonValue(8)
  genetic,
  @JsonValue(9)
  immunological,
  @JsonValue(10)
  hormone,
  @JsonValue(11)
  tumorMarkers,
  @JsonValue(12)
  skin,
  @JsonValue(13)
  ophthalmic,
  @JsonValue(14)
  audiology,
}

// Mapa de String a MedicalTestType
final Map<String, MedicalTestType> stringToMedicalTestType = {
  'Imágenes': MedicalTestType.imaging,
  'Análisis de Sangre': MedicalTestType.bloodTest,
  'Análisis de Orina': MedicalTestType.urineTest,
  'Análisis de Heces': MedicalTestType.stoolTest,
  'Cardiovascular': MedicalTestType.cardiovascular,
  'Endoscopia': MedicalTestType.endoscopic,
  'Biopsia': MedicalTestType.biopsy,
  'Función Pulmonar': MedicalTestType.pulmonaryFunction,
  'Genética': MedicalTestType.genetic,
  'Inmunológico': MedicalTestType.immunological,
  'Hormonal': MedicalTestType.hormone,
  'Marcadores Tumorales': MedicalTestType.tumorMarkers,
  'Piel': MedicalTestType.skin,
  'Oftalmología': MedicalTestType.ophthalmic,
  'Audiometría': MedicalTestType.audiology,
};

// Mapa de MedicalTestType a String
final Map<MedicalTestType, String> medicalTestTypeToString = {
  MedicalTestType.imaging: 'Imágenes',
  MedicalTestType.bloodTest: 'Análisis de Sangre',
  MedicalTestType.urineTest: 'Análisis de Orina',
  MedicalTestType.stoolTest: 'Análisis de Heces',
  MedicalTestType.cardiovascular: 'Cardiovascular',
  MedicalTestType.endoscopic: 'Endoscopia',
  MedicalTestType.biopsy: 'Biopsia',
  MedicalTestType.pulmonaryFunction: 'Función Pulmonar',
  MedicalTestType.genetic: 'Genética',
  MedicalTestType.immunological: 'Inmunológico',
  MedicalTestType.hormone: 'Hormonal',
  MedicalTestType.tumorMarkers: 'Marcadores Tumorales',
  MedicalTestType.skin: 'Piel',
  MedicalTestType.ophthalmic: 'Oftalmología',
  MedicalTestType.audiology: 'Audiometría',
};
