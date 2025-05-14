import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'imagingSpecialization')
enum ImagingSpecialization {
  @JsonValue(0)
  xRay,
  @JsonValue(1)
  ultrasound,
  @JsonValue(2)
  mri,
  @JsonValue(3)
  echocardiogram,
}

final Map<ImagingSpecialization, String> imagingSpecializationToString = {
  ImagingSpecialization.xRay: 'Rayos X',
  ImagingSpecialization.ultrasound: 'Sonografía',
  ImagingSpecialization.mri: 'Resonancia',
  ImagingSpecialization.echocardiogram: 'Ecocardiograma',
};

final Map<String, ImagingSpecialization> stringToImagingSpecialization = {
  'Rayos X': ImagingSpecialization.xRay,
  'Sonografía': ImagingSpecialization.ultrasound,
  'Resonancia': ImagingSpecialization.mri,
  'Ecocardiograma': ImagingSpecialization.echocardiogram,
};
