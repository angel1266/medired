import 'package:medired/core/core_export.dart';
import 'package:medired/core/utils/json_serializable/serializable.dart';
import 'package:medired/features/authentication/data/models/phone_number_model.dart';

class PhoneNumber extends Equatable implements Serializable {
  // Home, Work, Mobile
  final int type;
  // 849 410 1234
  final String phoneNumber;
  // A country returns a country code
  final Country country;

  const PhoneNumber({
    required this.type,
    required this.phoneNumber,
    required this.country,
  });

  String? get validateAll {
    if (phoneNumber.isEmpty) {
      return 'Rellena el valor';
    } else if (isDominicanPhone) {
      if (phoneNumber.length != 10) {
        return 'El número de teléfono debe tener 10 dígitos';
      }
    }
    return null;
  }

  bool get isValidDominicanPhone =>
      phoneNumber.length == 10 && isDominicanPhone;

  bool get isDominicanPhone => country == Country.DO;

  PhoneNumber copyWith({
    int? type,
    String? phoneNumber,
    Country? country,
  }) =>
      PhoneNumber(
        type: type ?? this.type,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        country: country ?? this.country,
      );

  factory PhoneNumber.toEntity(PhoneNumberModel phoneNumberModel) =>
      PhoneNumber(
        type: phoneNumberModel.type,
        phoneNumber: phoneNumberModel.phoneNumber,
        country: phoneNumberModel.country,
      );

  @override
  List<Object?> get props => [
        type,
        phoneNumber,
        country,
      ];

  @override
  toJson() => PhoneNumberModel.fromEntity(this).toJson();

  @override
  fromJson(Map<String, dynamic> json) => PhoneNumberModel.fromJson(json);
}
