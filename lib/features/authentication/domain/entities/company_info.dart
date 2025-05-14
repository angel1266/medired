import 'package:medired/core/value_objects/country.dart';
import 'package:medired/core/value_objects/document_type.dart';
import 'package:medired/core/value_objects/language.dart';
import 'package:medired/features/authentication/data/models/company_info_model.dart';
import 'package:medired/features/authentication/domain/entities/authentication_entities.dart';

class CompanyInfo extends BaseInfo {
  final String name;

  const CompanyInfo({
    required this.name,
    required super.language,
    required super.phoneNumber,
    required super.documents,
    required super.address,
  });

  @override
  factory CompanyInfo.fromSignUp() {
    return CompanyInfo(
      name: '',
      language: Language.es,
      phoneNumber: const [
        PhoneNumber(type: 0, phoneNumber: '', country: Country.DO)
      ],
      documents: [
        Document(
            value: '',
            country: Country.DO,
            documentType: DocumentType.rnc,
            expirationDate: DateTime.now())
      ],
      address: const [],
    );
  }

  @override
  CompanyInfo copyWith({
    String? name,
    Language? language,
    List<PhoneNumber>? phoneNumber,
    List<Document>? documents,
    List<Address>? address,
  }) {
    return CompanyInfo(
      name: name ?? this.name,
      language: language ?? this.language,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      documents: documents ?? this.documents,
      address: address ?? this.address,
    );
  }

  @override
  List<Object?> get props => [
        name,
        language,
        phoneNumber,
        documents,
        address,
      ];

  @override
  toJson() => CompanyInfoModel.fromEntity(this).toJson();

  @override
  fromJson(Map<String, dynamic> json) => CompanyInfoModel.fromJson(json);
}
