import 'package:json_annotation/json_annotation.dart';

enum UserType {
  @JsonValue(0)
  patient,
  @JsonValue(1)
  ars,
  @JsonValue(2)
  provider,
  @JsonValue(3)
  broker,
}

final Map<String, UserType> stringToUserType = {
  'Paciente': UserType.patient,
  'ARS': UserType.ars,
  'Prestador de Servicio de Salud': UserType.provider,
  'Corredor de Seguro': UserType.broker,
};

final Map<UserType, String> userTypeToString = {
  UserType.patient: 'Paciente',
  UserType.ars: 'ARS',
  UserType.provider: 'Prestador de Servicio de Salud',
  UserType.broker: 'Corredor de Seguro',
};
