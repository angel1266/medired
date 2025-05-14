part of 'subscription_bloc.dart';

sealed class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object> get props => [];
}

final class CreateSubscription extends SubscriptionEvent {
  final String uid;
  const CreateSubscription({required this.uid});
}

sealed class UpdateSubscription extends SubscriptionEvent {
  final Subscription subscription;
  final Patient patient;
  final ServiceType serviceType;
  final ServiceProvider serviceProvider;

  const UpdateSubscription(
      {required this.subscription,
      required this.patient,
      required this.serviceType,
      required this.serviceProvider});
}

final class GetSubscription extends SubscriptionEvent {
  final String uid;

  const GetSubscription({required this.uid});
}

final class ReduceConsultation extends UpdateSubscription {
  final MedicalSpecialization medicalSpecialization;
  const ReduceConsultation(
      {required super.subscription,
      required super.patient,
      super.serviceType = ServiceType.medicalConsultation,
      required super.serviceProvider,
      required this.medicalSpecialization});
}

final class ReduceTest extends UpdateSubscription {
  final MedicalTest medicalTest;
  const ReduceTest(
      {required super.subscription,
      required super.patient,
      super.serviceType = ServiceType.test,
      required super.serviceProvider,
      required this.medicalTest});
}

final class ReduceImage extends UpdateSubscription {
  final MedicalTest medicalTest;
  const ReduceImage(
      {required super.subscription,
      required super.patient,
      super.serviceType = ServiceType.test,
      required super.serviceProvider,
      required this.medicalTest});
}

final class UpdatePaymentSubscription extends SubscriptionEvent {
  final PayFrequency payFrequency;
  final String uid;
  final Payment payment;
  final String subscriptionId;
  const UpdatePaymentSubscription({
    required this.payFrequency,
    required this.uid,
    required this.payment,
    required this.subscriptionId,
  });
}

final class StartListeningSubscription extends SubscriptionEvent {
  final String uid;
  const StartListeningSubscription({required this.uid});
}

final class ListenSubscription extends SubscriptionEvent {
  final String uid;

  const ListenSubscription({required this.uid});
}

final class StopListeningSubscription extends SubscriptionEvent {}
