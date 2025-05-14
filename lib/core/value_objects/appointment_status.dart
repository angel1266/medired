import 'package:flutter/material.dart' show Colors, Color;
import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'status')
enum AppointmentStatus {
  @JsonValue(0)
  unauthorized,
  @JsonValue(1)
  authorized,
  @JsonValue(2)
  pending,
}

final Map<Color, AppointmentStatus> colourToAppointmentStatus = {
  Colors.red: AppointmentStatus.unauthorized,
  Colors.green: AppointmentStatus.authorized,
  Colors.yellow: AppointmentStatus.pending,
};

final Map<AppointmentStatus, Color> appointmentStatusToColour = {
  AppointmentStatus.unauthorized: Colors.red,
  AppointmentStatus.authorized: Colors.green,
  AppointmentStatus.pending: Colors.amber,
};
