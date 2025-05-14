import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medired/core/value_objects/subscription_type.dart';
import 'package:medired/core/value_objects/transaction_type.dart';
import 'package:medired/features/authentication/domain/entities/patient.dart';
import 'package:medired/features/authentication/domain/entities/session.dart';
import 'package:medired/features/authentication/domain/entities/transaction_response.dart';
import 'package:medired/features/authentication/domain/usecases/remote/update_remote_patient.dart';
import 'package:medired/features/payment/domain/entities/cardnet_session.dart';
import 'package:medired/features/payment/domain/entities/payment.dart';
import 'package:medired/features/payment/domain/usecases/get_response_code.dart';
import 'package:medired/features/payment/domain/usecases/get_test_response_code.dart';
import 'package:medired/features/payment/domain/usecases/post_test_to_cardnet.dart';
import 'package:medired/features/payment/domain/usecases/post_to_cardnet.dart';
import 'package:medired/features/payment/domain/usecases/save_payment.dart';
import 'package:medired/features/payment/domain/usecases/save_session.dart';
import 'package:medired/features/payment/domain/usecases/send_email.dart';
import 'package:medired/features/payment/domain/usecases/validate_payment.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final GetResponseCodeUseCase _getResponseCode;
  final GetTestResponseCodeUseCase _getTestResponseCode;
  final PostToCardnetUseCase _postToCardnet;
  final PostTestToCardnetUseCase _postTestToCardnet;
  final SendEmailUseCase _sendEmail;
  final SavePaymentUseCase _savePayment;
  final SaveSessionUseCase _saveSession;
  final ValidatePaymentUseCase _validatePayment;
  final UpdateRemotePatientUseCase _updateRemotePatient;

  PaymentBloc(
      this._getResponseCode,
      this._getTestResponseCode,
      this._postToCardnet,
      this._postTestToCardnet,
      this._sendEmail,
      this._savePayment,
      this._saveSession,
      this._validatePayment,
      this._updateRemotePatient)
      : super(UnloadedPayment()) {
    on<Pay>(_onPay);
    on<GetResponseCode>(_onGetResponseCode);
    on<GetTestResponseCode>(_onGetTestResponseCode);
    on<PayTest>(_onPayTest);
    on<SendEmail>(_onSendEmail);
    on<SavePayment>(_onSavePayment);
    on<SaveSession>(_onSaveSession);
    on<ValidatePayment>(_onValidatePayment);
    on<UpdateSession>(_onUpdateSession);
    on<UpdateSubscriptionType>(_onUpdateSubscriptionType);
    on<RestartPayment>(_onRestartPayment);
  }

  Future<void> _onPay(Pay event, Emitter<PaymentState> emit) async {
    emit(LoadingTestCardnetPayment());
    final result =
        await _postToCardnet.execute(event.amount.toString(), event.pass);
    result.fold(
      (l) => emit(ErrorCardnetPayment(l)),
      (r) => emit(SuccessCardnetPayment()),
    );
  }

  Future<void> _onGetResponseCode(
      GetResponseCode event, Emitter<PaymentState> emit) async {
    emit(LoadingTestCardnetPayment());
    final result =
        await _getResponseCode.execute(event.session, event.sessionKey);
    result.fold(
      (l) => emit(ErrorResponseCodePayment(l)),
      (r) => emit(SuccessResponseCodePayment(response: r)),
    );
  }

  Future<void> _onGetTestResponseCode(
      GetTestResponseCode event, Emitter<PaymentState> emit) async {
    emit(LoadingTestCardnetPayment());
    final result =
        await _getTestResponseCode.execute(event.session, event.sessionKey);
    result.fold(
      (l) => emit(ErrorTestResponseCodePayment(l)),
      (r) => emit(SuccessTestResponseCodePayment()),
    );
  }

  Future<void> _onPayTest(PayTest event, Emitter<PaymentState> emit) async {
    emit(LoadingTestCardnetPayment());
    final result = await _postTestToCardnet.execute(event.amount.toString(),
        event.pass, event.uid, event.transactionType.index);
    result.fold(
      (l) => emit(ErrorTestCardnetPayment(l)),
      (r) => emit(
          SuccessTestCardnetPayment(cardnetSession: r, amount: event.amount)),
    );
  }

  Future<void> _onSendEmail(SendEmail event, Emitter<PaymentState> emit) async {
    emit(LoadingSendEmail());
    final result =
        await _sendEmail.execute(event.to, event.subject, event.body);
    result.fold(
      (l) => emit(ErrorSendEmail(l)),
      (r) => emit(SuccessSendEmail()),
    );
  }

  Future<void> _onSavePayment(
      SavePayment event, Emitter<PaymentState> emit) async {
    emit(LoadingSavePayment());
    final result = await _savePayment.execute(
      event.uid,
      event.date,
      event.responseCode,
      event.txToken,
      event.referenceNumber,
      event.authorizationCode,
    );
    result.fold(
      (l) => emit(ErrorSavePayment(l)),
      (r) => emit(SuccessSavePayment()),
    );
  }

  Future<void> _onSaveSession(
      SaveSession event, Emitter<PaymentState> emit) async {
    emit(LoadingSaveSession());
    final result = await _saveSession.execute(
        event.uid, event.session, event.sessionKey, event.amount.toString());
    result.fold(
      (l) => emit(ErrorSaveSession(l)),
      (r) => emit(SuccessSaveSession(session: r)),
    );
  }

  Future<void> _onValidatePayment(
      ValidatePayment event, Emitter<PaymentState> emit) async {
    emit(LoadingValidatePayment());
    final result = await _validatePayment.execute(event.payment.id);
    result.fold(
      (l) => emit(ErrorValidatePayment(l)),
      (r) => emit(SuccessValidatePayment()),
    );
  }

  Future<void> _onUpdateSession(
    UpdateSession event,
    Emitter<PaymentState> emit,
  ) async {
    var newCurrentUser = event.patient.copyWith(
      memberInfo: event.patient.memberInfo.copyWith(
        sessions: [event.session],
      ),
    );

    var result = await _updateRemotePatient.call(patient: newCurrentUser);
    result.fold(
      (l) => emit(ErrorUpdateSession(l)),
      (r) => emit(SuccessUpdateSession(
          patient: newCurrentUser, session: event.session)),
    );
  }

  Future<void> _onUpdateSubscriptionType(
    UpdateSubscriptionType event,
    Emitter<PaymentState> emit,
  ) async {
    var newCurrentUser = event.patient.copyWith(
      memberInfo: event.patient.memberInfo.copyWith(
        subscriptionType: event.subscriptionType,
      ),
    );

    var result = await _updateRemotePatient.call(patient: newCurrentUser);

    result.fold(
      (l) => emit(ErrorUpdateSubscriptionType(l)),
      (r) => emit(SuccessUpdateSubscriptionType(payment: event.payment)),
    );
  }

  Future<void> _onRestartPayment(
      RestartPayment event, Emitter<PaymentState> emit) async {
    emit(UnloadedPayment());
  }
}
