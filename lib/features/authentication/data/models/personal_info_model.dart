import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:medired/core/utils/json_serializable/json_serializable.dart';
import 'package:medired/core/value_objects/country.dart';
import 'package:medired/core/value_objects/language.dart';
import 'package:medired/core/value_objects/user_sex.dart';
import 'package:medired/features/authentication/data/models/authentication_model_export.dart';
import 'package:medired/features/authentication/domain/entities/authentication_entities.dart';

part 'personal_info_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PersonalInfoModel extends PersonalInfo {
  @JsonKey(name: 'phoneNumber')
  final List<PhoneNumberModel> phoneNumberModel;

  @JsonKey(name: 'documents')
  final List<DocumentModel> documentsModel;

  @JsonKey(name: 'address')
  final List<AddressModel> addressModel;

  @TimestampConverter()
  @override
  DateTime get birthdate => super.birthdate;

  set birthdate(DateTime value) {
    super.copyWith(birthdate: value);
  }

  const PersonalInfoModel({
    required super.firstName,
    required super.lastName,
    required super.token_facebook,
    required super.token_google,
    required super.sex,
    required super.nationality,
    required super.birthdate,
    required super.language,
    required this.phoneNumberModel,
    required this.documentsModel,
    required this.addressModel,
  }) : super(
          phoneNumber: phoneNumberModel,
          documents: documentsModel,
          address: addressModel,
        );

  factory PersonalInfoModel.fromEntity(PersonalInfo personalInfo) =>
      PersonalInfoModel(
        firstName: personalInfo.firstName,
        lastName: personalInfo.lastName,
        token_facebook: personalInfo.token_facebook ?? "",
        token_google: personalInfo.token_google ?? "",
        sex: personalInfo.sex,
        birthdate: personalInfo.birthdate,
        nationality: personalInfo.nationality,
        language: personalInfo.language,
        phoneNumberModel: personalInfo.phoneNumber
            .map((e) => PhoneNumberModel.fromEntity(e))
            .toList(),
        documentsModel: personalInfo.documents
            .map((e) => DocumentModel.fromEntity(e))
            .toList(),
        addressModel: personalInfo.address
            .map((e) => AddressModel.fromEntity(e))
            .toList(),
      );

  factory PersonalInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PersonalInfoModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PersonalInfoModelToJson(this);
}
