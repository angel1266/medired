import 'dart:async';

import 'package:medired/core/core_export.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/features/authentication/domain/usecases/remote/listen_remote_patient.dart';
import 'package:medired/features/authentication/domain/usecases/remote/update_remote_member.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateRemoteProfilePhotoUseCase _updateRemoteProfilePhoto;
  final UpdateRemoteMemberUseCase _updateRemoteMember;
  final CreateRemoteServiceProviderUseCase _createRemoteServiceProvider;
  final UpdateRemoteMemberSubscriptionUseCase _updateRemoteMemberSubscription;
  final ListenRemotePatientUseCase _listenRemotePatient;

  StreamSubscription<DataState<Patient>>? subscription;

  ProfileBloc(
    this._updateRemoteProfilePhoto,
    this._updateRemoteMember,
    this._createRemoteServiceProvider,
    this._updateRemoteMemberSubscription,
    this._listenRemotePatient,
  ) : super(const ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfilePhoto>(_onUpdateProfilePhoto);
    on<UpdateMemberSubscription>(_onUpdateMemberSubscription);
    on<UpdateUserInfo>(_onUpdateUserInfo);
    on<UpdateAddress>(_onUpdateAddress);
    on<ListenProfile>(_onListenProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    if (event.auth is Patient) {
      emit(ProfileLoaded<Patient>(user: (event.auth as Patient)));
    } else if (event.auth is ServiceProvider) {
      emit(ProfileLoaded<ServiceProvider>(
          user: (event.auth as ServiceProvider)));
    }
  }

  Future<void> _onUpdateProfilePhoto(
    UpdateProfilePhoto event,
    Emitter<ProfileState> emit,
  ) async {
    Member? currentUser;
    if (state is ProfileLoaded<Patient>) {
      currentUser = (state as ProfileLoaded<Patient>).user;
    } else if (state is ProfileLoaded<ServiceProvider>) {
      currentUser = (state as ProfileLoaded<ServiceProvider>).user;
    }

    emit(const ProfileLoading());

    DataState<String> result = await _updateRemoteProfilePhoto.call(
      uid: event.uid,
      imageBytes: event.imageBytes,
    );

    result.fold((l) => emit(ProfileError(error: l)), (r) {
      if (currentUser is Patient) {
        emit(ProfileLoaded<Patient>(
            user: currentUser.copyWith(
                authInfo: currentUser.authInfo.copyWith(
          photoUrl: r,
        ))));
      } else if (currentUser is ServiceProvider) {
        emit(ProfileLoaded<ServiceProvider>(
            user: currentUser.copyWith(
                authInfo: currentUser.authInfo.copyWith(
          photoUrl: r,
        ))));
      }
    });
  }

  Future<void> _onUpdateMemberSubscription(
    UpdateMemberSubscription event,
    Emitter<ProfileState> emit,
  ) async {
    Member? currentUser;
    if (state is ProfileLoaded<Patient>) {
      currentUser = (state as ProfileLoaded<Patient>).user;
    } else if (state is ProfileLoaded<ServiceProvider>) {
      currentUser = (state as ProfileLoaded<ServiceProvider>).user;
    }
    // emit(const LoadingAuthState());
    DataState<Unit> result = await _updateRemoteMemberSubscription.call(
      uid: event.uid,
      subscriptionType: event.subscriptionType,
    );

    result.fold((l) => emit(ProfileError(error: l)), (r) {
      if (currentUser is Patient) {
        emit(ProfileLoaded<Patient>(
            user: currentUser.copyWith(
          memberInfo: currentUser.memberInfo.copyWith(
            subscriptionType: event.subscriptionType,
          ),
        )));
      } else if (currentUser is ServiceProvider) {
        emit(ProfileLoaded<ServiceProvider>(
            user: currentUser.copyWith(
          memberInfo: currentUser.memberInfo.copyWith(
            subscriptionType: event.subscriptionType,
          ),
        )));
      }
    });
  }

  Future<void> _onUpdateUserInfo(
    UpdateUserInfo event,
    Emitter<ProfileState> emit,
  ) async {
    if (event.newUser is Patient) {
      Patient newCurrentUser = event.newUser as Patient;

      await _updateRemoteMember.call<Patient>(newCurrentUser);
      emit(ProfileLoaded<Patient>(user: newCurrentUser));
    } else if (event.newUser is ServiceProvider) {
      ServiceProvider newCurrentUser = event.newUser as ServiceProvider;

      await _updateRemoteMember.call<ServiceProvider>(newCurrentUser);
      emit(ProfileLoaded<ServiceProvider>(user: newCurrentUser));
    }
  }

  Future<void> _onUpdateAddress(
    UpdateAddress event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      Member? currentUser;
      if (state is ProfileLoaded<Patient>) {
        currentUser = (state as ProfileLoaded<Patient>).user;
      } else if (state is ProfileLoaded<ServiceProvider>) {
        currentUser = (state as ProfileLoaded<ServiceProvider>).user;
      }

      if (currentUser is Patient) {
        Patient newCurrentUser = currentUser.copyWith(
          personalInfo: currentUser.personalInfo.copyWith(
            address: [
              AddressModel(
                country: event.country.index,
                region: event.region,
                city: event.city,
                street: event.street,
                zip: event.zip,
                notes: event.notes,
                latitude: event.latitude,
                longitude: event.longitude,
              ),
            ],
          ),
        );

        await _updateRemoteMember.call<Patient>(newCurrentUser);
        emit(ProfileLoaded<Patient>(user: newCurrentUser));
      } else if (currentUser is ServiceProvider) {
        ServiceProvider newCurrentUser = currentUser.copyWith(
          personalInfo: currentUser.personalInfo.copyWith(
            address: [
              AddressModel(
                country: event.country.index,
                region: event.region,
                city: event.city,
                street: event.street,
                zip: event.zip,
                notes: event.notes,
                latitude: event.latitude,
                longitude: event.longitude,
              ),
            ],
          ),
        );
        await _createRemoteServiceProvider.call(
            serviceProvider: newCurrentUser);
        emit(ProfileLoaded<ServiceProvider>(user: newCurrentUser));
      }
    }
  }

  Future<void> _onListenProfile(
    ListenProfile event,
    Emitter<ProfileState> emit,
  ) async {
    await emit.forEach(
      _listenRemotePatient.call(uid: event.uid),
      onData: (result) => result.fold(
        (l) => ProfileError(error: l),
        (r) => ProfileLoaded<Patient>(user: r),
      ),
      onError: (error, stackTrace) => ProfileError(error: error.toString()),
    );
  }
}
