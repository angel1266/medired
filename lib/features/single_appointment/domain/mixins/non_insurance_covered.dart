mixin NonInsuranceCovered {
  String get amount;

  set amount(String value);

  String getPoints() => (double.parse(amount) * 0.01).toStringAsFixed(2);
}
