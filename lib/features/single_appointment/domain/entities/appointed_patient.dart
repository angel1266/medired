import 'package:equatable/equatable.dart';

class AppointedPatient extends Equatable {
  final String uid;
  final String firstName;
  final String lastName;

  const AppointedPatient({
    required this.uid,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object?> get props => [
        uid,
        firstName,
        lastName,
      ];
}
