part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();

  @override
  List<Object?> get props => [];
}

/*
--- 🌟⏳ Loading ⏳🌟 ---
*/

class ProfileLoading extends ProfileState {
  const ProfileLoading();

  @override
  List<Object?> get props => [];
}

/*
--- 🌟✅ Success ✅🌟 ---
*/

class ProfileLoaded<T extends Authentication> extends ProfileState {
  final T user;

  const ProfileLoaded({required this.user});

  @override
  List<Object?> get props => [user];
}
/*
--- 🌟🚨 Error 🚨🌟 ---
*/

class ProfileError extends ProfileState {
  final String error;

  const ProfileError({required this.error});

  String get genericError => 'Error profile';

  @override
  List<Object?> get props => [error];
}
