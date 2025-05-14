import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'subscriptionType')
enum SubscriptionType {
  @JsonValue(0)
  none,
  @JsonValue(1)
  mensual,
  @JsonValue(2)
  semestral,
  @JsonValue(3)
  trimestral,
  @JsonValue(4)
  anual,
}

final Map<String, SubscriptionType> stringToSubscriptionType = {
  'Sin suscripción': SubscriptionType.none,
  'Mensual': SubscriptionType.mensual,
  'Semestral': SubscriptionType.semestral,
  'Trimestral': SubscriptionType.trimestral,
  'Anual': SubscriptionType.anual,
};

final Map<SubscriptionType, String> subscriptionTypeToString = {
  SubscriptionType.mensual: 'Mensual',
  SubscriptionType.trimestral: 'Trimestral',
  SubscriptionType.none: 'Sin suscripción',
  SubscriptionType.semestral: 'Semestral',
  SubscriptionType.anual: 'Anual'
};

final Map<SubscriptionType, double> subscriptionPrice = {
  SubscriptionType.none: 0,
  SubscriptionType.mensual: 500,
  SubscriptionType.trimestral: 1500,
  SubscriptionType.semestral: 3000,
  SubscriptionType.anual: 6000,
};