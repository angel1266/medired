import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'sex')
enum Sex {
  @JsonValue(0)
  masculine,
  @JsonValue(1)
  femenine,
}

final Map<String, Sex> stringToSex = {
  'Masculino': Sex.masculine,
  'Femenino': Sex.femenine,
};

final Map<Sex, String> sexToString = {
  Sex.masculine: 'Masculino',
  Sex.femenine: 'Femenino',
};
