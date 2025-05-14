// profile_event.dart
part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {
  final Authentication auth;

  LoadProfile({required this.auth});
}

class ListenProfile extends ProfileEvent {
  final String uid;

  ListenProfile({required this.uid});
}

class UpdateProfilePhoto extends ProfileEvent {
  final String uid;
  final Uint8List imageBytes;

  UpdateProfilePhoto({required this.uid, required this.imageBytes});
}

class UpdateMemberSubscription extends ProfileEvent {
  final String uid;
  final SubscriptionType subscriptionType;

  UpdateMemberSubscription({required this.uid, required this.subscriptionType});
}

class UpdateUserInfo extends ProfileEvent {
  final Authentication newUser;

  UpdateUserInfo({required this.newUser});
}

class UpdateAddress extends ProfileEvent {
  final Country country;
  final String region;
  final String city;
  final String street;
  final String zip;
  final String notes;
  final int? latitude;
  final int? longitude;

  UpdateAddress({
    required this.country,
    required this.region,
    required this.city,
    required this.street,
    required this.zip,
    required this.notes,
    this.latitude,
    this.longitude,
  });
}
