part of 'base_info_bloc.dart';

sealed class BaseInfoEvent extends Equatable {
  const BaseInfoEvent();

  @override
  List<Object> get props => [];
}

final class UpdatePersonalInfo extends BaseInfoEvent {
  final PersonalInfo personalInfo;
  const UpdatePersonalInfo(this.personalInfo);

  @override
  List<Object> get props => [personalInfo];
}

final class UpdateCompanyInfo extends BaseInfoEvent {
  final CompanyInfo companyInfo;
  const UpdateCompanyInfo(this.companyInfo);

  @override
  List<Object> get props => [companyInfo];
}
