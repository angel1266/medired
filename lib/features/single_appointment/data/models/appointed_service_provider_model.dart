import 'package:json_annotation/json_annotation.dart';
import 'package:medired/features/authentication/domain/entities/service_provider.dart';
import 'package:medired/features/single_appointment/domain/entities/appointed_service_provider.dart';
part 'appointed_service_provider_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AppointedServiceProviderModel extends AppointedServiceProvider {
  const AppointedServiceProviderModel({
    required super.uid,
    required super.firstName,
    required super.lastName,
  });

  factory AppointedServiceProviderModel.fromEntity(
      AppointedServiceProvider appointedServiceProvider) {
    return AppointedServiceProviderModel(
      uid: appointedServiceProvider.uid,
      firstName: appointedServiceProvider.firstName,
      lastName: appointedServiceProvider.lastName,
    );
  }

  factory AppointedServiceProviderModel.fromServiceProvider(
      ServiceProvider serviceProvider) {
    return AppointedServiceProviderModel(
      uid: serviceProvider.authInfo.uid!,
      firstName: serviceProvider.personalInfo.firstName,
      lastName: serviceProvider.personalInfo.lastName,
    );
  }

  factory AppointedServiceProviderModel.fromJson(Map<String, dynamic> json) =>
      _$AppointedServiceProviderModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppointedServiceProviderModelToJson(this);
}
