import 'package:equatable/equatable.dart';

class AppointedServiceProvider extends Equatable {
  final String uid;
  final String firstName;
  final String lastName;

  const AppointedServiceProvider({
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
