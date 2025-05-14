import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'payFrequency')
enum PayFrequency{
  @JsonValue(0)
  monthly,
  @JsonValue(1)
  quarterly,
  @JsonValue(2)
  semiAnnual,
  @JsonValue(3)
  annual
}

final Map<String, PayFrequency> string2PayFrequency = {
  'Mensual': PayFrequency.monthly,
  'Trimestral': PayFrequency.quarterly,
  'Semestral': PayFrequency.semiAnnual,
  'Anual': PayFrequency.annual
};

final Map<PayFrequency, String> payFrequency2String = {
  PayFrequency.monthly: 'Mensual',
  PayFrequency.quarterly: 'Trimestral',
  PayFrequency.semiAnnual: 'Semestral',
  PayFrequency.annual: 'Anual'
};

final Map<PayFrequency, int> paymentAmountByFrequency = {
  PayFrequency.monthly: 500,
  PayFrequency.quarterly: 1500,
  PayFrequency.semiAnnual: 3000,
  PayFrequency.annual: 6000,
};