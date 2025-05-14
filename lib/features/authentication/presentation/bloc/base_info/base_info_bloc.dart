import 'package:flutter_bloc_devtools/flutter_bloc_devtools.dart';
import 'package:medired/core/core_export.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/features/authentication/data/models/base_info_model.dart';

part 'base_info_event.dart';
part 'base_info_state.dart';

class BaseInfoBloc extends Bloc<BaseInfoEvent, BaseInfoState> {
  BaseInfoBloc() : super(LoadedBaseInfo(baseInfo: BaseInfo.fromSignUp())) {
    // on<UpdateLanguage>(_onUpdateLanguage);
    on<UpdatePersonalInfo>(_onUpdatePersonalInfo);
    on<UpdateCompanyInfo>(_onUpdateCompanyInfo);
  }

  void _onUpdatePersonalInfo(
      UpdatePersonalInfo event, Emitter<BaseInfoState> emit) {
    emit(LoadedPersonalInfo(baseInfo: event.personalInfo));
  }

  void _onUpdateCompanyInfo(
      UpdateCompanyInfo event, Emitter<BaseInfoState> emit) {
    emit(LoadedCompanyInfo(baseInfo: event.companyInfo));
  }
}
