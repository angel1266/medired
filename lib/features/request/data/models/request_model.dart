import 'package:json_annotation/json_annotation.dart';
import 'package:medired/features/single_appointment/data/models/appointment_model.dart';
import 'package:medired/features/request/domain/entities/request.dart';

part 'request_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RequestModel extends Request {
  @JsonKey(name: 'appointments')
  final AppointmentModel appointmentModel;
  const RequestModel({
    required super.uid,
    required super.description,
    required this.appointmentModel,
    required super.symptomps,
  }) : super(
          appointment: appointmentModel,
        );

  factory RequestModel.fromEntity(Request request) {
    return RequestModel(
      uid: request.uid,
      description: request.description,
      appointmentModel: AppointmentModel.fromEntity(request.appointment),
      symptomps: request.symptomps,
    );
  }

  factory RequestModel.fromJson(Map<String, dynamic> json) =>
      _$RequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RequestModelToJson(this);
}
