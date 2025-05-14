import 'dart:async';
import 'package:medired/core/core_export.dart';
import 'package:medired/core/value_objects/medical_specialization.dart';
import 'package:medired/core/value_objects/pay_frequency.dart';
import 'package:medired/core/value_objects/service_type.dart';
import 'package:medired/features/appointments/domain/entities/medical_test.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/features/payment/domain/entities/payment.dart';
import 'package:medired/features/subscription/domain/entities/subscription.dart';
import 'package:medired/features/subscription/domain/usecases/create_subscription.dart';
import 'package:medired/features/subscription/domain/usecases/get_subscription.dart';
import 'package:medired/features/subscription/domain/usecases/listen_subscription.dart';
import 'package:medired/features/subscription/domain/usecases/start_listening_subscription.dart';
import 'package:medired/features/subscription/domain/usecases/stop_listening_subscription.dart';
import 'package:medired/features/subscription/domain/usecases/update_payed_subscription.dart';
import 'package:medired/features/subscription/domain/usecases/update_subscription.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final CreateSubscriptionUseCase _createSubscription;
  final UpdateSubscriptionUseCase _updateSubscription;
  final GetSubscriptionUseCase _getSubscription;
  final ListenSubscriptionUseCase _listenSubscription;
  final StartListeningSubscriptionUseCase _startListeningSubscription;
  final StopListeningSubscriptionUseCase _stopListeningSubscription;
  final UpdatePayedSubscriptionUseCase _updatePayedSubscription;

  SubscriptionBloc(
    this._createSubscription,
    this._updateSubscription,
    this._getSubscription,
    this._listenSubscription,
    this._startListeningSubscription,
    this._stopListeningSubscription,
    this._updatePayedSubscription,
  ) : super(const UnloadedSubscriptionState()) {
    on<CreateSubscription>(_onCreateSubscription);
    on<UpdatePaymentSubscription>(_onUpdatePayedSubscription);
    on<GetSubscription>(_onGetSubscription);
    on<ReduceConsultation>(_onReduceConsultation);
    on<ReduceTest>(_onReduceTest);
    on<ReduceImage>(_onReduceImage);
    on<StartListeningSubscription>(_onStartListeningSubscription);
    on<ListenSubscription>(_onListenSubscription);
    on<StopListeningSubscription>(_onStopListeningSubscription);
  }

  Future<void> _onCreateSubscription(
    CreateSubscription event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(LoadingCreateSubscription());
    var result = await _createSubscription.call(
        subscription: Subscription.none(uid: event.uid, date: DateTime.now()),
        uid: event.uid);
    result.fold(
      (l) => emit(ErrorCreateSubscription(l)),
      (r) => emit(SuccessCreateSubscription(subscription: r)),
    );
  }

  Future<void> _onUpdatePayedSubscription(
    UpdatePaymentSubscription event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(LoadingUpdatePaymentSubscription());
    Subscription subscription;
    if (event.payFrequency == PayFrequency.monthly) {
      subscription = Subscription.monthly(uid: event.uid, date: DateTime.now());
    } else if (event.payFrequency == PayFrequency.quarterly) {
      subscription =
          Subscription.quaterly(uid: event.uid, date: DateTime.now());
    } else if (event.payFrequency == PayFrequency.semiAnnual) {
      subscription = Subscription.biAnual(uid: event.uid, date: DateTime.now());
    } else {
      subscription = Subscription.anual(uid: event.uid, date: DateTime.now());
    }
    var result = await _updatePayedSubscription.call(
      subscriptionId: event.subscriptionId,
      amount: event.payment.amount,
      uid: event.uid,
      subscriptionType: subscription.subscriptionType.index.toString(),
    );

    result.fold(
      (l) => emit(ErrorUpdatePaymentSubscription(l)),
      (r) => emit(SuccessUpdatePaymentSubscription(
          subscriptionType: subscription.subscriptionType,
          payment: event.payment)),
    );
  }

  Future<void> _onGetSubscription(
    GetSubscription event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(LoadingGetSubscription());
    var result = await _getSubscription.call(uid: event.uid);
    result.fold(
      (l) => emit(ErrorGetSubscription(l)),
      (r) => emit(SuccessGetSubscription(subscription: r)),
    );
  }

  Future<void> _onReduceConsultation(
    ReduceConsultation event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(LoadingReduceConsultation());
    var subscription = event.subscription.copyWith(
        medicalConsultation: event.subscription.medicalConsultation - 1);
    /*if (subscription.medicalConsultation < 0) {
      emit(const ErrorReduceConsultation(
        'Has excedido la cantidad de consultas de este plan',
      ));
      return;
    }*/
    var result = await _updateSubscription.call(
        subscription: subscription, uid: subscription.uid);

    result.fold(
      (l) => emit(ErrorReduceConsultation(l)),
      (r) => emit(SuccessReduceConsultation(
        medicalSpecialization: event.medicalSpecialization,
        serviceProvider: event.serviceProvider,
        serviceType: event.serviceType,
        patient: event.patient,
      )),
    );
  }

  Future<void> _onReduceTest(
    ReduceTest event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(LoadingReduceTest());
    var subscription = event.subscription
        .copyWith(medicalTest: event.subscription.medicalTest - 1);
    /*if (subscription.medicalTest < 0) {
      emit(const ErrorReduceTest(
          'Has excedido la cantidad de exámenes de este plan'));
      return;
    }*/

    var result = await _updateSubscription.call(
        subscription: subscription, uid: subscription.uid);

    result.fold(
      (l) => emit(ErrorReduceTest(l)),
      (r) => emit(SuccessReduceTest(
          medicalTest: event.medicalTest,
          serviceProvider: event.serviceProvider,
          serviceType: event.serviceType,
          patient: event.patient)),
    );
  }

  Future<void> _onReduceImage(
    ReduceImage event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(LoadingReduceTest());
    var subscription = event.subscription
        .copyWith(medicalImage: event.subscription.medicalImage - 1);
    /*if (subscription.medicalImage < 0) {
      emit(const ErrorReduceTest(
          'Has excedido la cantidad de imágenes de este plan'));
      return;
    }*/

    var result = await _updateSubscription.call(
        subscription: subscription, uid: subscription.uid);

    result.fold(
      (l) => emit(ErrorReduceTest(l)),
      (r) => emit(SuccessReduceTest(
          medicalTest: event.medicalTest,
          serviceProvider: event.serviceProvider,
          serviceType: event.serviceType,
          patient: event.patient)),
    );
  }

  Future<void> _onStartListeningSubscription(
    StartListeningSubscription event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(LoadingStartListeningSubscription());
    _startListeningSubscription.call(event.uid);
    emit(const SuccessStartListeningSubscription());
  }

  Future<void> _onListenSubscription(
    ListenSubscription event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(LoadingListenSubscription());

    await emit.forEach(
      _listenSubscription.call().asBroadcastStream(),
      onData: (result) => result.fold(
        (l) => ErrorListenSubscription(l),
        (r) => SuccessListenSubscription(subscription: r),
      ),
      onError: (error, stackTrace) => ErrorListenSubscription(error.toString()),
    );
  }

  Future<void> _onStopListeningSubscription(
    StopListeningSubscription event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(LoadingStopListeningSubscription());
    _stopListeningSubscription.call();
    emit(SuccessStopListeningSubscription());
  }
}
