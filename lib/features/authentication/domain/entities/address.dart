import 'package:medired/core/bloc/bloc_export.dart';
import 'package:medired/core/utils/json_serializable/serializable.dart';
import 'package:medired/features/authentication/data/models/address_model.dart';

class Address extends Equatable implements Serializable {
  final int country;
  final String region;
  final String city;
  final String street;
  final String zip;
  final String notes;
  final int? latitude;
  final int? longitude;

  const Address({
    required this.country,
    required this.region,
    required this.city,
    required this.street,
    required this.zip,
    this.notes = '',
    this.latitude,
    this.longitude,
  });

  Address copyWith({
    int? country,
    String? region,
    String? city,
    String? street,
    String? zip,
    String? notes,
    int? latitude,
    int? longitude,
  }) =>
      Address(
        country: country ?? this.country,
        region: region ?? this.region,
        city: city ?? this.city,
        street: street ?? this.street,
        zip: zip ?? this.zip,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );

  @override
  List<Object?> get props => [
        country,
        region,
        city,
        street,
        zip,
        notes,
        latitude,
        longitude,
      ];

  @override
  toJson() => AddressModel.fromEntity(this).toJson();

  @override
  fromJson(Map<String, dynamic> json) => AddressModel.fromJson(json);
}
