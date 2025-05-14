import 'package:json_annotation/json_annotation.dart';
import 'package:medired/core/value_objects/language.dart';
import 'package:medired/features/authentication/data/models/authentication_model_export.dart';
import 'package:medired/features/authentication/domain/entities/authentication_entities.dart';

part 'company_info_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CompanyInfoModel extends CompanyInfo {
  @JsonKey(name: 'phoneNumber')
  final List<PhoneNumberModel> phoneNumberModel;

  @JsonKey(name: 'documents')
  final List<DocumentModel> documentsModel;

  @JsonKey(name: 'address')
  final List<AddressModel> addressModel;
  const CompanyInfoModel({
    required super.name,
    required super.language,
    required this.phoneNumberModel,
    required this.documentsModel,
    required this.addressModel,
  }) : super(
          phoneNumber: phoneNumberModel,
          documents: documentsModel,
          address: addressModel,
        );

  factory CompanyInfoModel.fromEntity(CompanyInfo companyInfo) =>
      CompanyInfoModel(
        name: companyInfo.name,
        language: companyInfo.language,
        phoneNumberModel: companyInfo.phoneNumber
            .map((e) => PhoneNumberModel.fromEntity(e))
            .toList(),
        documentsModel: companyInfo.documents
            .map((e) => DocumentModel.fromEntity(e))
            .toList(),
        addressModel:
            companyInfo.address.map((e) => AddressModel.fromEntity(e)).toList(),
      );

  factory CompanyInfoModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyInfoModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CompanyInfoModelToJson(this);
}
