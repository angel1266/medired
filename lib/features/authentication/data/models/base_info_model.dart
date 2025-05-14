import 'package:json_annotation/json_annotation.dart';
import 'package:medired/core/value_objects/language.dart';
import 'package:medired/features/authentication/data/models/authentication_model_export.dart';
import 'package:medired/features/authentication/domain/entities/authentication_entities.dart';

part 'base_info_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BaseInfoModel extends BaseInfo {
  @JsonKey(name: 'phoneNumber')
  final List<PhoneNumberModel> phoneNumberModel;

  @JsonKey(name: 'documents')
  final List<DocumentModel> documentsModel;

  @JsonKey(name: 'address')
  final List<AddressModel> addressModel;

  const BaseInfoModel({
    required super.language,
    required this.phoneNumberModel,
    required this.documentsModel,
    required this.addressModel,
  }) : super(
          phoneNumber: phoneNumberModel,
          documents: documentsModel,
          address: addressModel,
        );

  factory BaseInfoModel.fromEntity(BaseInfo baseInfo) => BaseInfoModel(
        language: baseInfo.language,
        phoneNumberModel: baseInfo.phoneNumber
            .map((e) => PhoneNumberModel.fromEntity(e))
            .toList(),
        documentsModel:
            baseInfo.documents.map((e) => DocumentModel.fromEntity(e)).toList(),
        addressModel:
            baseInfo.address.map((e) => AddressModel.fromEntity(e)).toList(),
      );

  factory BaseInfoModel.fromJson(Map<String, dynamic> json) =>
      _$BaseInfoModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BaseInfoModelToJson(this);
}
