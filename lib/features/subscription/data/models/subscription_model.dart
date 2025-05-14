import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:medired/core/utils/json_serializable/time_stamp_converter.dart';
import 'package:medired/core/value_objects/subscription_type.dart';
import 'package:medired/features/subscription/domain/entities/subscription.dart';

part 'subscription_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SubscriptionModel extends Subscription {
  @TimestampConverter()
  @override
  DateTime get setDate => super.setDate;

  set setDate(DateTime value) {
    super.copyWith(setDate: value);
  }

  const SubscriptionModel({
    required super.id,
    required super.uid,
    required super.setDate,
    required super.subscriptionType,
    required super.medicalConsultation,
    required super.medicalTest,
    required super.medicalImage,
  });

  factory SubscriptionModel.fromEntity(Subscription subscription) =>
      SubscriptionModel(
        id: subscription.id,
        uid: subscription.uid,
        setDate: subscription.setDate,
        subscriptionType: subscription.subscriptionType,
        medicalConsultation: subscription.medicalConsultation,
        medicalTest: subscription.medicalTest,
        medicalImage: subscription.medicalImage,
      );

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SubscriptionModelToJson(this);
}
