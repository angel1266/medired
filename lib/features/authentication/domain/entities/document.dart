import 'package:equatable/equatable.dart';
import 'package:medired/core/utils/json_serializable/serializable.dart';
import 'package:medired/core/value_objects/country.dart';
import 'package:medired/core/value_objects/document_type.dart';
import 'package:medired/features/authentication/data/models/document_model.dart';

class Document extends Equatable implements Serializable {
  final String value;
  final Country country;
  final DocumentType documentType;
  final DateTime expirationDate;
  final List<String> photos;

  const Document({
    required this.value,
    required this.country,
    required this.documentType,
    required this.expirationDate,
    this.photos = const [],
  });

  String? get validateAll {
    if (value.isEmpty) {
      return 'Rellena el valor';
    } else if (isDominicanId) {
      if (!_isNumeric(value) || !_isAlphanumeric(value)) {
        return 'Solo números';
      } else if (value.length != 11) {
        return 'Ingresa 11 dígitos de tu cédula';
      } else if (_hasRepeatedCharacters(value)) {
        return 'No se admiten caracteres consecutivos';
      }
    } else if (!isDominicanId) {
      if (!_isAlphanumeric(value)) {
        return 'Solo números y letras';
      } else if (_hasRepeatedCharacters(value)) {
        return 'No se admiten caracteres consecutivos';
      } else if (value.length > 25) {
        return 'Máximo 25 caracteres';
      }
    }
    return null;
  }

  bool get isValidDominicanId =>
      value.length == 11 && isDominicanId && _isNumeric(value);

  bool get isDominicanId =>
      country == Country.DO && documentType == DocumentType.idCard;

  String formatValue() {
    return isDominicanId ? formatDominicanId() : value;
  }

  Pattern get dominicanIdRegex => RegExp(r'(\d{3})(\d{6})(\d{1})');

  String formatDominicanId() {
    return value.replaceAllMapped(dominicanIdRegex, (Match match) {
      return '${match[1]}-${match[2]}-${match[3]}';
    });
  }

  bool _isNumeric(String str) {
    final numericRegex = RegExp(r'^\d+$');
    return numericRegex.hasMatch(str);
  }

  bool _isAlphanumeric(String str) {
    final alphanumericRegex = RegExp(r'^[a-zA-Z0-9]+$');
    return alphanumericRegex.hasMatch(str);
  }

  bool _hasRepeatedCharacters(String str) {
    if (str.isEmpty) return false;

    return str.split('').every((char) => char == str[0]);
  }

  Document copyWith({
    String? value,
    Country? country,
    DocumentType? documentType,
    DateTime? expirationDate,
    List<String>? photos,
  }) =>
      Document(
        value: value ?? this.value,
        country: country ?? this.country,
        documentType: documentType ?? this.documentType,
        expirationDate: expirationDate ?? this.expirationDate,
        photos: photos ?? this.photos,
      );

  factory Document.toEntity(DocumentModel documentModel) {
    return Document(
      value: documentModel.value,
      country: documentModel.country,
      documentType: documentModel.documentType,
      expirationDate: documentModel.expirationDate,
      photos: documentModel.photos,
    );
  }

  @override
  List<Object?> get props => [
        value,
        country,
        documentType,
        expirationDate,
        photos,
      ];

  @override
  toJson() => DocumentModel.fromEntity(this).toJson();

  @override
  fromJson(Map<String, dynamic> json) => DocumentModel.fromJson(json);
}
