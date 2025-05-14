import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_devtools/flutter_bloc_devtools.dart';
import 'package:medired/features/authentication/authentication_export.dart';

part 'auth_info_event.dart';
part 'auth_info_state.dart';

class AuthInfoBloc extends Bloc<AuthInfoEvent, AuthInfoState> {
  AuthInfoBloc() : super(LoadedAuthInfo(authInfo: AuthInfo.fromSignUp())) {
    on<UpdateAuthInfo>(_updateAuthInfo);
  }

  void _updateAuthInfo(UpdateAuthInfo event, Emitter<AuthInfoState> emit) {
    emit(LoadedAuthInfo(authInfo: event.authInfo));
  }
}
