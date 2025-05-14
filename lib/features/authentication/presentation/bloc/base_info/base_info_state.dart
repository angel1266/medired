part of 'base_info_bloc.dart';

sealed class BaseInfoState extends Equatable with Mappable {
  final BaseInfo baseInfo;
  const BaseInfoState({required this.baseInfo});

  bool get isValid;

  @override
  Map<String, dynamic> toMap() => {
        'baseInfo': BaseInfoModel.fromEntity(baseInfo).toJson(),
      };

  @override
  List<Object> get props => [baseInfo];
}

final class LoadedBaseInfo extends BaseInfoState {
  @override
  bool get isValid =>
      baseInfo.phoneNumber.any((e) => e.validateAll == null) &&
      baseInfo.documents.any((e) => e.validateAll == null);
  // baseInfo.address.any((e) => e.validateAll == null);

  const LoadedBaseInfo({required super.baseInfo});
}

final class LoadedPersonalInfo extends LoadedBaseInfo {
  @override
  PersonalInfo get baseInfo => super.baseInfo as PersonalInfo;

  @override
  bool get isValid =>
      super.isValid &&
      baseInfo.validateValue(baseInfo.firstName) == null &&
      baseInfo.validateValue(baseInfo.lastName) == null;

  const LoadedPersonalInfo({required super.baseInfo});
}

final class LoadedCompanyInfo extends LoadedBaseInfo {
  @override
  CompanyInfo get baseInfo => super.baseInfo as CompanyInfo;

  const LoadedCompanyInfo({required super.baseInfo});
}
