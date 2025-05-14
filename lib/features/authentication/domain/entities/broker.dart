import 'package:medired/features/authentication/authentication_export.dart';

class Broker extends Company {
  final List<MemberInfo> memberList;
  final String amountDue;

  const Broker({
    required super.authInfo,
    required super.memberInfo,
    required super.companyInfo,
    required this.memberList,
    required this.amountDue,
  });

  factory Broker.fromEntity(BrokerModel brokerModel) {
    return Broker(
      authInfo: brokerModel.authInfo,
      companyInfo: brokerModel.companyInfo,
      memberInfo: brokerModel.memberInfo,
      memberList: brokerModel.memberList,
      amountDue: brokerModel.amountDue,
    );
  }

  @override
  List<Object?> get props => [
        companyInfo,
        memberInfo,
        memberList,
        amountDue,
      ];

  @override
  toJson() => BrokerModel.fromEntity(this).toJson();

  @override
  fromJson(Map<String, dynamic> json) => BrokerModel.fromJson(json);
}
