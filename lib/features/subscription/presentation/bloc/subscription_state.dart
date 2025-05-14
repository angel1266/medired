part of 'subscription_bloc.dart';

sealed class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object?> get props => [];
}

final class UnloadedSubscriptionState extends SubscriptionState {
  const UnloadedSubscriptionState();
}

/*
--- 🌟⏳ Loading ⏳🌟 ---
*/

final class LoadingSubscriptionState extends SubscriptionState {
  const LoadingSubscriptionState();
}

final class LoadingListenSubscription extends LoadingSubscriptionState {}

final class LoadingStartListeningSubscription
    extends LoadingSubscriptionState {}

final class LoadingStopListeningSubscription extends LoadingSubscriptionState {}

final class LoadingCreateSubscription extends LoadingSubscriptionState {}

final class LoadingGetSubscription extends LoadingSubscriptionState {}

final class LoadingReduceConsultation extends LoadingSubscriptionState {}

final class LoadingReduceTest extends LoadingSubscriptionState {}

final class LoadingUpdateSubscription extends LoadingSubscriptionState {}

final class LoadingUpdatePaymentSubscription extends LoadingSubscriptionState {}

/*
--- 🌟✅ Success ✅🌟 ---
*/

sealed class SuccessSubscriptionState extends SubscriptionState {
  const SuccessSubscriptionState();
}

final class SuccessCreateSubscription extends SuccessSubscriptionState {
  final Subscription subscription;
  const SuccessCreateSubscription({required this.subscription});
}

final class SuccessStartListeningSubscription extends SubscriptionState {
  const SuccessStartListeningSubscription();
}

final class SuccessListenSubscription extends SuccessSubscriptionState {
  final Subscription subscription;
  const SuccessListenSubscription({required this.subscription});

  @override
  List<Object?> get props => [subscription];
}

final class SuccessGetSubscription extends SuccessSubscriptionState {
  final Subscription subscription;
  const SuccessGetSubscription({required this.subscription});

  @override
  List<Object?> get props => [subscription];
}

final class SuccessReduceConsultation extends SuccessSubscriptionState {
  final MedicalSpecialization medicalSpecialization;
  final ServiceProvider serviceProvider;
  final ServiceType serviceType;
  final Patient patient;
  const SuccessReduceConsultation(
      {required this.medicalSpecialization,
      required this.serviceProvider,
      required this.serviceType,
      required this.patient});
}

final class SuccessReduceTest extends SuccessSubscriptionState {
  final MedicalTest medicalTest;
  final ServiceProvider serviceProvider;
  final ServiceType serviceType;
  final Patient patient;
  const SuccessReduceTest(
      {required this.medicalTest,
      required this.serviceProvider,
      required this.serviceType,
      required this.patient});

  @override
  List<Object?> get props => [patient, serviceProvider, serviceType];
}

final class SuccessUpdateSuscription extends SuccessSubscriptionState {
  final Patient patient;
  final ServiceProvider serviceProvider;
  final ServiceType serviceType;
  const SuccessUpdateSuscription(
      {required this.patient,
      required this.serviceProvider,
      required this.serviceType});

  @override
  List<Object?> get props => [patient, serviceProvider, serviceType];
}

final class SuccessStopListeningSubscription extends SuccessSubscriptionState {}

final class SuccessUpdatePaymentSubscription extends SuccessSubscriptionState {
  final SubscriptionType subscriptionType;
  final Payment payment;
  const SuccessUpdatePaymentSubscription(
      {required this.subscriptionType, required this.payment});

  @override
  List<Object?> get props => [subscriptionType, payment];
}

/*
--- 🌟🚨 Error 🚨🌟 ---
*/

final class ErrorSubscriptionState extends SubscriptionState {
  final String message;

  const ErrorSubscriptionState(this.message);

  @override
  List<Object?> get props => [message];
}

final class ErrorStartListeningSubscription extends ErrorSubscriptionState {
  const ErrorStartListeningSubscription(super.message);
}

final class ErrorListenSubscription extends ErrorSubscriptionState {
  const ErrorListenSubscription(super.message);
}

final class ErrorStopListeningSubscription extends ErrorSubscriptionState {
  const ErrorStopListeningSubscription(super.message);
}

final class ErrorReduceConsultation extends ErrorSubscriptionState {
  const ErrorReduceConsultation(super.message);
}

final class ErrorReduceTest extends ErrorSubscriptionState {
  const ErrorReduceTest(super.message);
}

final class ErrorGetSubscription extends ErrorSubscriptionState {
  const ErrorGetSubscription(super.message);
}

final class ErrorCreateSubscription extends ErrorSubscriptionState {
  const ErrorCreateSubscription(super.message);
}

final class ErrorUpdateSubscription extends ErrorSubscriptionState {
  const ErrorUpdateSubscription(super.message);
}

final class ErrorUpdatePaymentSubscription extends ErrorSubscriptionState {
  const ErrorUpdatePaymentSubscription(super.message);
}
