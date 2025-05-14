import 'package:json_annotation/json_annotation.dart';
import 'package:medired/features/authentication/domain/entities/authentication_entities.dart';

part 'address_model.g.dart';

@JsonSerializable()
class AddressModel extends Address {
  const AddressModel({
    required super.country,
    required super.region,
    required super.city,
    required super.street,
    required super.zip,
    required super.notes,
    int? latitude,
    int? longitude,
  });

  factory AddressModel.fromEntity(Address address) => AddressModel(
        country: address.country,
        region: address.region,
        city: address.city,
        street: address.street,
        zip: address.zip,
        notes: address.notes,
        latitude: address.latitude,
        longitude: address.longitude,
      );
  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AddressModelToJson(this);
}
