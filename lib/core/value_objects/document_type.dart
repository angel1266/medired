import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'documentType')
enum DocumentType {
  @JsonValue(0)
  idCard,
  @JsonValue(1)
  rnc,
  @JsonValue(2)
  passport,
  @JsonValue(3)
  residence,
  // driversLicense,
}

final Map<String, DocumentType> stringToDocumentType = {
  'Cédula de identidad': DocumentType.idCard,
  'Pasaporte': DocumentType.passport,
  'Residencia': DocumentType.residence,
  'RNC': DocumentType.rnc,
  // 'Driver\'s license': DocumentType.driversLicense,
};

final Map<DocumentType, String> documentTypeToString = {
  DocumentType.idCard: 'Cédula de identidad',
  DocumentType.passport: 'Pasaporte',
  DocumentType.residence: 'Residencia',
  DocumentType.rnc: 'RNC',
  // DocumentType.driversLicense: 'Driver\'s license',
};
