import 'package:equatable/equatable.dart';
import 'package:medired/features/single_appointment/domain/entities/appointment.dart';
import 'package:medired/features/request/data/models/request_model.dart';

/// A request
class Request extends Equatable {
  //The patients id
  final String uid;
  //TODO: Fix this since it has to be in it's own table
  final String description;
  final Appointment appointment;
  //TODO: Add to it's own class
  final String symptomps;

  const Request({
    required this.uid,
    required this.description,
    required this.appointment,
    required this.symptomps,
  });

  factory Request.fromEntity(RequestModel requestModel) {
    return Request(
      uid: requestModel.uid,
      description: requestModel.description,
      appointment: requestModel.appointment,
      symptomps: requestModel.symptomps,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        description,
        appointment,
      ];
}
