import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'pharmacySpecialization')
enum PharmacySpecialization {
  @JsonValue(0)
  prescriptionMedicine,
  @JsonValue(1)
  analgesic,
}

final Map<PharmacySpecialization, String> pharmacySpecializationToString = {
  PharmacySpecialization.prescriptionMedicine: 'Medicamentos Recetados',
  PharmacySpecialization.analgesic: 'Analgésicos',
};

final Map<String, PharmacySpecialization> stringToPharmacySpecialization = {
  'Medicamentos Recetados': PharmacySpecialization.prescriptionMedicine,
  'Analgésicos': PharmacySpecialization.analgesic,
};
