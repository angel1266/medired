import 'package:medired/core/core_export.dart';
import 'package:medired/core/utils/json_serializable/serializable.dart';
import 'package:medired/features/authentication/data/models/base_info_model.dart';
import 'package:medired/features/authentication/domain/entities/authentication_entities.dart';

class BaseInfo extends Equatable implements Serializable {
  final Language language;
  final List<PhoneNumber> phoneNumber;
  final List<Document> documents;
  final List<Address> address;

  const BaseInfo({
    required this.language,
    required this.phoneNumber,
    required this.documents,
    required this.address,
  });

  BaseInfo copyWith({
    Language? language,
    List<PhoneNumber>? phoneNumber,
    List<Document>? documents,
    List<Address>? address,
  }) {
    return BaseInfo(
      language: language ?? this.language,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      documents: documents ?? this.documents,
      address: address ?? this.address,
    );
  }

  factory BaseInfo.fromEmpty() {
    return const BaseInfo(
      language: Language.es,
      phoneNumber: [],
      documents: [],
      address: [],
    );
  }

  factory BaseInfo.fromSignUp() {
    return BaseInfo(
      language: Language.es,
      phoneNumber: const [
        PhoneNumber(type: 0, phoneNumber: '', country: Country.DO)
      ],
      documents: [
        Document(
            value: '',
            country: Country.DO,
            documentType: DocumentType.idCard,
            expirationDate: DateTime.now())
      ],
      address: const [],
    );
  }

  @override
  List<Object?> get props => [
        language,
        phoneNumber,
        documents,
        address,
      ];

  @override
  toJson() => BaseInfoModel.fromEntity(this).toJson();

  @override
  fromJson(Map<String, dynamic> json) => BaseInfoModel.fromJson(json);
}
