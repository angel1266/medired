import 'package:medired/core/core_export.dart';
import 'package:medired/core/utils/json_serializable/serializable.dart';
import 'package:medired/features/subscription/data/models/subscription_model.dart';

class Subscription extends Equatable implements Serializable {
  final String id;
  final String uid;
  final DateTime setDate;
  final SubscriptionType subscriptionType;
  final int medicalConsultation;
  final int medicalTest;
  final int medicalImage;

  const Subscription({
    required this.id,
    required this.uid,
    required this.setDate,
    required this.subscriptionType,
    required this.medicalConsultation,
    required this.medicalTest,
    required this.medicalImage,
  });

  factory Subscription.monthly({
    required String uid,
    required DateTime date,
  }) =>
      Subscription(
        id: '',
        uid: uid,
        setDate: DateTime(date.year, date.month + 1, date.day),
        subscriptionType: SubscriptionType.mensual,
        medicalConsultation: 1,
        medicalTest: 1,
        medicalImage: 1,
      );

  factory Subscription.quaterly({
    required String uid,
    required DateTime date,
  }) =>
      Subscription(
        id: '',
        uid: uid,
        setDate: DateTime(date.year, date.month + 3, date.day),
        subscriptionType: SubscriptionType.trimestral,
        medicalConsultation: 1,
        medicalTest: 1,
        medicalImage: 1,
      );

  factory Subscription.biAnual({
    required String uid,
    required DateTime date,
  }) =>
      Subscription(
        id: '',
        uid: uid,
        setDate: DateTime(date.year, date.month + 6, date.day),
        subscriptionType: SubscriptionType.semestral,
        medicalConsultation: 2,
        medicalTest: 2,
        medicalImage: 2,
      );

  factory Subscription.anual({
    required String uid,
    required DateTime date,
  }) =>
      Subscription(
        id: '',
        uid: uid,
        setDate: DateTime(date.year + 1, date.month, date.day),
        subscriptionType: SubscriptionType.anual,
        medicalConsultation: 4,
        medicalTest: 4,
        medicalImage: 4,
      );

  factory Subscription.none({
    required String uid,
    required DateTime date,
  }) =>
      Subscription(
        id: '',
        uid: uid,
        setDate: date,
        subscriptionType: SubscriptionType.none,
        medicalConsultation: 0,
        medicalTest: 0,
        medicalImage: 0,
      );

  Subscription copyWith({
    String? id,
    String? uid,
    DateTime? setDate,
    SubscriptionType? subscriptionType,
    int? medicalConsultation,
    int? medicalTest,
    int? medicalImage,
  }) =>
      Subscription(
        id: id ?? this.id,
        uid: uid ?? this.uid,
        setDate: setDate ?? this.setDate,
        subscriptionType: subscriptionType ?? this.subscriptionType,
        medicalConsultation: medicalConsultation ?? this.medicalConsultation,
        medicalTest: medicalTest ?? this.medicalTest,
        medicalImage: medicalImage ?? this.medicalImage,
      );

  factory Subscription.toEntity(SubscriptionModel model) => Subscription(
        id: model.id,
        uid: model.uid,
        setDate: model.setDate,
        subscriptionType: model.subscriptionType,
        medicalConsultation: model.medicalConsultation,
        medicalImage: model.medicalImage,
        medicalTest: model.medicalTest,
      );

  @override
  List<Object?> get props => [
        id,
        uid,
        setDate,
        subscriptionType,
        medicalConsultation,
        medicalTest,
        medicalImage,
      ];

  @override
  Serializable fromJson(Map<String, dynamic> json) =>
      SubscriptionModel.fromJson(json);

  @override
  Map<String, dynamic> toJson() => SubscriptionModel.fromEntity(this).toJson();
}
