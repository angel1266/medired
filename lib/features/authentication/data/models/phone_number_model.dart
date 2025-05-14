import 'package:json_annotation/json_annotation.dart';
import 'package:medired/core/value_objects/country.dart';
import 'package:medired/features/authentication/domain/entities/authentication_entities.dart';

part 'phone_number_model.g.dart';

@JsonSerializable()
class PhoneNumberModel extends PhoneNumber {
  const PhoneNumberModel({
    required super.type,
    required super.phoneNumber,
    required super.country,
  });

  factory PhoneNumberModel.fromEntity(PhoneNumber phoneNumber) =>
      PhoneNumberModel(
        type: phoneNumber.type,
        phoneNumber: phoneNumber.phoneNumber,
        country: phoneNumber.country,
      );

  factory PhoneNumberModel.fromJson(Map<String, dynamic> json) =>
      _$PhoneNumberModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PhoneNumberModelToJson(this);
}
