import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'optometrySpecialization')
enum OptometrySpecialization {
  @JsonValue(0)
  visualExam,
  @JsonValue(1)
  lensAdjustment,
  @JsonValue(2)
  frameFitting,
}

final Map<OptometrySpecialization, String> optometrySpecializationToString = {
  OptometrySpecialization.visualExam: 'Examen Visual',
  OptometrySpecialization.lensAdjustment: 'Ajuste de Lentes',
  OptometrySpecialization.frameFitting: 'Montura',
};

final Map<String, OptometrySpecialization> stringToOptometrySpecialization = {
  'Examen Visual': OptometrySpecialization.visualExam,
  'Ajuste de Lentes': OptometrySpecialization.lensAdjustment,
  'Montura': OptometrySpecialization.frameFitting,
};
